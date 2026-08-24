import 'dart:async';
import 'dart:convert';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/api/token_storage.dart';
import '../../data/models/notification_model.dart';
import '../config/app_config.dart';

part 'realtime_notification_service.g.dart';

class RealtimeNotificationService {
  RealtimeNotificationService({
    required this.config,
    required this.tokenStorage,
  }) {
    _initConnectivityListener();
  }

  final AppConfig config;
  final TokenStorage tokenStorage;

  final _notificationController =
      StreamController<NotificationModel>.broadcast();
  final _unreadCountController = StreamController<int>.broadcast();

  Stream<NotificationModel> get notificationStream =>
      _notificationController.stream;
  Stream<int> get unreadCountStream => _unreadCountController.stream;

  bool _isRunning = false;
  CancelToken? _cancelToken;
  StreamSubscription<List<ConnectivityResult>>? _connectivitySub;
  Timer? _pollingFallbackTimer;

  void _initConnectivityListener() {
    _connectivitySub = Connectivity().onConnectivityChanged.listen((results) {
      final isConnected =
          results.isNotEmpty && !results.contains(ConnectivityResult.none);
      if (isConnected && _isRunning && _cancelToken == null) {
        start();
      }
    });
  }

  /// Start listening for real-time notifications.
  Future<void> start() async {
    if (_isRunning) return;
    _isRunning = true;
    _startSSEConnection();
    _startPollingFallback();
  }

  /// Stop listening and clean up.
  void stop() {
    _isRunning = false;
    _cancelToken?.cancel();
    _cancelToken = null;
    _pollingFallbackTimer?.cancel();
    _pollingFallbackTimer = null;
  }

  void _startPollingFallback() {
    _pollingFallbackTimer?.cancel();
    // Background safety poll every 30 seconds
    _pollingFallbackTimer =
        Timer.periodic(const Duration(seconds: 30), (_) async {
      if (!_isRunning) return;
      await _checkLatestNotifications();
    });
  }

  Future<void> _checkLatestNotifications() async {
    final token = await tokenStorage.readToken();
    if (token == null || token.isEmpty) return;

    try {
      final dio = Dio(
        BaseOptions(
          baseUrl: config.apiBaseUrl,
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
          },
          connectTimeout: const Duration(seconds: 10),
          receiveTimeout: const Duration(seconds: 10),
        ),
      );

      final response = await dio.get('/notifications/unread-count');
      if (response.statusCode == 200 && response.data != null) {
        final data = response.data['data'] as Map<String, dynamic>?;
        final count = (data?['unread_count'] as num?)?.toInt();
        if (count != null && !_unreadCountController.isClosed) {
          _unreadCountController.add(count);
        }
      }
    } catch (_) {
      // Polling network blip, silently ignore
    }
  }

  Future<void> _startSSEConnection() async {
    while (_isRunning) {
      final token = await tokenStorage.readToken();
      if (token == null || token.isEmpty) {
        await Future.delayed(const Duration(seconds: 5));
        continue;
      }

      _cancelToken = CancelToken();

      try {
        final dio = Dio(
          BaseOptions(
            baseUrl: config.apiBaseUrl,
            headers: {
              'Authorization': 'Bearer $token',
              'Accept': 'text/event-stream',
              'Cache-Control': 'no-cache',
            },
            responseType: ResponseType.stream,
            connectTimeout: const Duration(seconds: 15),
            receiveTimeout: const Duration(seconds: 40),
          ),
        );

        final response = await dio.get<ResponseBody>(
          '/notifications/stream',
          cancelToken: _cancelToken,
        );

        if (response.data != null) {
          final stream = response.data!.stream;
          String buffer = '';

          await for (final chunk in stream) {
            if (!_isRunning) break;
            final text = utf8.decode(chunk);
            buffer += text;

            final lines = buffer.split('\n');
            buffer = lines.removeLast(); // Keep incomplete trailing fragment

            String? currentEvent;
            for (final line in lines) {
              final trimmed = line.trim();
              if (trimmed.isEmpty) continue;

              if (trimmed.startsWith('event:')) {
                currentEvent = trimmed.substring(6).trim();
              } else if (trimmed.startsWith('data:')) {
                final dataStr = trimmed.substring(5).trim();
                _handleSSEEvent(currentEvent, dataStr);
              }
            }
          }
        }
      } catch (e) {
        if (kDebugMode) {
          // SSE stream reconnect loop
        }
      } finally {
        _cancelToken = null;
      }

      if (_isRunning) {
        await Future.delayed(const Duration(seconds: 4));
      }
    }
  }

  void _handleSSEEvent(String? event, String dataStr) {
    try {
      final json = jsonDecode(dataStr) as Map<String, dynamic>;

      if (event == 'connected' || event == 'ping') {
        final unreadCount = (json['unread_count'] as num?)?.toInt();
        if (unreadCount != null && !_unreadCountController.isClosed) {
          _unreadCountController.add(unreadCount);
        }
      } else if (event == 'notification') {
        final notifData = json['notification'] as Map<String, dynamic>?;
        if (notifData != null) {
          final notification = NotificationModel.fromJson(notifData);
          if (!_notificationController.isClosed) {
            _notificationController.add(notification);
          }
        }

        final unreadCount = (json['unread_count'] as num?)?.toInt();
        if (unreadCount != null && !_unreadCountController.isClosed) {
          _unreadCountController.add(unreadCount);
        }
      }
    } catch (_) {
      // Malformed SSE data ignore
    }
  }

  void dispose() {
    stop();
    _connectivitySub?.cancel();
    _notificationController.close();
    _unreadCountController.close();
  }
}

@Riverpod(keepAlive: true)
RealtimeNotificationService realtimeNotificationService(Ref ref) {
  final config = ref.watch(appConfigControllerProvider);
  final tokenStorage = ref.watch(tokenStorageProvider);
  final service = RealtimeNotificationService(
    config: config,
    tokenStorage: tokenStorage,
  );

  service.start();

  ref.onDispose(() => service.dispose());
  return service;
}
