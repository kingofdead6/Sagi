import 'package:dio/dio.dart';
import 'package:saji/core/failures.dart';

/// Maps transport and server errors onto the [Failure] kinds the UI renders.
abstract final class ApiErrorMapper {
  static Failure fromDio(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return const Failure.timeout();
      case DioExceptionType.connectionError:
      case DioExceptionType.unknown:
        return const Failure.network();
      case DioExceptionType.cancel:
        return const Failure(kind: FailureKind.unknown);
      case DioExceptionType.badCertificate:
        return const Failure(kind: FailureKind.network);
      case DioExceptionType.badResponse:
        return _fromResponse(error.response);
      // ignore: deprecated_member_use — kept so new Dio enum members still compile
      case DioExceptionType.transformTimeout:
        return const Failure.timeout();
    }
  }

  static Failure _fromResponse(Response<dynamic>? response) {
    final status = response?.statusCode ?? 0;
    final body = response?.data;
    final message = body is Map && body['message'] is String ? body['message'] as String : null;
    final code = body is Map && body['code'] is String ? body['code'] as String : null;

    final fieldErrors = <String, String>{};
    if (body is Map && body['details'] is List) {
      for (final detail in body['details'] as List) {
        if (detail is Map && detail['path'] is String && detail['message'] is String) {
          fieldErrors[detail['path'] as String] = detail['message'] as String;
        }
      }
    }

    final kind = switch (status) {
      400 => FailureKind.validation,
      401 => FailureKind.unauthorized,
      403 => FailureKind.forbidden,
      404 => FailureKind.notFound,
      409 => FailureKind.conflict,
      429 => FailureKind.rateLimited,
      >= 500 => FailureKind.server,
      _ => FailureKind.unknown,
    };

    return Failure(kind: kind, message: message, code: code, fieldErrors: fieldErrors);
  }
}
