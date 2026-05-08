/// Base sealed class for all failures in the application.
sealed class Failure {
  final String message;

  const Failure(this.message);

  /// Helper for generic server/unexpected errors.
  factory Failure.unexpected([String? message]) => ServerFailure(message ?? 'Unexpected error occurred');

  factory Failure.network(String message) => NetworkFailure(message);
  factory Failure.auth(String message) => AuthFailure(message);
  factory Failure.server(String message) => ServerFailure(message);
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
