import 'package:bourgo_arena_mobile/core/utils/result.dart';
import 'package:bourgo_arena_mobile/domain/core/failure.dart';
import 'package:bourgo_arena_mobile/domain/entities/auth_session.dart';
import 'package:bourgo_arena_mobile/domain/entities/auth_state.dart';
import 'package:bourgo_arena_mobile/domain/entities/user.dart';
import 'package:bourgo_arena_mobile/domain/repositories/auth_repository.dart';
import 'package:bourgo_arena_mobile/domain/usecases/auth/login_use_case.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';
import 'package:bourgo_arena_mobile/domain/core/app_error_code.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late MockAuthRepository repository;
  late LoginUseCase useCase;

  setUp(() {
    registerFallbackValue(const AuthSession(state: AuthState.unauthenticated));

    repository = MockAuthRepository();
    useCase = LoginUseCase(repository);
  });

  group('LoginUseCase', () {
    test('returns the authenticated session on success', () async {
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
      );
      const session = AuthSession(
        user: user,
        state: AuthState.authenticated,
        token: 'token-123',
      );

      when(
        () => repository.login('alex@example.com', 'secret123'),
      ).thenAnswer((_) async => const Success<AuthSession, Failure>(session));

      final result = await useCase('alex@example.com', 'secret123');

      expect(result, isA<Success<AuthSession, Failure>>());
      expect((result as Success<AuthSession, Failure>).data, same(session));
      verify(() => repository.login('alex@example.com', 'secret123')).called(1);
      verifyNoMoreInteractions(repository);
    });

    test('propagates repository failures unchanged', () async {
      const failure = AuthFailure(
        AppErrorCode.invalidCredentials,
        'invalid credentials',
      );

      when(
        () => repository.login('alex@example.com', 'bad-password'),
      ).thenAnswer(
        (_) async => const FailureResult<AuthSession, Failure>(failure),
      );

      final result = await useCase('alex@example.com', 'bad-password');

      expect(result, isA<FailureResult<AuthSession, Failure>>());
      expect(
        (result as FailureResult<AuthSession, Failure>).failure,
        same(failure),
      );
      verify(
        () => repository.login('alex@example.com', 'bad-password'),
      ).called(1);
      verifyNoMoreInteractions(repository);
    });

    test('forwards empty credentials without altering them', () async {
      const session = AuthSession(
        state: AuthState.authenticated,
        user: User(
          id: 'user-2',
          firstName: 'Empty',
          lastName: 'Case',
          email: 'empty@example.com',
          phone: '+15550000001',
          avatarUrl: '',
          loyaltyPoints: 0,
          subscriptionLevel: 'basic',
          subscriptionExpiry: '2099-01-01',
        ),
      );

      when(
        () => repository.login('', ''),
      ).thenAnswer((_) async => const Success<AuthSession, Failure>(session));

      final result = await useCase('', '');

      expect(result, isA<Success<AuthSession, Failure>>());
      expect((result as Success<AuthSession, Failure>).data, same(session));
      verify(() => repository.login('', '')).called(1);
      verifyNoMoreInteractions(repository);
    });
  });
}
