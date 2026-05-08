import 'package:bourgo_arena_mobile/core/utils/result.dart';
import 'package:bourgo_arena_mobile/domain/core/failure.dart';
import 'package:bourgo_arena_mobile/domain/entities/user.dart';
import 'package:bourgo_arena_mobile/domain/repositories/auth_repository.dart';
import 'package:bourgo_arena_mobile/domain/usecases/auth/register_use_case.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import '../usecase_test_fixtures.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late MockAuthRepository repository;
  late RegisterUseCase useCase;

  setUp(() {
    registerFallbackValue(testUser());
    repository = MockAuthRepository();
    useCase = RegisterUseCase(repository);
  });

  group('RegisterUseCase', () {
    test('returns success when registration succeeds', () async {
      when(
        () => repository.register(
          firstName: 'Alex',
          lastName: 'Morgan',
          email: 'alex@example.com',
          phone: '+15550000000',
          password: 'secret123',
          isFamilyAccount: false,
        ),
      ).thenAnswer((_) async => const Success<void, Failure>(null));

      final result = await useCase(
        firstName: 'Alex',
        lastName: 'Morgan',
        email: 'alex@example.com',
        phone: '+15550000000',
        password: 'secret123',
      );

      expect(result, isA<Success<void, Failure>>());
      verify(
        () => repository.register(
          firstName: 'Alex',
          lastName: 'Morgan',
          email: 'alex@example.com',
          phone: '+15550000000',
          password: 'secret123',
          isFamilyAccount: false,
        ),
      ).called(1);
      verifyNoMoreInteractions(repository);
    });

    test('propagates repository failures unchanged', () async {
      const failure = ValidationFailure('invalid registration data');

      when(
        () => repository.register(
          firstName: 'Alex',
          lastName: 'Morgan',
          email: 'alex@example.com',
          phone: '+15550000000',
          password: 'secret123',
          isFamilyAccount: false,
        ),
      ).thenAnswer((_) async => const FailureResult<void, Failure>(failure));

      final result = await useCase(
        firstName: 'Alex',
        lastName: 'Morgan',
        email: 'alex@example.com',
        phone: '+15550000000',
        password: 'secret123',
      );

      expect(result, isA<FailureResult<void, Failure>>());
      expect((result as FailureResult<void, Failure>).failure, same(failure));
      verify(
        () => repository.register(
          firstName: 'Alex',
          lastName: 'Morgan',
          email: 'alex@example.com',
          phone: '+15550000000',
          password: 'secret123',
          isFamilyAccount: false,
        ),
      ).called(1);
      verifyNoMoreInteractions(repository);
    });

    test(
      'forwards family-account boundary values without modification',
      () async {
        when(
          () => repository.register(
            firstName: '',
            lastName: '',
            email: '',
            phone: '',
            password: '',
            isFamilyAccount: true,
          ),
        ).thenAnswer((_) async => const Success<void, Failure>(null));

        final result = await useCase(
          firstName: '',
          lastName: '',
          email: '',
          phone: '',
          password: '',
          isFamilyAccount: true,
        );

        expect(result, isA<Success<void, Failure>>());
        verify(
          () => repository.register(
            firstName: '',
            lastName: '',
            email: '',
            phone: '',
            password: '',
            isFamilyAccount: true,
          ),
        ).called(1);
        verifyNoMoreInteractions(repository);
      },
    );
  });
}
