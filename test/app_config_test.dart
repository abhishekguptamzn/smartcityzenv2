import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_test/flutter_test.dart';
import 'package:smartcityzenv2/core/config/app_config.dart';

void main() {
  group('AppConfig platformDefaultBaseUrl', () {
    test('returns correct versioned API URL according to platform', () {
      final defaultUrl = AppConfig.platformDefaultBaseUrl();
      if (kIsWeb) {
        expect(defaultUrl, equals('https://admin.smartct.online/api/v2'));
      } else {
        expect(defaultUrl, equals('https://admin.smartct.online/api/v1'));
      }
    });

    test('defaults() reflects platformDefaultBaseUrl', () {
      final defaults = AppConfig.defaults();
      expect(defaults.apiBaseUrl, equals(AppConfig.platformDefaultBaseUrl()));
    });
  });
}
