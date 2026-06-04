import 'dart:async';
import 'package:bourgo_arena_mobile/core/utils/device_token_registrar.dart';
import 'package:bourgo_arena_mobile/core/utils/result.dart';
import 'package:bourgo_arena_mobile/domain/entities/auth_session.dart';
import 'package:bourgo_arena_mobile/domain/entities/auth_state.dart';
import 'package:bourgo_arena_mobile/domain/repositories/auth_repository.dart';
import 'package:bourgo_arena_mobile/domain/repositories/session_repository.dart';
import 'package:bourgo_arena_mobile/presentation/auth/auth_state_notifier.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:checks/checks.dart';
import 'package:bourgo_arena_mobile/domain/core/failure.dart';
import 'package:bourgo_arena_mobile/domain/core/app_error_code.dart';
import '../../../test_utils.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

class MockSessionRepository extends Mock implements SessionRepository {}

class MockDeviceTokenRegistrar extends Mock implements DeviceTokenRegistrar {}

void main() {
  late AuthStateNotifier notifier;
  late MockAuthRepository mockAuthRepository;
  late MockSessionRepository mockSessionRepository;
  late MockDeviceTokenRegistrar mockDeviceTokenRegistrar;
  late StreamController<AuthSession> authStreamController;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    mockSessionRepository = MockSessionRepository();
    mockDeviceTokenRegistrar = MockDeviceTokenRegistrar();
    authStreamController = StreamController<AuthSession>();

    when(
      () => mockAuthRepository.onAuthStateChanged,
    ).thenAnswer((_) => authStreamController.stream);

    when(
      () => mockDeviceTokenRegistrar.registerIfPossible(),
    ).thenAnswer((_) async {});

    notifier = AuthStateNotifier(
      mockAuthRepository,
      mockSessionRepository,
      mockDeviceTokenRegistrar,
    );
  });

  tearDown(() {
    authStreamController.close();
    notifier.dispose();
  });

  group('AuthStateNotifier', () {
    test('initial state has no user', () {
      check(notifier.currentUser).isNull();
      check(notifier.isAuthenticated).isFalse();
    });

    test('updates user when stream emits new session', () async {
      final user = createTestUser(
        id: '1',
        firstName: 'John',
        lastName: 'Doe',
        email: 'john@example.com',
      );
      final session = AuthSession(user: user, state: AuthState.authenticated);

      authStreamController.add(session);

      // Wait for stream event
      await Future.delayed(Duration.zero);

      check(notifier.currentUser).equals(user);
      check(notifier.isAuthenticated).isTrue();
      verify(() => mockDeviceTokenRegistrar.registerIfPossible()).called(1);
    });

    test(
      'updates state to unauthenticated when stream emits unauthenticated session',
      () async {
        authStreamController.add(AuthSession.unauthenticated());

        await Future.delayed(Duration.zero);

        check(notifier.currentUser).isNull();
        check(notifier.isAuthenticated).isFalse();
        check(notifier.state).equals(AuthState.unauthenticated);
      },
    );

    test('notifies listeners on change', () async {
      int notifyCount = 0;
      notifier.addListener(() => notifyCount++);

      authStreamController.add(AuthSession.unauthenticated());
      await Future.delayed(Duration.zero);

      check(notifyCount).equals(1);
    });

    test('restores pending onboarding session on initialize', () async {
      when(
        () => mockSessionRepository.shouldSkipLoginOtpForever(),
      ).thenAnswer((_) async => const Success(false));
      when(() => mockSessionRepository.getRegistrationDraft()).thenAnswer(
        (_) async => const Success({
          'route': '/family-onboarding',
          'extra': {'firstName': 'John', 'lastName': 'Doe'},
        }),
      );
      when(
        () => mockAuthRepository.getToken(),
      ).thenAnswer((_) async => const Success('onboarding-token'));
      when(
        () => mockSessionRepository.getAuthState(),
      ).thenAnswer((_) async => const Success('pending_onboarding'));
      when(
        () => mockSessionRepository.getPendingVerificationEmail(),
      ).thenAnswer((_) async => const Success('john@example.com'));
      when(() => mockAuthRepository.getUserProfile()).thenAnswer(
        (_) async => Success(
          AuthSession(
            state: AuthState.pendingOnboarding,
            token: 'onboarding-token',
            pendingEmail: 'john@example.com',
          ),
        ),
      );

      await notifier.initialize();

      check(notifier.state).equals(AuthState.pendingOnboarding);
      check(notifier.session.token).equals('onboarding-token');
      check(notifier.session.pendingEmail).equals('john@example.com');
      check(notifier.registrationRoute).equals('/family-onboarding');
      check(notifier.registrationData?['firstName']).equals('John');
    });
  });
}
