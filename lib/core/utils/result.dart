import 'package:bourgo_arena_mobile/domain/core/failure.dart';

/// A generic class that holds a value with its loading status.
///
/// This is typically used to wrap data fetched from a repository or service
/// to provide a standardized way of handling success and failure states.
sealed class Result<S, F extends Failure> {
  const Result();

  /// Standard success factory.
  factory Result.success(S data) = Success<S, F>;

  /// Standard failure factory.
  factory Result.failure(F failure) = FailureResult<S, F>;

  /// Functional fold to handle success and failure paths.
  R fold<R>({
    required R Function(F failure) onFailure,
    required R Function(S success) onSuccess,
  }) {
    if (this is Success<S, F>) {
      return onSuccess((this as Success<S, F>).data);
    } else if (this is FailureResult<S, F>) {
      return onFailure((this as FailureResult<S, F>).failure);
    }
    throw StateError('Invalid state');
  }

  /// Pattern matching for Result.
  R when<R>({
    required R Function(S data) success,
    required R Function(F failure) failure,
  }) {
    if (this is Success<S, F>) {
      return success((this as Success<S, F>).data);
    } else if (this is FailureResult<S, F>) {
      return failure((this as FailureResult<S, F>).failure);
    }
    throw StateError('Invalid state');
  }

  /// Returns true if this is a [Success].
  bool get isSuccess => this is Success<S, F>;

  /// Returns true if this is a [FailureResult].
  bool get isFailure => this is FailureResult<S, F>;
}

/// Represents a successful operation with data of type [S].
class Success<S, F extends Failure> extends Result<S, F> {
  final S data;
  const Success(this.data);
}

/// Represents a failed operation with an error message and optional exception.
class FailureResult<S, F extends Failure> extends Result<S, F> {
  final F failure;
  const FailureResult(this.failure);
}
