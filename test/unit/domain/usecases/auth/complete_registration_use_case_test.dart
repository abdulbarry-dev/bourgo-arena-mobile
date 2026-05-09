import 'package:bourgo_arena_mobile/core/utils/result.dart';
import 'package:bourgo_arena_mobile/domain/core/failure.dart';
import 'package:bourgo_arena_mobile/domain/repositories/auth_repository.dart';
import 'package:bourgo_arena_mobile/domain/usecases/auth/complete_registration_use_case.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import '../usecase_test_fixtures.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late MockAuthRepository repository;
  late CompleteRegistrationUseCase useCase;

  setUp(() {
    registerFallbackValue(testUser());
    repository = MockAuthRepository();
    useCase = CompleteRegistrationUseCase(repository);
  });

  group('CompleteRegistrationUseCase', () {
    test('returns success when completion succeeds', () async {
      final user = testUser();

      when(
        () => repository.completeRegistration(user),
      ).thenAnswer((_) async => const Success<void, Failure>(null));

      final result = await useCase(user);

      expect(result, isA<Success<void, Failure>>());
      verify(() => repository.completeRegistration(user)).called(1);
      verifyNoMoreInteractions(repository);
    });

    test('propagates repository failures unchanged', () async {
      final user = testUser();
      const failure = AuthFailure('registration completion failed');

      when(
        () => repository.completeRegistration(user),
      ).thenAnswer((_) async => const FailureResult<void, Failure>(failure));

      final result = await useCase(user);

      expect(result, isA<FailureResult<void, Failure>>());
      expect((result as FailureResult<void, Failure>).failure, same(failure));
      verify(() => repository.completeRegistration(user)).called(1);
      verifyNoMoreInteractions(repository);
    });

    test(
      'forwards parent account users with empty children lists unchanged',
      () async {
        final user = testUser(isParentAccount: true);

        when(
          () => repository.completeRegistration(user),
        ).thenAnswer((_) async => const Success<void, Failure>(null));

        final result = await useCase(user);

        expect(result, isA<Success<void, Failure>>());
        verify(() => repository.completeRegistration(user)).called(1);
        verifyNoMoreInteractions(repository);
      },
    );
  });
}
