import 'package:bourgo_arena_mobile/core/utils/result.dart';
import 'package:bourgo_arena_mobile/domain/core/failure.dart';
import 'package:bourgo_arena_mobile/domain/entities/user.dart';
import 'package:bourgo_arena_mobile/domain/repositories/auth_repository.dart';
import 'package:bourgo_arena_mobile/domain/usecases/auth/login_use_case.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late MockAuthRepository repository;
  late LoginUseCase useCase;

  setUp(() {
    registerFallbackValue(
      const User(
        id: 'fallback-user',
        firstName: 'Fallback',
        lastName: 'User',
        email: 'fallback@example.com',
        phone: '+10000000000',
        avatarUrl: '',
        loyaltyPoints: 0,
        subscriptionLevel: 'basic',
        subscriptionExpiry: '2099-01-01',
        totalCheckIns: 0,
      ),
    );

    repository = MockAuthRepository();
    useCase = LoginUseCase(repository);
  });

  group('LoginUseCase', () {
    test('returns the authenticated user on success', () async {
      const user = User(
        id: 'user-1',
        firstName: 'Alex',
        lastName: 'Morgan',
        email: 'alex@example.com',
        phone: '+15550000000',
        avatarUrl: 'https://example.com/avatar.png',
        loyaltyPoints: 120,
        subscriptionLevel: 'premium',
        subscriptionExpiry: '2026-12-31',
        totalCheckIns: 14,
      );

      when(
        () => repository.login('alex@example.com', 'secret123'),
      ).thenAnswer((_) async => const Success<User, Failure>(user));

      final result = await useCase('alex@example.com', 'secret123');

      expect(result, isA<Success<User, Failure>>());
      expect((result as Success<User, Failure>).data, same(user));
      verify(() => repository.login('alex@example.com', 'secret123')).called(1);
      verifyNoMoreInteractions(repository);
    });

    test('propagates repository failures unchanged', () async {
      const failure = AuthFailure('invalid credentials');

      when(
        () => repository.login('alex@example.com', 'bad-password'),
      ).thenAnswer((_) async => const FailureResult<User, Failure>(failure));

      final result = await useCase('alex@example.com', 'bad-password');

      expect(result, isA<FailureResult<User, Failure>>());
      expect((result as FailureResult<User, Failure>).failure, same(failure));
      verify(
        () => repository.login('alex@example.com', 'bad-password'),
      ).called(1);
      verifyNoMoreInteractions(repository);
    });

    test('forwards empty credentials without altering them', () async {
      const user = User(
        id: 'user-2',
        firstName: 'Empty',
        lastName: 'Case',
        email: 'empty@example.com',
        phone: '+15550000001',
        avatarUrl: '',
        loyaltyPoints: 0,
        subscriptionLevel: 'basic',
        subscriptionExpiry: '2099-01-01',
        totalCheckIns: 0,
      );

      when(
        () => repository.login('', ''),
      ).thenAnswer((_) async => const Success<User, Failure>(user));

      final result = await useCase('', '');

      expect(result, isA<Success<User, Failure>>());
      expect((result as Success<User, Failure>).data, same(user));
      verify(() => repository.login('', '')).called(1);
      verifyNoMoreInteractions(repository);
    });
  });
}
