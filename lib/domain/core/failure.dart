/// Base sealed class for all failures in the application.
sealed class Failure {
  final String message;

  const Failure(this.message);

  /// Helper for generic server/unexpected errors.
  factory Failure.unexpected([String? message]) =>
      ServerFailure(message ?? 'Unexpected error occurred');

  factory Failure.network(String message) => NetworkFailure(message);
  factory Failure.auth(String message) => AuthFailure(message);
  factory Failure.server(String message) => ServerFailure(message);
  factory Failure.notFound(String message) => NotFoundFailure(message);
  factory Failure.cache(String message) => CacheFailure(message);
  factory Failure.validation(String message) => ValidationFailure(message);
}

/// Represents a failure that occurred due to a network or server issue.
class NetworkFailure extends Failure {
  const NetworkFailure(super.message);
}

/// Represents a failure due to unauthorized access or authentication errors.
class AuthFailure extends Failure {
  const AuthFailure(super.message);
}

/// Represents a failure due to unexpected or generic errors.
class ServerFailure extends Failure {
  const ServerFailure(super.message);
}

/// Represents a failure due to a resource not being found.
class NotFoundFailure extends Failure {
  const NotFoundFailure(super.message);
}

/// Represents a failure due to local caching issues.
class CacheFailure extends Failure {
  const CacheFailure(super.message);
}

/// Represents a failure due to invalid input.
class ValidationFailure extends Failure {
  const ValidationFailure(super.message);
}
