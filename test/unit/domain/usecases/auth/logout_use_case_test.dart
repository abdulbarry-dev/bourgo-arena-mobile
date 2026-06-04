import 'package:bourgo_arena_mobile/core/utils/result.dart';
import 'package:bourgo_arena_mobile/domain/core/failure.dart';
import 'package:bourgo_arena_mobile/domain/repositories/auth_repository.dart';
import 'package:bourgo_arena_mobile/domain/usecases/auth/logout_use_case.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';
import 'package:bourgo_arena_mobile/domain/core/app_error_code.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late MockAuthRepository repository;
  late LogoutUseCase useCase;

  setUp(() {
    repository = MockAuthRepository();
    useCase = LogoutUseCase(repository);
  });

  group('LogoutUseCase', () {
    test('returns success when logout succeeds', () async {
      when(
        () => repository.logout(),
      ).thenAnswer((_) async => const Success<void, Failure>(null));

      final result = await useCase();

      expect(result, isA<Success<void, Failure>>());
      verify(() => repository.logout()).called(1);
      verifyNoMoreInteractions(repository);
    });

    test('propagates repository failures unchanged', () async {
      const failure = AuthFailure(
        AppErrorCode.invalidCredentials,
        'logout failed',
      );

      when(
        () => repository.logout(),
      ).thenAnswer((_) async => const FailureResult<void, Failure>(failure));

      final result = await useCase();

      expect(result, isA<FailureResult<void, Failure>>());
      expect((result as FailureResult<void, Failure>).failure, same(failure));
      verify(() => repository.logout()).called(1);
      verifyNoMoreInteractions(repository);
    });

    test('can be invoked repeatedly without additional arguments', () async {
      when(
        () => repository.logout(),
      ).thenAnswer((_) async => const Success<void, Failure>(null));

      final first = await useCase();
      final second = await useCase();

      expect(first, isA<Success<void, Failure>>());
      expect(second, isA<Success<void, Failure>>());
      verify(() => repository.logout()).called(2);
      verifyNoMoreInteractions(repository);
    });
  });
}
