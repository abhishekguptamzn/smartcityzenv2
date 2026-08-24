import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smartcityzenv2/core/utils/ble_presence_helper.dart';

void main() {
  group('BlePresenceHelper Tests', () {
    test('generateNonces computes valid 8-char hex HMAC nonces for QR and BLE', () {
      const facilityId = 'GYM-2026-TEST';
      const secretKey = 'secret-test-key-1234567890123456';
      final fixedTime = DateTime.fromMillisecondsSinceEpoch(1700000000000); // fixed epoch timestamp

      final nonces = BlePresenceHelper.generateNonces(
        facilityId: facilityId,
        secretKey: secretKey,
        intervalSeconds: 15,
        time: fixedTime,
      );

      expect(nonces['qr_nonce'], isA<String>());
      expect((nonces['qr_nonce'] as String).length, 8);
      expect(nonces['ble_nonce'], isA<String>());
      expect((nonces['ble_nonce'] as String).length, 8);
      expect(nonces['qr_nonce'], isNot(equals(nonces['ble_nonce'])));

      // Validate exact HMAC-SHA256 algorithm
      final window = 1700000000 ~/ 15;
      final secretBytes = utf8.encode(secretKey);

      final expectedQr = Hmac(sha256, secretBytes)
          .convert(utf8.encode('QR:$facilityId:$window'))
          .toString()
          .substring(0, 8)
          .toUpperCase();

      final expectedBle = Hmac(sha256, secretBytes)
          .convert(utf8.encode('BLE:$facilityId:$window'))
          .toString()
          .substring(0, 8)
          .toUpperCase();

      expect(nonces['qr_nonce'], equals(expectedQr));
      expect(nonces['ble_nonce'], equals(expectedBle));
      expect(nonces['window'], equals(window));
    });

    test('calculateWindow returns consistent integer intervals', () {
      final t1 = DateTime.fromMillisecondsSinceEpoch(15000 * 1000 + 2000); // 15002s -> window 1000
      final t2 = DateTime.fromMillisecondsSinceEpoch(15000 * 1000 + 14000); // 15014s -> window 1000
      final t3 = DateTime.fromMillisecondsSinceEpoch(15000 * 1000 + 15000); // 15015s -> window 1001

      final w1 = BlePresenceHelper.calculateWindow(intervalSeconds: 15, time: t1);
      final w2 = BlePresenceHelper.calculateWindow(intervalSeconds: 15, time: t2);
      final w3 = BlePresenceHelper.calculateWindow(intervalSeconds: 15, time: t3);

      expect(w1, equals(1000));
      expect(w2, equals(1000));
      expect(w3, equals(1001));
    });
  });
}
