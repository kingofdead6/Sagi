import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:saji/core/failures.dart';
import 'package:saji/core/network/api_endpoints.dart';
import 'package:saji/core/network/api_exception.dart';
import 'package:saji/core/network/auth_interceptor.dart';
import 'package:saji/core/result.dart';
import 'package:saji/core/storage/token_storage.dart';

/// The one HTTP client. Every response is the `{success, data, message}`
/// envelope the API always returns, unwrapped here into a [Result].
class ApiClient {
  ApiClient({
    required TokenStorage storage,
    required Future<void> Function() onSessionExpired,
    Dio? dio,
  }) : _dio = dio ?? Dio(_baseOptions) {
    final retryClient = Dio(_baseOptions);

    _dio.interceptors.add(
      AuthInterceptor(
        storage: storage,
        retryClient: retryClient,
        onSessionExpired: onSessionExpired,
      ),
    );

    if (kDebugMode) {
      _dio.interceptors.add(
        PrettyDioLogger(requestBody: true, responseBody: false, compact: true),
      );
    }
  }

  static BaseOptions get _baseOptions => BaseOptions(
        baseUrl: Api.baseUrl,
        connectTimeout: const Duration(seconds: 12),
        receiveTimeout: const Duration(seconds: 20),
        sendTimeout: const Duration(seconds: 20),
        contentType: 'application/json',
        headers: {'Accept': 'application/json'},
      );

  final Dio _dio;

  Dio get raw => _dio;

  Future<Result<T>> get<T>(
    String path, {
    required T Function(dynamic data) parse,
    Map<String, dynamic>? query,
  }) =>
      _send(() => _dio.get<dynamic>(path, queryParameters: query), parse);

  Future<Result<T>> post<T>(
    String path, {
    required T Function(dynamic data) parse,
    Object? body,
    Map<String, dynamic>? query,
  }) =>
      _send(() => _dio.post<dynamic>(path, data: body, queryParameters: query), parse);

  Future<Result<T>> patch<T>(
    String path, {
    required T Function(dynamic data) parse,
    Object? body,
  }) =>
      _send(() => _dio.patch<dynamic>(path, data: body), parse);

  Future<Result<T>> delete<T>(
    String path, {
    required T Function(dynamic data) parse,
    Object? body,
  }) =>
      _send(() => _dio.delete<dynamic>(path, data: body), parse);

  Future<Result<T>> _send<T>(
    Future<Response<dynamic>> Function() request,
    T Function(dynamic data) parse,
  ) async {
    try {
      final response = await request();
      final body = response.data;
      final payload = body is Map<String, dynamic> ? body['data'] : body;
      return Result.ok(parse(payload));
    } on DioException catch (error) {
      return Result.err(ApiErrorMapper.fromDio(error));
    } catch (error) {
      // A parse failure is a bug, not a transport problem — surface it clearly.
      return Result.err(Failure.unknown(error.toString()));
    }
  }
}
