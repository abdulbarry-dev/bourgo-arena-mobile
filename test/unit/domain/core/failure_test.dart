import 'package:bourgo_arena_mobile/domain/core/app_error_code.dart';
import 'package:bourgo_arena_mobile/domain/core/failure.dart';
import 'package:checks/checks.dart';
import 'package:test/test.dart';

void main() {
  group('Failure', () {
    test('NetworkFailure should store message and have correct type', () {
      const message = 'No internet connection';
      final failure = Failure.network(AppErrorCode.networkUnavailable, message);

      check(failure).isA<NetworkFailure>();
      check(failure.message).equals(message);
      check(failure.code).equals(AppErrorCode.networkUnavailable);
    });

    test('AuthFailure should store message and have correct type', () {
      const message = 'Invalid credentials';
      final failure = Failure.auth(AppErrorCode.invalidCredentials, message);

      check(failure).isA<AuthFailure>();
      check(failure.message).equals(message);
      check(failure.code).equals(AppErrorCode.invalidCredentials);
    });

    test('ServerFailure should store message and have correct type', () {
      const message = 'Internal server error';
      final failure = Failure.server(AppErrorCode.serverError, message);

      check(failure).isA<ServerFailure>();
      check(failure.message).equals(message);
      check(failure.code).equals(AppErrorCode.serverError);
    });

    test('NotFoundFailure should store message and have correct type', () {
      const message = 'User not found';
      final failure = Failure.notFound(AppErrorCode.notFound, message);

      check(failure).isA<NotFoundFailure>();
      check(failure.message).equals(message);
      check(failure.code).equals(AppErrorCode.notFound);
    });

    test('CacheFailure should store message and have correct type', () {
      const message = 'Failed to load from cache';
      final failure = Failure.cache(AppErrorCode.cacheError, message);

      check(failure).isA<CacheFailure>();
      check(failure.message).equals(message);
      check(failure.code).equals(AppErrorCode.cacheError);
    });

    test('ValidationFailure should store message and have correct type', () {
      const message = 'Invalid email format';
      final failure = Failure.validation(AppErrorCode.validationFailed, message);

      check(failure).isA<ValidationFailure>();
      check(failure.message).equals(message);
      check(failure.code).equals(AppErrorCode.validationFailed);
    });

    group('Failure.unexpected', () {
      test(
        'should return ServerFailure with default message when none provided',
        () {
          final failure = Failure.unexpected();

          check(failure).isA<ServerFailure>();
          check(failure.message).equals('Unexpected error occurred');
          check(failure.code).equals(AppErrorCode.serverError);
        },
      );

      test('should return ServerFailure with custom message when provided', () {
        const message = 'Something went wrong';
        final failure = Failure.unexpected(message);

        check(failure).isA<ServerFailure>();
        check(failure.message).equals(message);
        check(failure.code).equals(AppErrorCode.serverError);
      });
    });
  });
}
