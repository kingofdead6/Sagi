import 'package:saji/core/network/api_endpoints.dart';
import 'package:saji/core/network/dio_client.dart';
import 'package:saji/core/result.dart';
import 'package:saji/core/storage/token_storage.dart';
import 'package:saji/features/auth/domain/user.dart';

class AuthRepository {
  AuthRepository({required ApiClient client, required TokenStorage storage})
      : _client = client,
        _storage = storage;

  final ApiClient _client;
  final TokenStorage _storage;

  Future<Result<AuthSession>> register({
    required String phone,
    required String password,
    required String fullName,
  }) async {
    final result = await _client.post<AuthSession>(
      Api.register,
      body: {'phone': phone, 'password': password, 'fullName': fullName},
      parse: (data) => AuthSession.fromJson(data as Map<String, dynamic>),
    );
    return _persist(result);
  }

  Future<Result<AuthSession>> login({
    required String phone,
    required String password,
  }) async {
    final result = await _client.post<AuthSession>(
      Api.login,
      body: {'phone': phone, 'password': password},
      parse: (data) => AuthSession.fromJson(data as Map<String, dynamic>),
    );
    return _persist(result);
  }

  Future<Result<AuthSession>> _persist(Result<AuthSession> result) async {
    if (result case Ok(:final value)) {
      await _storage.save(
        accessToken: value.accessToken,
        refreshToken: value.refreshToken,
      );
    }
    return result;
  }

  Future<Result<AppUser>> me() => _client.get<AppUser>(
        Api.me,
        parse: (data) => AppUser.fromJson(data as Map<String, dynamic>),
      );

  Future<Result<AppUser>> updateProfile({String? fullName, String? defaultAddress}) =>
      _client.patch<AppUser>(
        Api.me,
        body: {
          if (fullName != null) 'fullName': fullName,
          if (defaultAddress != null) 'defaultAddress': defaultAddress,
        },
        parse: (data) => AppUser.fromJson(data as Map<String, dynamic>),
      );

  Future<Result<void>> changePassword({
    required String currentPassword,
    required String newPassword,
  }) =>
      _client.post<void>(
        Api.changePassword,
        body: {'currentPassword': currentPassword, 'newPassword': newPassword},
        parse: (_) {},
      );

  Future<Result<void>> registerFcmToken(String token, String platform) => _client.post<void>(
        Api.fcmToken,
        body: {'token': token, 'platform': platform},
        parse: (_) {},
      );

  /// Best-effort server-side revoke, then always clear local tokens.
  Future<void> logout() async {
    final refreshToken = await _storage.readRefreshToken();
    await _client.post<void>(
      Api.logout,
      body: {if (refreshToken != null) 'refreshToken': refreshToken},
      parse: (_) {},
    );
    await _storage.clear();
  }

  Future<bool> hasStoredSession() async => (await _storage.readRefreshToken()) != null;
}
