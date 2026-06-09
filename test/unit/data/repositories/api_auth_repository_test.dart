import 'package:flutter/material.dart';
import 'package:bourgo_arena_mobile/core/utils/device_identity_storage.dart';
import 'package:bourgo_arena_mobile/core/utils/result.dart';
import 'package:bourgo_arena_mobile/data/api/api_client.dart';
import 'package:bourgo_arena_mobile/data/api/api_exceptions.dart';
import 'package:bourgo_arena_mobile/data/repositories/api_auth_repository.dart';
import 'package:bourgo_arena_mobile/domain/core/failure.dart';
import 'package:bourgo_arena_mobile/domain/entities/auth_session.dart';
import 'package:bourgo_arena_mobile/domain/entities/auth_state.dart';
import 'package:bourgo_arena_mobile/domain/entities/verification_status.dart';
import 'package:bourgo_arena_mobile/domain/repositories/device_registration_repository.dart';
import 'package:bourgo_arena_mobile/domain/repositories/session_repository.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import 'repository_test_fixtures.dart';

class MockApiClient extends Mock implements ApiClient {}

class MockSessionRepository extends Mock implements SessionRepository {}

class MockDeviceIdentityStorage extends Mock implements DeviceIdentityStorage {}

class MockDeviceRegistrationRepository extends Mock
    implements DeviceRegistrationRepository {}

