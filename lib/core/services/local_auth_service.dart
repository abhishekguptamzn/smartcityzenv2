import 'dart:convert';
import 'dart:math';
import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:local_auth/local_auth.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'local_auth_service.g.dart';

class LocalAuthService {
  LocalAuthService({
    LocalAuthentication? auth,
    FlutterSecureStorage? storage,
  })  : _auth = auth ?? LocalAuthentication(),
        _storage = storage ?? const FlutterSecureStorage();

  final LocalAuthentication _auth;
  final FlutterSecureStorage _storage;

  static const _keyAppLockEnabled = 'app_lock_enabled';
  static const _keyUseBiometrics = 'app_lock_use_biometrics';
  static const _keyPinHash = 'app_lock_pin_hash';
  static const _keyPinSalt = 'app_lock_salt';
  static const _keyAutoLockDelay = 'app_lock_auto_lock_delay';

  /// Check if hardware supports local biometric checks (Fingerprint, Face ID)
  Future<bool> isBiometricsSupported() async {
    if (kIsWeb) return false;
    try {
      final isSupported = await _auth.isDeviceSupported();
      final canCheck = await _auth.canCheckBiometrics;
      return isSupported && canCheck;
    } catch (_) {
      return false;
    }
  }

  /// Get list of available biometric sensors
  Future<List<BiometricType>> getAvailableBiometrics() async {
    if (kIsWeb) return [];
    try {
      return await _auth.getAvailableBiometrics();
    } catch (_) {
      return [];
    }
  }

  /// Trigger system biometric authentication prompt
  Future<bool> authenticateWithBiometrics({
    String reason = 'Authenticate to access Smart CityZen',
  }) async {
    if (kIsWeb) return false;
    try {
      final supported = await isBiometricsSupported();
      if (!supported) return false;

      return await _auth.authenticate(
        localizedReason: reason,
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: false,
          useErrorDialogs: true,
        ),
      );
    } on PlatformException catch (_) {
      return false;
    } catch (_) {
      return false;
    }
  }

  /// Whether the user has configured local app lock (or admin requires it)
  Future<bool> isAppLockEnabled() async {
    final val = await _storage.read(key: _keyAppLockEnabled);
    return val == 'true';
  }

  Future<void> setAppLockEnabled(bool enabled) async {
    await _storage.write(key: _keyAppLockEnabled, value: enabled.toString());
  }

  /// Whether user enabled Biometrics in addition to PIN
  Future<bool> isBiometricsEnabled() async {
    final val = await _storage.read(key: _keyUseBiometrics);
    // Defaults to true if not set yet, so long as biometrics is available
    if (val == null) return true;
    return val == 'true';
  }

  Future<void> setBiometricsEnabled(bool enabled) async {
    await _storage.write(key: _keyUseBiometrics, value: enabled.toString());
  }

  /// Check if user has set a local PIN
  Future<bool> hasConfiguredPin() async {
    final hash = await _storage.read(key: _keyPinHash);
    return hash != null && hash.isNotEmpty;
  }

  /// Save new PIN with cryptographic salt + SHA-256
  Future<bool> setAppPin(String pin) async {
    if (pin.length < 4) return false;

    final salt = _generateSalt();
    final hash = _hashPin(pin, salt);

    await _storage.write(key: _keyPinSalt, value: salt);
    await _storage.write(key: _keyPinHash, value: hash);
    await _storage.write(key: _keyAppLockEnabled, value: 'true');

    return true;
  }

  /// Verify entered PIN against stored salted hash
  Future<bool> verifyAppPin(String pin) async {
    final storedHash = await _storage.read(key: _keyPinHash);
    final storedSalt = await _storage.read(key: _keyPinSalt);

    if (storedHash == null || storedSalt == null) return false;

    final computedHash = _hashPin(pin, storedSalt);
    return computedHash == storedHash;
  }

  /// Remove configured PIN and disable local lock
  Future<void> removeAppPin() async {
    await _storage.delete(key: _keyPinHash);
    await _storage.delete(key: _keyPinSalt);
    await _storage.delete(key: _keyAppLockEnabled);
    await _storage.delete(key: _keyUseBiometrics);
  }

  /// Auto-lock delay in seconds (0 = immediately on minimize, 60 = 1 min, 300 = 5 min)
  Future<int> getAutoLockDelaySeconds() async {
    final val = await _storage.read(key: _keyAutoLockDelay);
    return int.tryParse(val ?? '') ?? 0;
  }

  Future<void> setAutoLockDelaySeconds(int seconds) async {
    await _storage.write(key: _keyAutoLockDelay, value: seconds.toString());
  }

  String _generateSalt([int length = 32]) {
    final rand = Random.secure();
    final bytes = List<int>.generate(length, (i) => rand.nextInt(256));
    return base64Url.encode(bytes);
  }

  String _hashPin(String pin, String salt) {
    final bytes = utf8.encode('$salt:$pin');
    return sha256.convert(bytes).toString();
  }
}

@Riverpod(keepAlive: true)
LocalAuthService localAuthService(Ref ref) {
  return LocalAuthService();
}
