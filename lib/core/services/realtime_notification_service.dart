import 'dart:async';
import 'dart:convert';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/api/notifications_api.dart';
import '../../data/api/token_storage.dart';
import '../../data/models/notification_model.dart';
import '../config/app_config.dart';

part 'realtime_notification_service.g.dart';

class RealtimeNotificationService {
  RealtimeNotificationService({
    required this.config,
    required this.tokenStorage,
    required this.notificationsApi,
  }) {
    _initConnectivityListener();
  }

  final AppConfig config;
  final TokenStorage tokenStorage;
  final NotificationsApi notificationsApi;

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
    // Background safety poll: 15s on Web, 30s on Native
    final interval = kIsWeb ? const Duration(seconds: 15) : const Duration(seconds: 30);
    _pollingFallbackTimer = Timer.periodic(interval, (_) async {
      if (!_isRunning) return;
      await _checkLatestNotifications();
    });
  }

  Future<void> _checkLatestNotifications() async {
    final token = await tokenStorage.readToken();
    if (token == null || token.isEmpty) return;

    try {
      final response = await notificationsApi.getUnreadCount();
      if (response.statusCode == 200 && response.data != null) {
        final data = response.data is Map ? (response.data['data'] ?? response.data) : null;
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
    if (kIsWeb) {
      // Browsers do not support ResponseType.stream via Dio XHR/Fetch; fallback to periodic polling
      return;
    }

    int retryCount = 0;
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
          retryCount = 0;
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
        retryCount++;
        if (kDebugMode) {
          // SSE stream reconnect loop
        }
      } finally {
        _cancelToken = null;
      }

      if (_isRunning) {
        final delaySeconds = retryCount > 0 ? (retryCount * 5).clamp(5, 60) : 4;
        await Future.delayed(Duration(seconds: delaySeconds));
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
  final notificationsApi = ref.watch(notificationsApiProvider);
  final service = RealtimeNotificationService(
    config: config,
    tokenStorage: tokenStorage,
    notificationsApi: notificationsApi,
  );

  service.start();

  ref.onDispose(() => service.dispose());
  return service;
}