void main() {
  late MockApiClient apiClient;
  late MockSessionRepository sessionRepository;
  late MockDeviceIdentityStorage deviceIdentityStorage;
  late MockDeviceRegistrationRepository deviceRegistrationRepo;
  late ApiAuthRepository repository;

  setUp(() {
    apiClient = MockApiClient();
    when(() => apiClient.hasToken).thenReturn(true);
    sessionRepository = MockSessionRepository();
    deviceIdentityStorage = MockDeviceIdentityStorage();
    deviceRegistrationRepo = MockDeviceRegistrationRepository();
    repository = ApiAuthRepository(
      apiClient,
      sessionRepository,
      deviceIdentityStorage,
      deviceRegistrationRepo,
    );

    // Default mocks for SessionRepository
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

    // Default mocks for preferences
    when(
      () => sessionRepository.getThemeMode(),
    ).thenAnswer((_) async => const Success(ThemeMode.system));
    when(
      () => sessionRepository.getLocale(),
    ).thenAnswer((_) async => const Success(Locale('en')));
    when(
      () => sessionRepository.areNotificationsEnabled(),
    ).thenAnswer((_) async => const Success(true));
    when(
      () => sessionRepository.arePromotionalNotificationsEnabled(),
    ).thenAnswer((_) async => const Success(true));
    when(
      () => sessionRepository.areAccountNotificationsEnabled(),
    ).thenAnswer((_) async => const Success(true));
    when(
      () => sessionRepository.areReservationsNotificationsEnabled(),
    ).thenAnswer((_) async => const Success(true));
    when(
      () => sessionRepository.areSubscriptionsNotificationsEnabled(),
    ).thenAnswer((_) async => const Success(true));
    when(
      () => sessionRepository.areCoursesNotificationsEnabled(),
    ).thenAnswer((_) async => const Success(true));
    when(
      () => sessionRepository.areLoyaltyNotificationsEnabled(),
    ).thenAnswer((_) async => const Success(true));
    when(
      () => sessionRepository.areFamilyNotificationsEnabled(),
    ).thenAnswer((_) async => const Success(true));

    // Default mock for verification status endpoint
    when(() => apiClient.get('/member/verification-status')).thenAnswer(
      (_) async => {
        'email_verified': true,
        'phone_verified': true,
        'is_fully_verified': true,
      },
    );

    // Default mocks for profile requests triggered during auth flows
    when(
      () => apiClient.put('/member/profile', any()),
    ).thenAnswer((_) async => {});
    when(
      () => apiClient.get(
        '/member/profile',
        skipAuthError: any(named: 'skipAuthError'),
        fullResponse: any(named: 'fullResponse'),
        includeAuth: any(named: 'includeAuth'),
      ),
    ).thenAnswer((_) async => testUserJson());
  });

  group('ApiAuthRepository', () {
    group('login', () {
      test('returns Success on 200 and maps the user correctly', () async {
        const token = 'token-123';
        final userJson = testUserJson(
          birthDate: DateTime.utc(1992, 7, 8),
          children: [testChildJson(id: 'child-1', firstName: 'Mia')],
        );
        final expectedUser = testUserEntity(
          birthDate: DateTime.utc(1992, 7, 8),
          children: [testChildEntity(id: 'child-1', firstName: 'Mia')],
        );

        when(
          () => apiClient.post('/auth/login', {
            'email': 'alex@example.com',
            'password': 'secret123',
          }),
        ).thenAnswer((_) async => {'token': token, 'state': 'active'});

        when(
          () => apiClient.get(
            '/member/profile',
            fullResponse: false,
            skipAuthError: true,
          ),
        ).thenAnswer((_) async => userJson);
        when(
          () => sessionRepository.saveAuthToken(token),
        ).thenAnswer((_) async => const Success<void, Failure>(null));

        final eventExpectation = expectLater(
          repository.onAuthStateChanged,
          emits(
            predicate<AuthSession>(
              (value) =>
                  value.state == AuthState.authenticated &&
                  value.user != null &&
                  value.user!.id == expectedUser.id &&
                  value.user!.firstName == expectedUser.firstName &&
                  value.user!.lastName == expectedUser.lastName &&
                  value.user!.children.length == expectedUser.children.length,
            ),
          ),
        );

        final result = await repository.login('alex@example.com', 'secret123');

        expect(result, isA<Success<AuthSession, Failure>>());
        final session = (result as Success<AuthSession, Failure>).data;
        expect(session.user?.id, expectedUser.id);
        expect(session.user?.firstName, expectedUser.firstName);
        expect(session.user?.lastName, expectedUser.lastName);
        expect(session.user?.avatarUrl, expectedUser.avatarUrl);
        expect(session.user?.children, hasLength(1));
        expect(session.state, AuthState.authenticated);
        verify(
          () => apiClient.post('/auth/login', {
            'email': 'alex@example.com',
            'password': 'secret123',
          }),
        ).called(1);
        verify(() => apiClient.setToken(null)).called(1);
        verify(() => apiClient.setToken(token)).called(1);
        verify(() => sessionRepository.saveAuthToken(token)).called(1);
        verify(
          () => apiClient.get(
            '/member/profile',
            fullResponse: false,
            skipAuthError: true,
          ),
        ).called(1);
        await eventExpectation;
      });

      test('returns Success on 200 with phone identifier', () async {
        const token = 'token-456';
        final userJson = testUserJson(phone: '+212600000000');

        when(
          () => apiClient.post('/auth/login', {
            'phone': '+212600000000',
            'password': 'secret123',
          }),
        ).thenAnswer((_) async => {'token': token, 'state': 'active'});

        when(
          () => apiClient.get(
            '/member/profile',
            fullResponse: false,
            skipAuthError: true,
          ),
        ).thenAnswer((_) async => userJson);
        when(
          () => sessionRepository.saveAuthToken(token),
        ).thenAnswer((_) async => const Success<void, Failure>(null));

        final result = await repository.login('+212600000000', 'secret123');

        expect(result, isA<Success<AuthSession, Failure>>());
        verify(
          () => apiClient.post('/auth/login', {
            'phone': '+212600000000',
            'password': 'secret123',
          }),
        ).called(1);
        verify(() => apiClient.setToken(token)).called(1);
      });

      test(
        'refreshes pending onboarding sessions when login returns partial user data',
        () async {
          const token = 'onboarding-token';
          final partialUserJson = testUserJson(
            name: 'Alex',
            phone: '+212600000000',
            birthDate: null,
            gender: null,
          );
          final fullProfileJson = testUserJson(
            name: 'Alex Morgan',
            phone: '+212600000000',
            birthDate: DateTime.utc(1992, 7, 8),
            gender: 'male',
            children: [testChildJson(id: 'child-1', firstName: 'Mia')],
          );

          when(
            () => apiClient.post('/auth/login', {
              'email': 'onboarding@example.com',
              'password': 'secret123',
            }),
          ).thenAnswer(
            (_) async => {
              'token': token,
              'state': 'pending_onboarding',
              'user': partialUserJson,
            },
          );

          when(
            () => apiClient.get(
              '/member/profile',
              fullResponse: false,
              skipAuthError: true,
            ),
          ).thenAnswer((_) async => fullProfileJson);
          when(
            () => sessionRepository.saveAuthToken(token),
          ).thenAnswer((_) async => const Success<void, Failure>(null));

          final eventExpectation = expectLater(
            repository.onAuthStateChanged,
            emits(
              predicate<AuthSession>(
                (value) =>
                    value.state == AuthState.pendingOnboarding &&
                    value.user != null &&
                    value.user!.firstName == 'Alex' &&
                    value.user!.lastName == 'Morgan' &&
                    value.user!.birthDate == DateTime.utc(1992, 7, 8) &&
                    value.user!.gender == 'male',
              ),
            ),
          );

          final result = await repository.login(
            'onboarding@example.com',
            'secret123',
          );

          expect(result, isA<Success<AuthSession, Failure>>());
          final session = (result as Success<AuthSession, Failure>).data;
          expect(session.state, AuthState.pendingOnboarding);
          expect(session.user?.firstName, 'Alex');
          expect(session.user?.lastName, 'Morgan');
          expect(session.user?.birthDate, DateTime.utc(1992, 7, 8));
          expect(session.user?.gender, 'male');
          verify(
            () => apiClient.get(
              '/member/profile',
              fullResponse: false,
              skipAuthError: true,
            ),
          ).called(1);
          await eventExpectation;
        },
      );

      test(
        'returns Failure(AuthFailure) on 401 without mutating session',
        () async {
          when(
            () => apiClient.post('/auth/login', any()),
          ).thenThrow(const AuthException('API Error: 401 unauthorized'));

          final result = await repository.login(
            'alex@example.com',
            'secret123',
          );

          expect(result, isA<FailureResult<AuthSession, Failure>>());
          expect(
            (result as FailureResult<AuthSession, Failure>).failure,
            isA<AuthFailure>(),
          );
          verify(
            () => apiClient.post('/auth/login', {
              'email': 'alex@example.com',
              'password': 'secret123',
            }),
          ).called(1);
          verifyNever(() => apiClient.get('/member/profile'));
          verify(() => apiClient.setToken(null)).called(1);
          verifyNever(() => sessionRepository.saveAuthToken(any()));
        },
      );

      test('returns Failure(NetworkFailure) on network error', () async {
        when(
          () => apiClient.post('/auth/login', any()),
        ).thenThrow(const NetworkException('offline'));

        final result = await repository.login('alex@example.com', 'secret123');

        expect(result, isA<FailureResult<AuthSession, Failure>>());
        expect(
          (result as FailureResult<AuthSession, Failure>).failure,
          isA<NetworkFailure>(),
        );
      });

      test('returns Failure(ServerFailure) on 500 error', () async {
        when(
          () => apiClient.post('/auth/login', any()),
        ).thenThrow(const ServerException('API Error: 500 server error'));

        final result = await repository.login('alex@example.com', 'secret123');

        expect(result, isA<FailureResult<AuthSession, Failure>>());
        expect(
          (result as FailureResult<AuthSession, Failure>).failure,
          isA<ServerFailure>(),
        );
      });

      test(
        'converts pendingAdditionalVerification to pendingOnboarding when profile fetch fails',
        () async {
          const token = 'incomplete-onboarding-token';

          // Backend returns pendingAdditionalVerification
          when(
            () => apiClient.post('/auth/login', {
              'email': 'incomplete@example.com',
              'password': 'secret123',
            }),
          ).thenAnswer(
            (_) async => {
              'token': token,
              'state': 'pending_additional_verification',
            },
          );

          // Profile fetch fails (user hasn't completed onboarding yet)
          when(
            () => apiClient.get(
              '/member/profile',
              fullResponse: false,
              skipAuthError: true,
            ),
          ).thenThrow(const ServerException('Forbidden: 403'));

          when(
            () => sessionRepository.saveAuthToken(token),
          ).thenAnswer((_) async => const Success<void, Failure>(null));

          final eventExpectation = expectLater(
            repository.onAuthStateChanged,
            emits(
              predicate<AuthSession>(
                (value) =>
                    value.state == AuthState.pendingOnboarding &&
                    value.token == token,
              ),
            ),
          );

          final result = await repository.login(
            'incomplete@example.com',
            'secret123',
          );

          expect(result, isA<Success<AuthSession, Failure>>());
          final session = (result as Success<AuthSession, Failure>).data;
          expect(session.state, AuthState.pendingOnboarding);
          expect(session.token, token);
          verify(
            () => apiClient.post('/auth/login', {
              'email': 'incomplete@example.com',
              'password': 'secret123',
            }),
          ).called(1);
          verify(
            () => apiClient.get(
              '/member/profile',
              fullResponse: false,
              skipAuthError: true,
            ),
          ).called(1);
          await eventExpectation;
        },
      );
    });

    group('logout', () {
      test('returns Success on 200 and clears the local session', () async {
        when(
          () => apiClient.post('/auth/logout', {}),
        ).thenAnswer((_) async => null);
        when(
          () => sessionRepository.clearSession(),
        ).thenAnswer((_) async => const Success<void, Failure>(null));

        final eventExpectation = expectLater(
          repository.onAuthStateChanged,
          emits(
            predicate<AuthSession>(
              (value) => value.state == AuthState.unauthenticated,
            ),
          ),
        );

        final result = await repository.logout();

        expect(result, isA<Success<void, Failure>>());
        verify(() => apiClient.post('/auth/logout', {})).called(1);
        verify(() => apiClient.setToken(null)).called(1);
        verify(() => sessionRepository.clearSession()).called(1);
        await eventExpectation;
      });

      test('returns Failure(AuthFailure) on 401', () async {
        when(
          () => apiClient.post('/auth/logout', {}),
        ).thenThrow(const AuthException('API Error: 401 unauthorized'));
        when(
          () => sessionRepository.clearSession(),
        ).thenAnswer((_) async => const Success<void, Failure>(null));

        final result = await repository.logout();

        expect(result, isA<FailureResult<void, Failure>>());
        expect(
          (result as FailureResult<void, Failure>).failure,
          isA<AuthFailure>(),
        );
        verify(() => apiClient.setToken(null)).called(1);
        verify(() => sessionRepository.clearSession()).called(1);
      });

      test('returns Failure(NetworkFailure) on network error', () async {
        when(
          () => apiClient.post('/auth/logout', {}),
        ).thenThrow(const NetworkException('offline'));
        when(
          () => sessionRepository.clearSession(),
        ).thenAnswer((_) async => const Success<void, Failure>(null));

        final result = await repository.logout();

        expect(result, isA<FailureResult<void, Failure>>());
        expect(
          (result as FailureResult<void, Failure>).failure,
          isA<NetworkFailure>(),
        );
      });

      test('returns Failure(ServerFailure) on 500 error', () async {
        when(
          () => apiClient.post('/auth/logout', {}),
        ).thenThrow(const ServerException('API Error: 500 server error'));
        when(
          () => sessionRepository.clearSession(),
        ).thenAnswer((_) async => const Success<void, Failure>(null));

        final result = await repository.logout();

        expect(result, isA<FailureResult<void, Failure>>());
        expect(
          (result as FailureResult<void, Failure>).failure,
          isA<ServerFailure>(),
        );
      });
    });

    group('register', () {
      test('returns Success on 200', () async {
        when(() => apiClient.post('/auth/register', any())).thenAnswer(
          (_) async => {
            'token': 'verify-token',
            'state': 'pending_verification',
          },
        );

        final result = await repository.register(
          firstName: 'Alex',
          lastName: 'Morgan',
          email: 'alex@example.com',
          phone: '+15550000000',
          password: 'secret123',
          gender: 'male',
          birthDate: DateTime.utc(1990, 1, 1),
        );

        expect(result, isA<Success<void, Failure>>());
        verify(
          () => apiClient.post('/auth/register', {
            'name': 'Alex Morgan',
            'email': 'alex@example.com',
            'phone': '+15550000000',
            'gender': 'male',
            'date_of_birth': '1990-01-01',
            'password': 'secret123',
            'password_confirmation': 'secret123',
            'is_parent_account': false,
          }),
        ).called(1);
      });

      test('returns Failure(AuthFailure) on 401', () async {
        when(
          () => apiClient.post('/auth/register', any()),
        ).thenThrow(const AuthException('API Error: 401 unauthorized'));

        final result = await repository.register(
          firstName: 'Alex',
          lastName: 'Morgan',
          email: 'alex@example.com',
          phone: '+15550000000',
          password: 'secret123',
          gender: 'male',
          birthDate: DateTime.utc(1990, 1, 1),
        );

        expect(result, isA<FailureResult<void, Failure>>());
        expect(
          (result as FailureResult<void, Failure>).failure,
          isA<AuthFailure>(),
        );
      });

      test('returns Failure(NetworkFailure) on network error', () async {
        when(
          () => apiClient.post('/auth/register', any()),
        ).thenThrow(const NetworkException('offline'));

        final result = await repository.register(
          firstName: 'Alex',
          lastName: 'Morgan',
          email: 'alex@example.com',
          phone: '+15550000000',
          password: 'secret123',
          gender: 'male',
          birthDate: DateTime.utc(1990, 1, 1),
        );

        expect(result, isA<FailureResult<void, Failure>>());
        expect(
          (result as FailureResult<void, Failure>).failure,
          isA<NetworkFailure>(),
        );
      });

      test('returns Failure(ServerFailure) on 500 error', () async {
        when(
          () => apiClient.post('/auth/register', any()),
        ).thenThrow(const ServerException('API Error: 500 server error'));

        final result = await repository.register(
          firstName: 'Alex',
          lastName: 'Morgan',
          email: 'alex@example.com',
          phone: '+15550000000',
          password: 'secret123',
          gender: 'male',
          birthDate: DateTime.utc(1990, 1, 1),
        );

        expect(result, isA<FailureResult<void, Failure>>());
        expect(
          (result as FailureResult<void, Failure>).failure,
          isA<ServerFailure>(),
        );
      });
    });

    group('sendOtp', () {
      test('returns Success on 200', () async {
        when(
          () => apiClient.post('/auth/send-otp', any()),
        ).thenAnswer((_) async => null);

        final result = await repository.sendOtp('alex@example.com');

        expect(result, isA<Success<void, Failure>>());
        verify(
          () => apiClient.post('/auth/send-otp', {
            'identifier': 'alex@example.com',
          }),
        ).called(1);
      });

      test('returns Failure(AuthFailure) on 401', () async {
        when(
          () => apiClient.post('/auth/send-otp', any()),
        ).thenThrow(const AuthException('API Error: 401 unauthorized'));

        final result = await repository.sendOtp('alex@example.com');

        expect(result, isA<FailureResult<void, Failure>>());
        expect(
          (result as FailureResult<void, Failure>).failure,
          isA<AuthFailure>(),
        );
      });

      test('returns Failure(NetworkFailure) on network error', () async {
        when(
          () => apiClient.post('/auth/send-otp', any()),
        ).thenThrow(const NetworkException('offline'));

        final result = await repository.sendOtp('alex@example.com');

        expect(result, isA<FailureResult<void, Failure>>());
        expect(
          (result as FailureResult<void, Failure>).failure,
          isA<NetworkFailure>(),
        );
      });

      test('returns Failure(ServerFailure) on 500 error', () async {
        when(
          () => apiClient.post('/auth/send-otp', any()),
        ).thenThrow(const ServerException('API Error: 500 server error'));

        final result = await repository.sendOtp('alex@example.com');

        expect(result, isA<FailureResult<void, Failure>>());
        expect(
          (result as FailureResult<void, Failure>).failure,
          isA<ServerFailure>(),
        );
      });
    });

    group('verifyOtp', () {
      test('returns Success on 200', () async {
        when(
          () => apiClient.post('/auth/verify-otp', any()),
        ).thenAnswer((_) async => {'valid': true});

        final result = await repository.verifyOtp('alex@example.com', '123456');

        expect(result, isA<Success<bool, Failure>>());
        expect((result as Success<bool, Failure>).data, isTrue);
      });

      test('returns Failure(AuthFailure) on 401', () async {
        when(
          () => apiClient.post('/auth/verify-otp', any()),
        ).thenThrow(const AuthException('API Error: 401 unauthorized'));

        final result = await repository.verifyOtp('alex@example.com', '123456');

        expect(result, isA<FailureResult<bool, Failure>>());
        expect(
          (result as FailureResult<bool, Failure>).failure,
          isA<AuthFailure>(),
        );
      });

      test('returns Failure(NetworkFailure) on network error', () async {
        when(
          () => apiClient.post('/auth/verify-otp', any()),
        ).thenThrow(const NetworkException('offline'));

        final result = await repository.verifyOtp('alex@example.com', '123456');

        expect(result, isA<FailureResult<bool, Failure>>());
        expect(
          (result as FailureResult<bool, Failure>).failure,
          isA<NetworkFailure>(),
        );
      });

      test('returns Failure(ServerFailure) on 500 error', () async {
        when(
          () => apiClient.post('/auth/verify-otp', any()),
        ).thenThrow(const ServerException('API Error: 500 server error'));

        final result = await repository.verifyOtp('alex@example.com', '123456');

        expect(result, isA<FailureResult<bool, Failure>>());
        expect(
          (result as FailureResult<bool, Failure>).failure,
          isA<ServerFailure>(),
        );
      });
    });

    group('requestFamilyAccountOtp', () {
      test('returns Success on 200', () async {
        when(() => apiClient.post('/auth/request-family-otp', {})).thenAnswer(
          (_) async => {
            'success': true,
            'message': 'OTP code sent to your registered email.',
            'data': null,
          },
        );

        final result = await repository.requestFamilyAccountOtp();

        expect(result, isA<Success<String, Failure>>());
        expect(
          (result as Success<String, Failure>).data,
          'OTP code sent to your registered email.',
        );
      });

      test('returns Failure(AuthFailure) on 401', () async {
        when(
          () => apiClient.post('/auth/request-family-otp', {}),
        ).thenThrow(const AuthException('API Error: 401 unauthorized'));

        final result = await repository.requestFamilyAccountOtp();

        expect(result, isA<FailureResult<String, Failure>>());
        expect(
          (result as FailureResult<String, Failure>).failure,
          isA<AuthFailure>(),
        );
      });

      test('returns Failure(NetworkFailure) on network error', () async {
        when(
          () => apiClient.post('/auth/request-family-otp', {}),
        ).thenThrow(const NetworkException('offline'));

        final result = await repository.requestFamilyAccountOtp();

        expect(result, isA<FailureResult<String, Failure>>());
        expect(
          (result as FailureResult<String, Failure>).failure,
          isA<NetworkFailure>(),
        );
      });

      test('returns Failure(ServerFailure) on 500 error', () async {
        when(
          () => apiClient.post('/auth/request-family-otp', {}),
        ).thenThrow(const ServerException('API Error: 500 server error'));

        final result = await repository.requestFamilyAccountOtp();

        expect(result, isA<FailureResult<String, Failure>>());
        expect(
          (result as FailureResult<String, Failure>).failure,
          isA<ServerFailure>(),
        );
      });
    });

    group('completeRegistration', () {
      test('returns Success on 200 and emits the user', () async {
        final user = testUserEntity(
          isParentAccount: true,
          birthDate: DateTime.utc(1990, 1, 1),
        );
        when(
          () => apiClient.post('/auth/complete-registration', any()),
        ).thenAnswer((_) async => {'state': 'active'});
        final eventExpectation = expectLater(
          repository.onAuthStateChanged,
          emits(
            predicate<AuthSession>(
              (value) =>
                  value.state == AuthState.authenticated &&
                  value.user?.id == user.id,
            ),
          ),
        );

        final result = await repository.completeRegistration(user);

        expect(result, isA<Success<void, Failure>>());
        verify(
          () => apiClient.post('/auth/complete-registration', {
            'name': 'Alex Morgan',
            'email': 'alex@example.com',
            'phone': '+15550000000',
            'date_of_birth': '1990-01-01',
            'gender': 'male',
            'is_parent_account': true,
          }),
        ).called(1);
        await eventExpectation;
      });

      test('returns Failure(AuthFailure) on 401', () async {
        when(
          () => apiClient.post('/auth/complete-registration', any()),
        ).thenThrow(const AuthException('API Error: 401 unauthorized'));

        final result = await repository.completeRegistration(testUserEntity());

        expect(result, isA<FailureResult<void, Failure>>());
        expect(
          (result as FailureResult<void, Failure>).failure,
          isA<AuthFailure>(),
        );
      });

      test('returns Failure(NetworkFailure) on network error', () async {
        when(
          () => apiClient.post('/auth/complete-registration', any()),
        ).thenThrow(const NetworkException('offline'));

        final result = await repository.completeRegistration(testUserEntity());

        expect(result, isA<FailureResult<void, Failure>>());
        expect(
          (result as FailureResult<void, Failure>).failure,
          isA<NetworkFailure>(),
        );
      });

      test('returns Failure(ServerFailure) on 500 error', () async {
        when(
          () => apiClient.post('/auth/complete-registration', any()),
        ).thenThrow(const ServerException('API Error: 500 server error'));

        final result = await repository.completeRegistration(testUserEntity());

        expect(result, isA<FailureResult<void, Failure>>());
        expect(
          (result as FailureResult<void, Failure>).failure,
          isA<ServerFailure>(),
        );
      });
    });

    group('updatePassword', () {
      test('returns Success on 200', () async {
        when(
          () => apiClient.put('/member/password', any()),
        ).thenAnswer((_) async => null);

        final result = await repository.updatePassword(
          currentPassword: 'old-pass',
          newPassword: 'new-pass',
        );

        expect(result, isA<Success<void, Failure>>());
        verify(
          () => apiClient.put('/member/password', {
            'current_password': 'old-pass',
            'new_password': 'new-pass',
            'new_password_confirmation': 'new-pass',
          }),
        ).called(1);
      });

      test('returns Failure(AuthFailure) on 401', () async {
        when(
          () => apiClient.put('/member/password', any()),
        ).thenThrow(const AuthException('API Error: 401 unauthorized'));

        final result = await repository.updatePassword(
          currentPassword: 'old-pass',
          newPassword: 'new-pass',
        );

        expect(result, isA<FailureResult<void, Failure>>());
        expect(
          (result as FailureResult<void, Failure>).failure,
          isA<AuthFailure>(),
        );
      });

      test('returns Failure(NetworkFailure) on network error', () async {
        when(
          () => apiClient.put('/member/password', any()),
        ).thenThrow(const NetworkException('offline'));

        final result = await repository.updatePassword(
          currentPassword: 'old-pass',
          newPassword: 'new-pass',
        );

        expect(result, isA<FailureResult<void, Failure>>());
        expect(
          (result as FailureResult<void, Failure>).failure,
          isA<NetworkFailure>(),
        );
      });

      test('returns Failure(ServerFailure) on 500 error', () async {
        when(
          () => apiClient.put('/member/password', any()),
        ).thenThrow(const ServerException('API Error: 500 server error'));

        final result = await repository.updatePassword(
          currentPassword: 'old-pass',
          newPassword: 'new-pass',
        );

        expect(result, isA<FailureResult<void, Failure>>());
        expect(
          (result as FailureResult<void, Failure>).failure,
          isA<ServerFailure>(),
        );
      });
    });

    group('deleteAccount', () {
      test(
        'sends the resolved identifier and preserves deletion cancellation state',
        () async {
          const identifier = 'alex@example.com';
          final userJson = testUserJson(email: identifier);

          when(
            () => apiClient.get('/member/profile', skipAuthError: true),
          ).thenAnswer((_) async => userJson);
          when(
            () => apiClient.post('/auth/delete-account', any()),
          ).thenAnswer((_) async => {'state': 'pending_deletion_cancellation'});

          final eventExpectation = expectLater(
            repository.onAuthStateChanged,
            emits(
              predicate<AuthSession>(
                (value) =>
                    value.state == AuthState.pendingDeletionCancellation &&
                    value.pendingEmail == identifier,
              ),
            ),
          );

          final result = await repository.deleteAccount(password: 'secret123');

          expect(result, isA<Success<void, Failure>>());
          verify(
            () => apiClient.get('/member/profile', skipAuthError: true),
          ).called(1);
          verify(
            () => apiClient.post('/auth/delete-account', {
              'identifier': identifier,
              'password': 'secret123',
            }),
          ).called(1);
          verify(
            () => sessionRepository.savePendingVerificationEmail(identifier),
          ).called(1);
          verify(
            () =>
                sessionRepository.saveAuthState('pendingDeletionCancellation'),
          ).called(1);
          await eventExpectation;
        },
      );
    });

    group('getToken', () {
      test('returns the persisted token from the session repository', () async {
        const resultToken = 'stored-token';
        when(
          () => sessionRepository.getAuthToken(),
        ).thenAnswer((_) async => const Success<String?, Failure>(resultToken));

        final result = await repository.getToken();

        expect(result, isA<Success<String?, Failure>>());
        expect((result as Success<String?, Failure>).data, resultToken);
        verify(() => sessionRepository.getAuthToken()).called(1);
      });
    });

    group('getUserProfile', () {
      test('returns Success and emits AuthSession on 200', () async {
        final userJson = testUserJson();
        final expectedUser = testUserEntity();

        when(
          () => apiClient.get('/member/profile'),
        ).thenAnswer((_) async => userJson);

        final eventExpectation = expectLater(
          repository.onAuthStateChanged,
          emits(
            predicate<AuthSession>(
              (value) =>
                  value.state == AuthState.authenticated &&
                  value.user?.id == expectedUser.id,
            ),
          ),
        );

        final result = await repository.getUserProfile();

        expect(result, isA<Success<AuthSession, Failure>>());
        expect(
          (result as Success<AuthSession, Failure>).data.user?.id,
          expectedUser.id,
        );
        verify(() => apiClient.get('/member/profile')).called(1);
        await eventExpectation;
      });

      test('returns Failure(AuthFailure) on 401 and clears session', () async {
        when(
          () => apiClient.get('/member/profile'),
        ).thenThrow(const AuthException('401'));
        when(
          () => sessionRepository.clearSession(),
        ).thenAnswer((_) async => const Success(null));

        final eventExpectation = expectLater(
          repository.onAuthStateChanged,
          emits(
            predicate<AuthSession>(
              (value) => value.state == AuthState.unauthenticated,
            ),
          ),
        );

        final result = await repository.getUserProfile();

        expect(result, isA<FailureResult<AuthSession, Failure>>());
        expect(
          (result as FailureResult<AuthSession, Failure>).failure,
          isA<AuthFailure>(),
        );
        verify(() => apiClient.setToken(null)).called(1);
        verify(() => sessionRepository.clearSession()).called(1);
        await eventExpectation;
      });
    });

    group('getVerificationStatus', () {
      test('returns success with verification status on 200', () async {
        final verificationStatusJson = testVerificationStatusJson(
          emailVerified: true,
          phoneVerified: false,
        );

        when(
          () =>
              apiClient.get('/member/verification-status', skipAuthError: true),
        ).thenAnswer((_) async => verificationStatusJson);

        final result = await repository.getVerificationStatus();

        expect(result, isA<Success<VerificationStatus, Failure>>());
        final status = (result as Success<VerificationStatus, Failure>).data;
        expect(status.emailVerified, isTrue);
        expect(status.phoneVerified, isFalse);
        expect(status.email, 'alex@example.com');
        verify(
          () =>
              apiClient.get('/member/verification-status', skipAuthError: true),
        ).called(1);
      });

      test('returns failure on server error', () async {
        when(
          () =>
              apiClient.get('/member/verification-status', skipAuthError: true),
        ).thenThrow(const ServerException('Server error'));

        final result = await repository.getVerificationStatus();

        expect(result, isA<FailureResult<VerificationStatus, Failure>>());
        expect(
          (result as FailureResult<VerificationStatus, Failure>).failure,
          isA<ServerFailure>(),
        );
      });

      test('returns failure on network error', () async {
        when(
          () =>
              apiClient.get('/member/verification-status', skipAuthError: true),
        ).thenThrow(const NetworkException('Connection error'));

        final result = await repository.getVerificationStatus();

        expect(result, isA<FailureResult<VerificationStatus, Failure>>());
        expect(
          (result as FailureResult<VerificationStatus, Failure>).failure,
          isA<NetworkFailure>(),
        );
      });

      test('handles both methods verified', () async {
        final verificationStatusJson = testVerificationStatusJson(
          emailVerified: true,
          phoneVerified: true,
          isFullyVerified: true,
        );

        when(
          () =>
              apiClient.get('/member/verification-status', skipAuthError: true),
        ).thenAnswer((_) async => verificationStatusJson);

        final result = await repository.getVerificationStatus();

        expect(result, isA<Success<VerificationStatus, Failure>>());
        final status = (result as Success<VerificationStatus, Failure>).data;
        expect(status.isFullyVerified, isTrue);
      });
    });

    group('verifyEmail', () {
      test('returns success and broadcasts auth state on 200', () async {
        const token = 'new-token-123';
        final responseData = {
          'valid': true,
          'token': token,
          'state': 'pending_onboarding',
        };

        when(
          () => apiClient.post('/member/verify-email', {
            'email': 'alex@example.com',
            'otp': '123456',
          }),
        ).thenAnswer((_) async => responseData);
        when(
          () => sessionRepository.saveAuthToken(token),
        ).thenAnswer((_) async => const Success<void, Failure>(null));

        final eventExpectation = expectLater(
          repository.onAuthStateChanged,
          emits(
            predicate<AuthSession>(
              (value) => value.state == AuthState.pendingOnboarding,
            ),
          ),
        );

        final result = await repository.verifyEmail(
          'alex@example.com',
          '123456',
        );

        expect(result, isA<Success<bool, Failure>>());
        expect((result as Success<bool, Failure>).data, isTrue);
        verify(
          () => apiClient.post('/member/verify-email', {
            'email': 'alex@example.com',
            'otp': '123456',
          }),
        ).called(1);
        verify(() => sessionRepository.saveAuthToken(token)).called(1);
        await eventExpectation;
      });

      test('returns failure on invalid OTP', () async {
        when(
          () => apiClient.post('/member/verify-email', any()),
        ).thenThrow(const ServerException('Invalid OTP'));

        final result = await repository.verifyEmail(
          'alex@example.com',
          '999999',
        );

        expect(result, isA<FailureResult<bool, Failure>>());
        expect(
          (result as FailureResult<bool, Failure>).failure,
          isA<ServerFailure>(),
        );
      });

      test('handles network error', () async {
        when(
          () => apiClient.post('/member/verify-email', any()),
        ).thenThrow(const NetworkException('Connection timeout'));

        final result = await repository.verifyEmail(
          'alex@example.com',
          '123456',
        );

        expect(result, isA<FailureResult<bool, Failure>>());
        expect(
          (result as FailureResult<bool, Failure>).failure,
          isA<NetworkFailure>(),
        );
      });

      test('maps pending_additional_verification state correctly', () async {
        const token = 'token-with-limited-scope';
        final responseData = {
          'valid': true,
          'token': token,
          'state': 'pending_additional_verification',
        };

        when(
          () => apiClient.post('/member/verify-email', any()),
        ).thenAnswer((_) async => responseData);
        when(
          () => sessionRepository.saveAuthToken(token),
        ).thenAnswer((_) async => const Success<void, Failure>(null));

        final eventExpectation = expectLater(
          repository.onAuthStateChanged,
          emits(
            predicate<AuthSession>(
              (value) => value.state == AuthState.pendingAdditionalVerification,
            ),
          ),
        );

        final result = await repository.verifyEmail(
          'alex@example.com',
          '123456',
        );

        expect(result, isA<Success<bool, Failure>>());
        await eventExpectation;
      });

      test('saves auth token on successful verification', () async {
        const token = 'new-token-456';

        when(() => apiClient.post('/member/verify-email', any())).thenAnswer(
          (_) async => {
            'valid': true,
            'token': token,
            'state': 'pending_onboarding',
          },
        );
        when(
          () => sessionRepository.saveAuthToken(token),
        ).thenAnswer((_) async => const Success<void, Failure>(null));

        await repository.verifyEmail('alex@example.com', '123456');

        verify(() => sessionRepository.saveAuthToken(token)).called(1);
      });
    });

    group('verifyPhone', () {
      test('returns success and broadcasts auth state on 200', () async {
        const token = 'phone-verified-token';
        final responseData = {'valid': true, 'token': token, 'state': 'active'};

        when(
          () => apiClient.post('/member/verify-phone', {
            'phone': '+15550000000',
            'otp': '123456',
          }),
        ).thenAnswer((_) async => responseData);
        when(
          () => sessionRepository.saveAuthToken(token),
        ).thenAnswer((_) async => const Success<void, Failure>(null));
        when(
          () => apiClient.get('/member/profile'),
        ).thenAnswer((_) async => testUserJson());

        final eventExpectation = expectLater(
          repository.onAuthStateChanged,
          emits(
            predicate<AuthSession>(
              (value) => value.state == AuthState.authenticated,
            ),
          ),
        );

        final result = await repository.verifyPhone('+15550000000', '123456');

        expect(result, isA<Success<bool, Failure>>());
        expect((result as Success<bool, Failure>).data, isTrue);
        verify(
          () => apiClient.post('/member/verify-phone', {
            'phone': '+15550000000',
            'otp': '123456',
          }),
        ).called(1);
        await eventExpectation;
      });

      test('returns failure on invalid OTP', () async {
        when(
          () => apiClient.post('/member/verify-phone', any()),
        ).thenThrow(const ServerException('Invalid OTP'));

        final result = await repository.verifyPhone('+15550000000', '999999');

        expect(result, isA<FailureResult<bool, Failure>>());
        expect(
          (result as FailureResult<bool, Failure>).failure,
          isA<ServerFailure>(),
        );
      });

      test('handles network error', () async {
        when(
          () => apiClient.post('/member/verify-phone', any()),
        ).thenThrow(const NetworkException('Connection timeout'));

        final result = await repository.verifyPhone('+15550000000', '123456');

        expect(result, isA<FailureResult<bool, Failure>>());
        expect(
          (result as FailureResult<bool, Failure>).failure,
          isA<NetworkFailure>(),
        );
      });

      test('maps pending_additional_verification state correctly', () async {
        const token = 'token-with-limited-scope';
        final responseData = {
          'valid': true,
          'token': token,
          'state': 'pending_additional_verification',
        };

        when(
          () => apiClient.post('/member/verify-phone', any()),
        ).thenAnswer((_) async => responseData);
        when(
          () => sessionRepository.saveAuthToken(token),
        ).thenAnswer((_) async => const Success<void, Failure>(null));

        final eventExpectation = expectLater(
          repository.onAuthStateChanged,
          emits(
            predicate<AuthSession>(
              (value) => value.state == AuthState.pendingAdditionalVerification,
            ),
          ),
        );

        final result = await repository.verifyPhone('+15550000000', '123456');

        expect(result, isA<Success<bool, Failure>>());
        await eventExpectation;
      });

      test('saves auth token on successful verification', () async {
        const token = 'phone-token-789';

        when(() => apiClient.post('/member/verify-phone', any())).thenAnswer(
          (_) async => {'valid': true, 'token': token, 'state': 'active'},
        );
        when(
          () => sessionRepository.saveAuthToken(token),
        ).thenAnswer((_) async => const Success<void, Failure>(null));
        when(
          () => apiClient.get('/member/profile'),
        ).thenAnswer((_) async => testUserJson());

        await repository.verifyPhone('+15550000000', '123456');

        verify(() => sessionRepository.saveAuthToken(token)).called(1);
      });

      test('handles different phone number formats', () async {
        final phoneNumbers = ['+15550000000', '15550000000', '555-000-0000'];

        for (final phone in phoneNumbers) {
          when(
            () => apiClient.post('/member/verify-phone', {
              'phone': phone,
              'otp': '123456',
            }),
          ).thenAnswer(
            (_) async => {
              'valid': true,
              'token': 'token',
              'state': 'authenticated',
            },
          );
          when(
            () => sessionRepository.saveAuthToken('token'),
          ).thenAnswer((_) async => const Success<void, Failure>(null));
          when(
            () => apiClient.get('/member/profile'),
          ).thenAnswer((_) async => testUserJson());

          final result = await repository.verifyPhone(phone, '123456');

          expect(result, isA<Success<bool, Failure>>());
        }
      });
    });
  });
}
