import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'token_storage.g.dart';

/// Wraps the bearer token in secure, encrypted storage. Never persisted to
/// shared_preferences — that store is unencrypted plist/XML on disk.
class TokenStorage {
  TokenStorage(this._storage);

  final FlutterSecureStorage _storage;

  static const _tokenKey = 'auth_token';

  // On web, the secure-storage backend initializes a browser CryptoKey
  // asynchronously and can hang indefinitely across a hard page refresh
  // (stale IndexedDB/localStorage keyset). A bounded timeout keeps app
  // bootstrap from stalling forever on a blank splash screen.
  static const _timeout = Duration(seconds: 5);

  Future<String?> readToken() async {
    try {
      return await _storage
          .read(key: _tokenKey)
          .timeout(_timeout, onTimeout: () => null);
    } catch (_) {
      try {
        await _storage.delete(key: _tokenKey);
      } catch (_) {}
      return null;
    }
  }

  Future<void> saveToken(String token) async {
    try {
      await _storage
          .write(key: _tokenKey, value: token)
          .timeout(_timeout, onTimeout: () {});
    } catch (_) {}
  }

  Future<void> clearToken() async {
    try {
      await _storage.delete(key: _tokenKey).timeout(_timeout, onTimeout: () {});
    } catch (_) {}
  }
}

@Riverpod(keepAlive: true)
TokenStorage tokenStorage(Ref ref) {
  return TokenStorage(
    const FlutterSecureStorage(
      aOptions: AndroidOptions(resetOnError: true),
    ),
  );
}
