/// Base sealed class for all failures in the application.
sealed class Failure {
  final String message;
  final String? state;
  final String? token;

  const Failure(this.message, {this.state, this.token});

  /// Helper for generic server/unexpected errors.
  factory Failure.unexpected([String? message]) =>
      ServerFailure(message ?? 'Unexpected error occurred');

  factory Failure.network(String message) => NetworkFailure(message);
  factory Failure.auth(String message, [String? state, String? token]) =>
      AuthFailure(message, state, token);
  factory Failure.server(String message, [String? state, String? token]) =>
      ServerFailure(message, state, token);
  factory Failure.notFound(String message, [String? state, String? token]) =>
      NotFoundFailure(message, state, token);
  factory Failure.cache(String message) => CacheFailure(message);
  factory Failure.validation(String message, [String? state, String? token]) =>
      ValidationFailure(message, state, token);
}

/// Represents a failure that occurred due to a network or server issue.
class NetworkFailure extends Failure {
  const NetworkFailure(super.message);
}

/// Represents a failure due to unauthorized access or authentication errors.
class AuthFailure extends Failure {
  const AuthFailure(super.message, [String? state, String? token])
    : super(state: state, token: token);
}

/// Represents a failure due to unexpected or generic errors.
class ServerFailure extends Failure {
  const ServerFailure(super.message, [String? state, String? token])
    : super(state: state, token: token);
}

/// Represents a failure due to a resource not being found.
class NotFoundFailure extends Failure {
  const NotFoundFailure(super.message, [String? state, String? token])
    : super(state: state, token: token);
}

/// Represents a failure due to local caching issues.
class CacheFailure extends Failure {
  const CacheFailure(super.message);
}

/// Represents a failure due to invalid input.
class ValidationFailure extends Failure {
  const ValidationFailure(super.message, [String? state, String? token])
    : super(state: state, token: token);
}
