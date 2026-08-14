import 'dart:async';
import 'dart:io' show Platform;

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../data/api/token_storage.dart';
import '../config/app_config.dart';

class IncidentReporter {
  IncidentReporter._();

  static final Dio _reportingDio = Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 8),
      receiveTimeout: const Duration(seconds: 8),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
    ),
  );

  static final TokenStorage _tokenStorage = TokenStorage(const FlutterSecureStorage());
  static final Set<String> _recentIncidentKeys = {};
  static PackageInfo? _packageInfo;

  /// Initialize package metadata
  static Future<void> initialize() async {
    try {
      _packageInfo = await PackageInfo.fromPlatform();
    } catch (_) {}
  }

  /// Automatically report any unhandled Flutter error, zone exception, or network failure to the backend.
  static Future<void> reportError({
    required dynamic error,
    dynamic stackTrace,
    String? exceptionClass,
    String? message,
    String? url,
    String? method,
    int? code,
    String severity = 'error',
    Map<String, dynamic>? payload,
    String? file,
    int? line,
  }) async {
    try {
      final errorMsg = message ?? error?.toString() ?? 'Unknown application error';
      final errClass = exceptionClass ?? (error != null ? error.runtimeType.toString() : 'FlutterClientException');
      final traceStr = stackTrace?.toString() ?? (error is Error ? error.stackTrace?.toString() : '') ?? '';

      // Deduplicate identical errors within 30 seconds
      final dedupKey = '$errClass:$errorMsg';
      if (_recentIncidentKeys.contains(dedupKey)) {
        return;
      }
      _recentIncidentKeys.add(dedupKey);
      Future.delayed(const Duration(seconds: 30), () {
        _recentIncidentKeys.remove(dedupKey);
      });

      // Parse file & line from trace if not explicitly provided
      String? resolvedFile = file;
      int? resolvedLine = line;
      if (resolvedFile == null && traceStr.isNotEmpty) {
        final lineMatch = RegExp(r'#0\s+(?:.+?\s+\()?(.*?):(\d+):').firstMatch(traceStr);
        if (lineMatch != null) {
          resolvedFile = lineMatch.group(1);
          resolvedLine = int.tryParse(lineMatch.group(2) ?? '');
        }
      }

      // Collect device metadata
      String platformName = 'web';
      if (!kIsWeb) {
        try {
          if (Platform.isAndroid) {
            platformName = 'android';
          } else if (Platform.isIOS) {
            platformName = 'ios';
          } else if (Platform.isMacOS) {
            platformName = 'macos';
          } else if (Platform.isWindows) {
            platformName = 'windows';
          } else if (Platform.isLinux) {
            platformName = 'linux';
          }
        } catch (_) {}
      }

      final deviceInfo = {
        'platform': platformName,
        'app_version': _packageInfo?.version ?? '1.0.0',
        'build_number': _packageInfo?.buildNumber ?? '1',
        'is_debug': kDebugMode,
        'screen_size': '${PlatformDispatcher.instance.views.firstOrNull?.physicalSize.width ?? 0}x${PlatformDispatcher.instance.views.firstOrNull?.physicalSize.height ?? 0}',
      };

      final token = await _tokenStorage.readToken();
      final baseUrl = AppConfig.platformDefaultBaseUrl();
      final targetUrl = '$baseUrl/incidents';

      final requestData = {
        'exception_class': errClass,
        'message': errorMsg,
        'code': code ?? 500,
        'file': resolvedFile,
        'line': resolvedLine,
        'trace': traceStr.length > 5000 ? traceStr.substring(0, 5000) : traceStr,
        'url': url ?? 'flutter://app',
        'method': method ?? 'CLIENT',
        'severity': severity,
        'payload': payload,
        'device_info': deviceInfo,
      };

      final headers = <String, dynamic>{
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      };
      if (token != null && token.isNotEmpty) {
        headers['Authorization'] = 'Bearer $token';
      }

      await _reportingDio.post(
        targetUrl,
        data: requestData,
        options: Options(headers: headers),
      );
    } catch (_) {
      // Never crash the reporting system
    }
  }
}
