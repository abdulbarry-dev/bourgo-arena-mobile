/// A generic class that holds a value with its loading status.
///
/// This is typically used to wrap data fetched from a repository or service
/// to provide a standardized way of handling success and failure states.
sealed class Result<T> {
  const Result();
}

/// Represents a successful operation with data of type [T].
class Success<T> extends Result<T> {
  final T data;
  const Success(this.data);
}

/// Represents a failed operation with an error message and optional exception.
class Failure<T> extends Result<T> {
  final String message;
  final dynamic exception;
  const Failure(this.message, [this.exception]);
}
