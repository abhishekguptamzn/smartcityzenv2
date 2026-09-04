import 'package:flutter/foundation.dart' show kDebugMode, kIsWeb;
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/image_url_resolver.dart';

part 'app_config.g.dart';

class AppConfig {
  const AppConfig({
    required this.apiBaseUrl,
    required this.connectTimeoutMs,
    required this.receiveTimeoutMs,
    required this.enableRequestLogging,
  });

  final String apiBaseUrl;
  final int connectTimeoutMs;
  final int receiveTimeoutMs;
  final bool enableRequestLogging;

  static const _compileTimeApiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: '',
  );

  /// 10.0.2.2 is the special alias the Android emulator uses to reach the
  /// host machine's localhost; a physical device or iOS/web target needs
  /// the host's real address instead, which is why this is only a seed
  /// default and not hardcoded elsewhere in the app.
  static String platformDefaultBaseUrl() {
    if (_compileTimeApiBaseUrl.isNotEmpty) return _compileTimeApiBaseUrl;
    if (kIsWeb) {
      return 'https://admin.smartct.online/api/v2';
    }
    return 'https://admin.smartct.online/api/v1';
  }

  static AppConfig defaults() {
    final defaultUrl = platformDefaultBaseUrl();
    ImageUrlResolver.setActiveBaseUrl(defaultUrl);
    return AppConfig(
      apiBaseUrl: defaultUrl,
      connectTimeoutMs: 15000,
      receiveTimeoutMs: 20000,
      enableRequestLogging: !kIsWeb && kDebugMode,
    );
  }

  AppConfig copyWith({
    String? apiBaseUrl,
    int? connectTimeoutMs,
    int? receiveTimeoutMs,
    bool? enableRequestLogging,
  }) {
    return AppConfig(
      apiBaseUrl: apiBaseUrl ?? this.apiBaseUrl,
      connectTimeoutMs: connectTimeoutMs ?? this.connectTimeoutMs,
      receiveTimeoutMs: receiveTimeoutMs ?? this.receiveTimeoutMs,
      enableRequestLogging: enableRequestLogging ?? this.enableRequestLogging,
    );
  }
}

class _Keys {
  static const apiBaseUrl = 'config.api_base_url';
  static const connectTimeoutMs = 'config.connect_timeout_ms';
  static const receiveTimeoutMs = 'config.receive_timeout_ms';
  static const enableRequestLogging = 'config.enable_request_logging';
}

@Riverpod(keepAlive: true)
class AppConfigController extends _$AppConfigController {
  @override
  AppConfig build() {
    _hydrate();
    return AppConfig.defaults();
  }

  Future<void> _hydrate() async {
    final prefs = await SharedPreferences.getInstance();
    final defaults = AppConfig.defaults();
    var url = prefs.getString(_Keys.apiBaseUrl);
    if (url == null || url.contains('127.0.0.1') || url.contains('localhost')) {
      url = defaults.apiBaseUrl;
    }
    if (kIsWeb && url.contains('/api/v1')) {
      url = url.replaceAll('/api/v1', '/api/v2');
    }
    ImageUrlResolver.setActiveBaseUrl(url);
    state = AppConfig(
      apiBaseUrl: url,
      connectTimeoutMs:
          prefs.getInt(_Keys.connectTimeoutMs) ?? defaults.connectTimeoutMs,
      receiveTimeoutMs:
          prefs.getInt(_Keys.receiveTimeoutMs) ?? defaults.receiveTimeoutMs,
      enableRequestLogging:
          prefs.getBool(_Keys.enableRequestLogging) ??
          defaults.enableRequestLogging,
    );
  }

  Future<void> updateApiBaseUrl(String url) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_Keys.apiBaseUrl, url);
    ImageUrlResolver.setActiveBaseUrl(url);
    state = state.copyWith(apiBaseUrl: url);
  }

  Future<void> updateTimeouts({
    required int connectTimeoutMs,
    required int receiveTimeoutMs,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_Keys.connectTimeoutMs, connectTimeoutMs);
    await prefs.setInt(_Keys.receiveTimeoutMs, receiveTimeoutMs);
    state = state.copyWith(
      connectTimeoutMs: connectTimeoutMs,
      receiveTimeoutMs: receiveTimeoutMs,
    );
  }

  Future<void> updateRequestLogging(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_Keys.enableRequestLogging, enabled);
    state = state.copyWith(enableRequestLogging: enabled);
  }

  Future<void> resetToDefaults() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_Keys.apiBaseUrl);
    await prefs.remove(_Keys.connectTimeoutMs);
    await prefs.remove(_Keys.receiveTimeoutMs);
    await prefs.remove(_Keys.enableRequestLogging);
    final defaults = AppConfig.defaults();
    ImageUrlResolver.setActiveBaseUrl(defaults.apiBaseUrl);
    state = defaults;
  }
}
