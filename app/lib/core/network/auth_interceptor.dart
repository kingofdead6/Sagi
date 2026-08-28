import 'dart:async';

import 'package:dio/dio.dart';
import 'package:saji/core/network/api_endpoints.dart';
import 'package:saji/core/storage/token_storage.dart';

/// Attaches the access token, and on a 401 refreshes once — transparently —
/// before retrying the original request. Concurrent 401s share one refresh.
class AuthInterceptor extends Interceptor {
  AuthInterceptor({
    required TokenStorage storage,
    required Dio retryClient,
    required Future<void> Function() onSessionExpired,
  })  : _storage = storage,
        _retryClient = retryClient,
        _onSessionExpired = onSessionExpired;

  final TokenStorage _storage;

  /// A bare Dio without this interceptor, used for the refresh call and retry.
  final Dio _retryClient;
  final Future<void> Function() _onSessionExpired;

  Future<String?>? _inFlightRefresh;

  static const _skipAuthPaths = {Api.login, Api.register, Api.refresh};

  @override
  Future<void> onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    if (!_skipAuthPaths.contains(options.path)) {
      final token = await _storage.readAccessToken();
      if (token != null) options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  @override
  Future<void> onError(DioException err, ErrorInterceptorHandler handler) async {
    final isAuthFailure = err.response?.statusCode == 401;
    final alreadyRetried = err.requestOptions.extra['saji_retried'] == true;
    final isRefreshCall = err.requestOptions.path == Api.refresh;

    if (!isAuthFailure || alreadyRetried || isRefreshCall) {
      return handler.next(err);
    }

    final newToken = await _refreshOnce();
    if (newToken == null) {
      await _onSessionExpired();
      return handler.next(err);
    }

    try {
      final options = err.requestOptions
        ..headers['Authorization'] = 'Bearer $newToken'
        ..extra['saji_retried'] = true;

      final response = await _retryClient.fetch<dynamic>(options);
      return handler.resolve(response);
    } on DioException catch (retryError) {
      return handler.next(retryError);
    }
  }

  Future<String?> _refreshOnce() {
    return _inFlightRefresh ??= _performRefresh().whenComplete(() {
      _inFlightRefresh = null;
    });
  }

  Future<String?> _performRefresh() async {
    final refreshToken = await _storage.readRefreshToken();
    if (refreshToken == null) return null;

    try {
      final response = await _retryClient.post<Map<String, dynamic>>(
        Api.refresh,
        data: {'refreshToken': refreshToken},
      );
      final data = response.data?['data'] as Map<String, dynamic>?;
      final access = data?['accessToken'] as String?;
      final nextRefresh = data?['refreshToken'] as String?;
      if (access == null || nextRefresh == null) return null;

      await _storage.save(accessToken: access, refreshToken: nextRefresh);
      return access;
    } on DioException {
      await _storage.clear();
      return null;
    }
  }
}
