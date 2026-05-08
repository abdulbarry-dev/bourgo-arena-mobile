import 'package:bourgo_arena_mobile/core/utils/result.dart';
import 'package:bourgo_arena_mobile/domain/core/failure.dart';
import 'package:bourgo_arena_mobile/domain/repositories/auth_repository.dart';
import 'package:bourgo_arena_mobile/domain/usecases/auth/update_password_use_case.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late MockAuthRepository repository;
  late UpdatePasswordUseCase useCase;

  setUp(() {
    repository = MockAuthRepository();
    useCase = UpdatePasswordUseCase(repository);
  });

  group('UpdatePasswordUseCase', () {
    test('returns success when password update succeeds', () async {
      when(
        () => repository.updatePassword(
          currentPassword: 'old-pass',
          newPassword: 'new-pass',
        ),
      ).thenAnswer((_) async => const Success<void, Failure>(null));

      final result = await useCase(
        currentPassword: 'old-pass',
        newPassword: 'new-pass',
      );

      expect(result, isA<Success<void, Failure>>());
      verify(
        () => repository.updatePassword(
          currentPassword: 'old-pass',
          newPassword: 'new-pass',
        ),
      ).called(1);
      verifyNoMoreInteractions(repository);
    });

    test('propagates repository failures unchanged', () async {
      const failure = ValidationFailure('password too weak');

      when(
        () => repository.updatePassword(
          currentPassword: 'old-pass',
          newPassword: 'new-pass',
        ),
      ).thenAnswer((_) async => const FailureResult<void, Failure>(failure));

      final result = await useCase(
        currentPassword: 'old-pass',
        newPassword: 'new-pass',
      );

      expect(result, isA<FailureResult<void, Failure>>());
      expect((result as FailureResult<void, Failure>).failure, same(failure));
      verify(
        () => repository.updatePassword(
          currentPassword: 'old-pass',
          newPassword: 'new-pass',
        ),
      ).called(1);
      verifyNoMoreInteractions(repository);
    });

    test('forwards identical password boundary input unchanged', () async {
      when(
        () => repository.updatePassword(
          currentPassword: 'same-pass',
          newPassword: 'same-pass',
        ),
      ).thenAnswer((_) async => const Success<void, Failure>(null));

      final result = await useCase(
        currentPassword: 'same-pass',
        newPassword: 'same-pass',
      );

      expect(result, isA<Success<void, Failure>>());
      verify(
        () => repository.updatePassword(
          currentPassword: 'same-pass',
          newPassword: 'same-pass',
        ),
      ).called(1);
      verifyNoMoreInteractions(repository);
    });
  });
}
