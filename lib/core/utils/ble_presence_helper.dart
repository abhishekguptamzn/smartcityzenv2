import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class BlePresenceHelper {
  static const int defaultRotationInterval = 15;

  /// Calculate current time window based on rotation interval
  static int calculateWindow({int? intervalSeconds, DateTime? time}) {
    final interval = intervalSeconds ?? defaultRotationInterval;
    final now = (time ?? DateTime.now()).millisecondsSinceEpoch ~/ 1000;
    return now ~/ (interval < 5 ? 5 : interval);
  }

  /// Generate synchronized TOTP / HMAC nonces matching Laravel backend
  static Map<String, dynamic> generateNonces({
    required String facilityId,
    required String secretKey,
    int? intervalSeconds,
    DateTime? time,
  }) {
    final interval = intervalSeconds ?? defaultRotationInterval;
    final now = (time ?? DateTime.now()).millisecondsSinceEpoch ~/ 1000;
    final window = now ~/ (interval < 5 ? 5 : interval);
    final remainingSeconds = interval - (now % interval);

    final secretBytes = utf8.encode(secretKey);

    final qrHmac = Hmac(sha256, secretBytes);
    final qrDigest = qrHmac.convert(utf8.encode('QR:$facilityId:$window'));
    final qrNonce = qrDigest.toString().substring(0, 8).toUpperCase();

    final bleHmac = Hmac(sha256, secretBytes);
    final bleDigest = bleHmac.convert(utf8.encode('BLE:$facilityId:$window'));
    final bleNonce = bleDigest.toString().substring(0, 8).toUpperCase();

    return {
      'qr_nonce': qrNonce,
      'ble_nonce': bleNonce,
      'window': window,
      'remaining_seconds': remainingSeconds,
      'interval': interval,
    };
  }

  /// Check if Bluetooth hardware is active on the device
  static Future<bool> isBluetoothEnabled() async {
    try {
      if (Platform.isAndroid || Platform.isIOS || Platform.isMacOS) {
        final state = await FlutterBluePlus.adapterState.first;
        return state == BluetoothAdapterState.on;
      }
      return true;
    } catch (_) {
      return true;
    }
  }

  /// Request system to turn ON Bluetooth (shows system popup dialog on Android)
  static Future<bool> requestEnableBluetooth() async {
    try {
      if (Platform.isAndroid) {
        await FlutterBluePlus.turnOn();
        // Wait up to 3 seconds for state to change to ON
        final state = await FlutterBluePlus.adapterState
            .where((s) => s == BluetoothAdapterState.on)
            .first
            .timeout(const Duration(seconds: 3), onTimeout: () => BluetoothAdapterState.off);
        return state == BluetoothAdapterState.on;
      }
      return await isBluetoothEnabled();
    } catch (_) {
      return false;
    }
  }

  /// Scan for nearby BLE beacon matching the facility's service UUID
  static Future<Map<String, dynamic>?> scanForFacilityBeacon({
    required String targetUuid,
    Duration timeout = const Duration(seconds: 2),
  }) async {
    try {
      if (!Platform.isAndroid && !Platform.isIOS && !Platform.isMacOS) {
        // Desktop / Web Mock Fallback
        return {
          'ble_nonce': null,
          'rssi': -60,
          'success': true,
        };
      }

      final isEnabled = await isBluetoothEnabled();
      if (!isEnabled) {
        return null;
      }

      final normalizedTargetUuid = targetUuid.toLowerCase().replaceAll('-', '');
      ScanResult? matchedResult;
      String? extractedNonce;

      // Listen for incoming scan results
      final sub = FlutterBluePlus.scanResults.listen((results) {
        for (final r in results) {
          final advData = r.advertisementData;
          final serviceUuids = advData.serviceUuids
              .map((u) => u.toString().toLowerCase().replaceAll('-', ''))
              .toList();

          bool matchesUuid = serviceUuids.contains(normalizedTargetUuid);
          if (!matchesUuid && advData.advName.isNotEmpty) {
            if (advData.advName.toLowerCase().contains(normalizedTargetUuid.substring(0, 8))) {
              matchesUuid = true;
            }
          }

          if (matchesUuid) {
            matchedResult = r;

            // Look for 8-char hex nonce in service data or manufacturer data
            for (final entry in advData.serviceData.entries) {
              if (entry.value.isNotEmpty) {
                final str = String.fromCharCodes(entry.value).trim().toUpperCase();
                if (str.length >= 6) {
                  extractedNonce = str;
                  break;
                }
              }
            }

            if (extractedNonce == null && advData.manufacturerData.isNotEmpty) {
              for (final bytes in advData.manufacturerData.values) {
                if (bytes.isNotEmpty) {
                  final str = String.fromCharCodes(bytes).trim().toUpperCase();
                  if (str.length >= 6) {
                    extractedNonce = str;
                    break;
                  }
                }
              }
            }
          }
        }
      });

      // Start scan with target filter if possible
      await FlutterBluePlus.startScan(
        timeout: timeout,
        androidUsesFineLocation: false,
      );

      await Future.delayed(timeout);
      await FlutterBluePlus.stopScan();
      await sub.cancel();

      if (matchedResult != null) {
        return {
          'rssi': matchedResult!.rssi,
          'ble_nonce': extractedNonce,
          'device_id': matchedResult!.device.remoteId.str,
          'success': true,
        };
      }

      return null;
    } catch (_) {
      return null;
    }
  }
}
