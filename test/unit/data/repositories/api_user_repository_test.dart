import 'package:bourgo_arena_mobile/core/utils/result.dart';
import 'package:bourgo_arena_mobile/data/api/api_client.dart';
import 'package:bourgo_arena_mobile/data/api/api_exceptions.dart';
import 'package:bourgo_arena_mobile/data/models/child_profile_model.dart';
import 'package:bourgo_arena_mobile/data/repositories/api_user_repository.dart';
import 'package:bourgo_arena_mobile/domain/core/failure.dart';
import 'package:bourgo_arena_mobile/domain/entities/user.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import 'repository_test_fixtures.dart';

class MockApiClient extends Mock implements ApiClient {}

void main() {
  late MockApiClient apiClient;
  late ApiUserRepository repository;

  setUp(() {
    apiClient = MockApiClient();
    repository = ApiUserRepository(apiClient);
  });

  group('ApiUserRepository', () {
    group('getUserProfile', () {
      test('returns Success on 200 with mapped user', () async {
        final childJson = testChildJson(id: 'child-1');
        when(
          () => apiClient.get('/user/profile'),
        ).thenAnswer((_) async => testUserJson(children: [childJson]));

        final result = await repository.getUserProfile();

        expect(result, isA<Success<User, Failure>>());
        expect((result as Success<User, Failure>).data.id, 'user-1');
        expect(result.data.children, hasLength(1));
      });

      test('returns Failure(AuthFailure) on 401', () async {
        when(
          () => apiClient.get('/user/profile'),
        ).thenThrow(const AuthException('API Error: 401 unauthorized'));

        final result = await repository.getUserProfile();

        expect(result, isA<FailureResult<User, Failure>>());
        expect(
          (result as FailureResult<User, Failure>).failure,
          isA<AuthFailure>(),
        );
      });

      test('returns Failure(NetworkFailure) on network error', () async {
        when(
          () => apiClient.get('/user/profile'),
        ).thenThrow(const NetworkException('offline'));

        final result = await repository.getUserProfile();

        expect(result, isA<FailureResult<User, Failure>>());
        expect(
          (result as FailureResult<User, Failure>).failure,
          isA<NetworkFailure>(),
        );
      });

      test('returns Failure(ServerFailure) on 500 error', () async {
        when(
          () => apiClient.get('/user/profile'),
        ).thenThrow(const ServerException('API Error: 500 server error'));

        final result = await repository.getUserProfile();

        expect(result, isA<FailureResult<User, Failure>>());
        expect(
          (result as FailureResult<User, Failure>).failure,
          isA<ServerFailure>(),
        );
      });
    });

    group('updateUserProfile', () {
      test('returns Success on 200 with mapped updated user', () async {
        final user = testUserEntity(
          firstName: 'Jamie',
          lastName: 'Rivera',
          children: [testChildEntity(id: 'child-1', firstName: 'Mia')],
        );

        when(() => apiClient.put('/user/profile', any())).thenAnswer(
          (_) async => testUserJson(
            name: 'Jamie Rivera',
            children: [testChildJson(id: 'child-1', firstName: 'Mia')],
          ),
        );

        final result = await repository.updateUserProfile(user);

        expect(result, isA<Success<User, Failure>>());
        expect((result as Success<User, Failure>).data.firstName, 'Jamie');
        final verification = verify(
          () => apiClient.put('/user/profile', captureAny()),
        )..called(1);
        final body = verification.captured.single as Map<String, dynamic>;
        expect(body['name'], 'Jamie Rivera');
        expect(body['email'], user.email);
        expect(body['children'], hasLength(1));
        expect(body['children'].first, isA<ChildProfileModel>());
      });

      test('returns Failure(AuthFailure) on 401', () async {
        when(
          () => apiClient.put('/user/profile', any()),
        ).thenThrow(const AuthException('API Error: 401 unauthorized'));

        final result = await repository.updateUserProfile(testUserEntity());

        expect(result, isA<FailureResult<User, Failure>>());
        expect(
          (result as FailureResult<User, Failure>).failure,
          isA<AuthFailure>(),
        );
      });

      test('returns Failure(NetworkFailure) on network error', () async {
        when(
          () => apiClient.put('/user/profile', any()),
        ).thenThrow(const NetworkException('offline'));

        final result = await repository.updateUserProfile(testUserEntity());

        expect(result, isA<FailureResult<User, Failure>>());
        expect(
          (result as FailureResult<User, Failure>).failure,
          isA<NetworkFailure>(),
        );
      });

      test('returns Failure(ServerFailure) on 500 error', () async {
        when(
          () => apiClient.put('/user/profile', any()),
        ).thenThrow(const ServerException('API Error: 500 server error'));

        final result = await repository.updateUserProfile(testUserEntity());

        expect(result, isA<FailureResult<User, Failure>>());
        expect(
          (result as FailureResult<User, Failure>).failure,
          isA<ServerFailure>(),
        );
      });
    });
  });
}
