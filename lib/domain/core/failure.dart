import 'package:bourgo_arena_mobile/domain/core/app_error_code.dart';

/// Base sealed class for all failures in the application.
sealed class Failure {
  final AppErrorCode code;
  final String message;
  final String? state;
  final String? token;

  const Failure(this.code, this.message, {this.state, this.token});

  /// Helper for generic server/unexpected errors.
  factory Failure.unexpected([String? message]) => ServerFailure(
    AppErrorCode.serverError,
    message ?? 'Unexpected error occurred',
  );

  factory Failure.network(AppErrorCode code, String message) =>
      NetworkFailure(code, message);
  factory Failure.auth(
    AppErrorCode code,
    String message, [
    String? state,
    String? token,
  ]) => AuthFailure(code, message, state, token);
  factory Failure.server(
    AppErrorCode code,
    String message, [
    String? state,
    String? token,
  ]) => ServerFailure(code, message, state, token);
  factory Failure.notFound(
    AppErrorCode code,
    String message, [
    String? state,
    String? token,
  ]) => NotFoundFailure(code, message, state, token);
  factory Failure.cache(AppErrorCode code, String message) =>
      CacheFailure(code, message);
  factory Failure.validation(
    AppErrorCode code,
    String message, [
    String? state,
    String? token,
  ]) => ValidationFailure(code, message, state, token);
}

/// Represents a failure that occurred due to a network or server issue.
class NetworkFailure extends Failure {
  const NetworkFailure(super.code, super.message);
}

/// Represents a failure due to unauthorized access or authentication errors.
class AuthFailure extends Failure {
  const AuthFailure(super.code, super.message, [String? state, String? token])
    : super(state: state, token: token);
}

/// Represents a failure due to unexpected or generic errors.
class ServerFailure extends Failure {
  const ServerFailure(super.code, super.message, [String? state, String? token])
    : super(state: state, token: token);
}

/// Represents a failure due to a resource not being found.
class NotFoundFailure extends Failure {
  const NotFoundFailure(super.code, super.message, [String? state, String? token])
    : super(state: state, token: token);
}

/// Represents a failure due to local caching issues.
class CacheFailure extends Failure {
  const CacheFailure(super.code, super.message);
}

/// Represents a failure due to invalid input.
class ValidationFailure extends Failure {
  const ValidationFailure(super.code, super.message, [String? state, String? token])
    : super(state: state, token: token);
}
