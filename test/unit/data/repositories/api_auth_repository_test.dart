import 'package:bourgo_arena_mobile/core/utils/result.dart';
import 'package:bourgo_arena_mobile/data/api/api_client.dart';
import 'package:bourgo_arena_mobile/data/api/api_exceptions.dart';
import 'package:bourgo_arena_mobile/data/repositories/api_auth_repository.dart';
import 'package:bourgo_arena_mobile/domain/core/failure.dart';
import 'package:bourgo_arena_mobile/domain/entities/user.dart';
import 'package:bourgo_arena_mobile/domain/repositories/session_repository.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import 'repository_test_fixtures.dart';

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
        ).thenAnswer((_) async => {'token': token});

        when(
          () => apiClient.get('/user/profile'),
        ).thenAnswer((_) async => userJson);
        when(
          () => sessionRepository.saveAuthToken(token),
        ).thenAnswer((_) async => const Success<void, Failure>(null));

        final eventExpectation = expectLater(
          repository.onAuthStateChanged,
          emits(
            predicate<User?>(
              (value) =>
                  value != null &&
                  value.id == expectedUser.id &&
                  value.firstName == expectedUser.firstName &&
                  value.lastName == expectedUser.lastName &&
                  value.children.length == expectedUser.children.length,
            ),
          ),
        );

        final result = await repository.login('alex@example.com', 'secret123');

        expect(result, isA<Success<User, Failure>>());
        expect((result as Success<User, Failure>).data.id, expectedUser.id);
        expect(result.data.firstName, expectedUser.firstName);
        expect(result.data.lastName, expectedUser.lastName);
        expect(result.data.avatarUrl, expectedUser.avatarUrl);
        expect(result.data.children, hasLength(1));
        verify(
          () => apiClient.post('/auth/login', {
            'email': 'alex@example.com',
            'password': 'secret123',
          }),
        ).called(1);
        verify(() => apiClient.setToken(token)).called(1);
        verify(() => sessionRepository.saveAuthToken(token)).called(1);
        verify(() => apiClient.get('/user/profile')).called(1);
        await eventExpectation;
        verifyNoMoreInteractions(sessionRepository);
      });

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

          expect(result, isA<FailureResult<User, Failure>>());
          expect(
            (result as FailureResult<User, Failure>).failure,
            isA<AuthFailure>(),
          );
          verify(
            () => apiClient.post('/auth/login', {
              'email': 'alex@example.com',
              'password': 'secret123',
            }),
          ).called(1);
          verifyNever(() => apiClient.get('/user/profile'));
          verifyNever(() => apiClient.setToken(null));
          verifyNever(() => sessionRepository.saveAuthToken(any()));
        },
      );

      test('returns Failure(NetworkFailure) on network error', () async {
        when(
          () => apiClient.post('/auth/login', any()),
        ).thenThrow(const NetworkException('offline'));

        final result = await repository.login('alex@example.com', 'secret123');

        expect(result, isA<FailureResult<User, Failure>>());
        expect(
          (result as FailureResult<User, Failure>).failure,
          isA<NetworkFailure>(),
        );
      });

      test('returns Failure(ServerFailure) on 500 error', () async {
        when(
          () => apiClient.post('/auth/login', any()),
        ).thenThrow(const ServerException('API Error: 500 server error'));

        final result = await repository.login('alex@example.com', 'secret123');

        expect(result, isA<FailureResult<User, Failure>>());
        expect(
          (result as FailureResult<User, Failure>).failure,
          isA<ServerFailure>(),
        );
      });
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
          emits(null),
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
        when(
          () => apiClient.post('/auth/register', any()),
        ).thenAnswer((_) async => null);

        final result = await repository.register(
          firstName: 'Alex',
          lastName: 'Morgan',
          email: 'alex@example.com',
          phone: '+15550000000',
          password: 'secret123',
        );

        expect(result, isA<Success<void, Failure>>());
        verify(
          () => apiClient.post('/auth/register', {
            'name': 'Alex Morgan',
            'email': 'alex@example.com',
            'phone': '+15550000000',
            'password': 'secret123',
            'password_confirmation': 'secret123',
            'is_family_account': false,
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
        ).thenAnswer((_) async => {'success': true});

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
        when(
          () => apiClient.post('/auth/request-family-otp', {}),
        ).thenAnswer((_) async => null);

        final result = await repository.requestFamilyAccountOtp();

        expect(result, isA<Success<void, Failure>>());
      });

      test('returns Failure(AuthFailure) on 401', () async {
        when(
          () => apiClient.post('/auth/request-family-otp', {}),
        ).thenThrow(const AuthException('API Error: 401 unauthorized'));

        final result = await repository.requestFamilyAccountOtp();

        expect(result, isA<FailureResult<void, Failure>>());
        expect(
          (result as FailureResult<void, Failure>).failure,
          isA<AuthFailure>(),
        );
      });

      test('returns Failure(NetworkFailure) on network error', () async {
        when(
          () => apiClient.post('/auth/request-family-otp', {}),
        ).thenThrow(const NetworkException('offline'));

        final result = await repository.requestFamilyAccountOtp();

        expect(result, isA<FailureResult<void, Failure>>());
        expect(
          (result as FailureResult<void, Failure>).failure,
          isA<NetworkFailure>(),
        );
      });

      test('returns Failure(ServerFailure) on 500 error', () async {
        when(
          () => apiClient.post('/auth/request-family-otp', {}),
        ).thenThrow(const ServerException('API Error: 500 server error'));

        final result = await repository.requestFamilyAccountOtp();

        expect(result, isA<FailureResult<void, Failure>>());
        expect(
          (result as FailureResult<void, Failure>).failure,
          isA<ServerFailure>(),
        );
      });
    });

    group('completeRegistration', () {
      test('returns Success on 200 and emits the user', () async {
        final user = testUserEntity(isParentAccount: true);
        when(
          () => apiClient.post('/auth/complete-registration', any()),
        ).thenAnswer((_) async => null);
        final eventExpectation = expectLater(
          repository.onAuthStateChanged,
          emits(user),
        );

        final result = await repository.completeRegistration(user);

        expect(result, isA<Success<void, Failure>>());
        verify(
          () => apiClient.post('/auth/complete-registration', {
            'name': 'Alex Morgan',
            'email': 'alex@example.com',
            'phone': '+15550000000',
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
          () => apiClient.put('/user/password', any()),
        ).thenAnswer((_) async => null);

        final result = await repository.updatePassword(
          currentPassword: 'old-pass',
          newPassword: 'new-pass',
        );

        expect(result, isA<Success<void, Failure>>());
        verify(
          () => apiClient.put('/user/password', {
            'current_password': 'old-pass',
            'new_password': 'new-pass',
            'new_password_confirmation': 'new-pass',
          }),
        ).called(1);
      });

      test('returns Failure(AuthFailure) on 401', () async {
        when(
          () => apiClient.put('/user/password', any()),
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
          () => apiClient.put('/user/password', any()),
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
          () => apiClient.put('/user/password', any()),
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
  });
}
