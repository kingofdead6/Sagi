import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Tokens live in the platform keystore, never in shared preferences.
class TokenStorage {
  TokenStorage([FlutterSecureStorage? storage])
      : _storage = storage ??
            const FlutterSecureStorage(
              aOptions: AndroidOptions(encryptedSharedPreferences: true),
            );

  static const _accessKey = 'saji.access_token';
  static const _refreshKey = 'saji.refresh_token';

  final FlutterSecureStorage _storage;

  String? _cachedAccess;

  /// Kept in memory too so the Dio interceptor never awaits on the hot path.
  String? get cachedAccessToken => _cachedAccess;

  Future<String?> readAccessToken() async {
    final cached = _cachedAccess;
    if (cached != null) return cached;
    return _cachedAccess = await _storage.read(key: _accessKey);
  }

  Future<String?> readRefreshToken() => _storage.read(key: _refreshKey);

  Future<void> save({required String accessToken, required String refreshToken}) async {
    _cachedAccess = accessToken;
    await _storage.write(key: _accessKey, value: accessToken);
    await _storage.write(key: _refreshKey, value: refreshToken);
  }

  Future<void> saveAccessToken(String accessToken) async {
    _cachedAccess = accessToken;
    await _storage.write(key: _accessKey, value: accessToken);
  }

  Future<void> clear() async {
    _cachedAccess = null;
    await _storage.delete(key: _accessKey);
    await _storage.delete(key: _refreshKey);
  }
}
