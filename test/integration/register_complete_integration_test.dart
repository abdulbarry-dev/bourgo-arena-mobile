import 'package:bourgo_arena_mobile/data/api/api_client.dart';
import 'package:bourgo_arena_mobile/data/repositories/api_auth_repository.dart';
import 'package:bourgo_arena_mobile/domain/repositories/session_repository.dart';
import 'package:bourgo_arena_mobile/domain/entities/auth_session.dart';
import 'package:bourgo_arena_mobile/domain/entities/auth_state.dart';
import 'package:bourgo_arena_mobile/core/utils/result.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import '../unit/data/repositories/repository_test_fixtures.dart';

class MockApiClient extends Mock implements ApiClient {}

class MockSessionRepository extends Mock implements SessionRepository {}

void main() {
  late MockApiClient apiClient;
  late MockSessionRepository sessionRepository;
  late ApiAuthRepository repository;

  setUp(() {
    apiClient = MockApiClient();
    sessionRepository = MockSessionRepository();
    repository = ApiAuthRepository(apiClient, sessionRepository);

    // Default stubs for session repository
    when(
      () => sessionRepository.saveAuthToken(any()),
    ).thenAnswer((_) async => const Success(null));
    when(
      () => sessionRepository.getAuthToken(),
    ).thenAnswer((_) async => const Success(null));
    when(
      () => sessionRepository.saveAuthState(any()),
    ).thenAnswer((_) async => const Success(null));
    when(
      () => sessionRepository.getAuthState(),
    ).thenAnswer((_) async => const Success(null));
    when(
      () => sessionRepository.savePendingVerificationEmail(any()),
    ).thenAnswer((_) async => const Success(null));
    when(
      () => sessionRepository.getPendingVerificationEmail(),
    ).thenAnswer((_) async => const Success(null));
    when(
      () => sessionRepository.isOnboardingCompleted(),
    ).thenAnswer((_) async => const Success(false));
    when(
      () => sessionRepository.setOnboardingCompleted(any()),
    ).thenAnswer((_) async => const Success(null));
    when(
      () => sessionRepository.clearSession(),
    ).thenAnswer((_) async => const Success(null));
    when(
      () => sessionRepository.shouldSkipLoginOtpForever(),
    ).thenAnswer((_) async => const Success(false));

    // Default verification status
    when(() => apiClient.get('/user/verification-status')).thenAnswer(
      (_) async => {
        'email_verified': true,
        'phone_verified': true,
        'is_fully_verified': true,
      },
    );
  });

  test(
    'register then complete-registration transitions to authenticated',
    () async {
      final userJson = testUserJson(birthDate: DateTime.utc(1990, 1, 1));
      final userEntity = testUserEntity(birthDate: DateTime.utc(1990, 1, 1));

      // Mock register response: returns token and pending_verification state
      when(() => apiClient.post('/auth/register', any())).thenAnswer(
        (_) async => {
          'token': 'reg-token',
          'state': 'pending_verification',
          'user': userJson,
        },
      );

      // Mock complete-registration response: returns active state and user
      when(
        () => apiClient.post(
          '/auth/complete-registration',
          any(),
          includeAuth: false,
        ),
      ).thenAnswer(
        (_) async => {
          'state': 'active',
          'token': 'final-token',
          'user': userJson,
        },
      );

      // Expect auth state stream to emit pendingVerification then authenticated
      final expectation = expectLater(
        repository.onAuthStateChanged,
        emitsInOrder([
          predicate(
            (v) => v is AuthSession && v.state == AuthState.pendingVerification,
          ),
          predicate(
            (v) =>
                v is AuthSession &&
                v.state == AuthState.authenticated &&
                v.user?.email == userEntity.email,
          ),
        ]),
      );

      // Call register
      final regResult = await repository.register(
        firstName: 'Alex',
        lastName: 'Morgan',
        email: 'alex@example.com',
        phone: '+15550000000',
        password: 'secret123',
        gender: 'male',
        birthDate: DateTime.utc(1990, 1, 1),
      );

      expect(regResult, isA<Success<void, dynamic>>());

      // Now complete registration (simulate PIN setup)
      final user = userEntity;
      final completeResult = await repository.completeRegistration(user);
      expect(completeResult, isA<Success<void, dynamic>>());

      await expectation;
    },
  );
}
