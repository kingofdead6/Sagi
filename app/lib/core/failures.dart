import 'package:flutter/foundation.dart';

/// Every server and transport error the app can show, already mapped to the
/// kind of message the UI should render.
enum FailureKind {
  network,
  timeout,
  unauthorized,
  forbidden,
  notFound,
  conflict,
  validation,
  rateLimited,
  server,
  unknown,
}

@immutable
class Failure implements Exception {
  const Failure({
    required this.kind,
    this.message,
    this.code,
    this.fieldErrors = const {},
  });

  const Failure.network() : this._simple(FailureKind.network);
  const Failure.timeout() : this._simple(FailureKind.timeout);
  const Failure.unauthorized() : this._simple(FailureKind.unauthorized);
  const Failure.unknown([this.message])
      : kind = FailureKind.unknown,
        code = null,
        fieldErrors = const {};

  const Failure._simple(this.kind)
      : message = null,
        code = null,
        fieldErrors = const {};

  final FailureKind kind;

  /// The server's Arabic message, when it sent one worth showing.
  final String? message;
  final String? code;
  final Map<String, String> fieldErrors;

  bool get isAuth => kind == FailureKind.unauthorized;
  bool get isOffline => kind == FailureKind.network || kind == FailureKind.timeout;

  @override
  String toString() => 'Failure(${kind.name}, code: $code, message: $message)';
}
