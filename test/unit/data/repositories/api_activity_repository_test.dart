import 'package:bourgo_arena_mobile/core/utils/result.dart';
import 'package:bourgo_arena_mobile/data/api/api_client.dart';
import 'package:bourgo_arena_mobile/data/api/api_exceptions.dart';
import 'package:bourgo_arena_mobile/data/repositories/api_activity_repository.dart';
import 'package:bourgo_arena_mobile/domain/core/failure.dart';
import 'package:bourgo_arena_mobile/domain/entities/activity.dart';
import 'package:bourgo_arena_mobile/domain/entities/time_slot.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import 'repository_test_fixtures.dart';

class MockApiClient extends Mock implements ApiClient {}

void main() {
  late MockApiClient apiClient;
  late ApiActivityRepository repository;

  setUp(() {
    apiClient = MockApiClient();
    repository = ApiActivityRepository(apiClient);
  });

  group('ApiActivityRepository', () {
    group('getActivities', () {
      test('returns Success on 200 with mapped activities', () async {
        final json = [testActivityJson()];
          when(() => apiClient.get('/activities', fullResponse: true)).thenAnswer((_) async => {'data': json});

        final result = await repository.getActivities();

        expect(result, isA<Success<List<Activity>, Failure>>());
        expect((result as Success<List<Activity>, Failure>).data, hasLength(1));
        expect(result.data.first.id, 'activity-1');
        expect(result.data.first.title, 'Football');
      });

      test('returns Failure(AuthFailure) on 401', () async {
        when(
          () => apiClient.get('/activities', fullResponse: true),
        ).thenThrow(const AuthException('API Error: 401 unauthorized'));

        final result = await repository.getActivities();

        expect(result, isA<FailureResult<List<Activity>, Failure>>());
        expect(
          (result as FailureResult<List<Activity>, Failure>).failure,
          isA<AuthFailure>(),
        );
      });

      test('returns Failure(NetworkFailure) on network error', () async {
        when(
          () => apiClient.get('/activities', fullResponse: true),
        ).thenThrow(const NetworkException('offline'));

        final result = await repository.getActivities();

        expect(result, isA<FailureResult<List<Activity>, Failure>>());
        expect(
          (result as FailureResult<List<Activity>, Failure>).failure,
          isA<NetworkFailure>(),
        );
      });

      test('returns Failure(ServerFailure) on 500 error', () async {
        when(
          () => apiClient.get('/activities', fullResponse: true),
        ).thenThrow(const ServerException('API Error: 500 server error'));

        final result = await repository.getActivities();

        expect(result, isA<FailureResult<List<Activity>, Failure>>());
        expect(
          (result as FailureResult<List<Activity>, Failure>).failure,
          isA<ServerFailure>(),
        );
      });
    });

    group('getActivityById', () {
      test('returns Success on 200 with mapped activity', () async {
        when(
          () => apiClient.get('/activities/activity-1', fullResponse: true),
        ).thenAnswer((_) async => {'data': testActivityJson()});

        final result = await repository.getActivityById('activity-1');

        expect(result, isA<Success<Activity, Failure>>());
        expect((result as Success<Activity, Failure>).data.id, 'activity-1');
      });

      test('returns Failure(AuthFailure) on 401', () async {
        when(
          () => apiClient.get('/activities/activity-1', fullResponse: true),
        ).thenThrow(const AuthException('API Error: 401 unauthorized'));

        final result = await repository.getActivityById('activity-1');

        expect(result, isA<FailureResult<Activity, Failure>>());
        expect(
          (result as FailureResult<Activity, Failure>).failure,
          isA<AuthFailure>(),
        );
      });

      test('returns Failure(NetworkFailure) on network error', () async {
        when(
          () => apiClient.get('/activities/activity-1', fullResponse: true),
        ).thenThrow(const NetworkException('offline'));

        final result = await repository.getActivityById('activity-1');

        expect(result, isA<FailureResult<Activity, Failure>>());
        expect(
          (result as FailureResult<Activity, Failure>).failure,
          isA<NetworkFailure>(),
        );
      });

      test('returns Failure(ServerFailure) on 500 error', () async {
        when(
          () => apiClient.get('/activities/activity-1', fullResponse: true),
        ).thenThrow(const ServerException('API Error: 500 server error'));

        final result = await repository.getActivityById('activity-1');

        expect(result, isA<FailureResult<Activity, Failure>>());
        expect(
          (result as FailureResult<Activity, Failure>).failure,
          isA<ServerFailure>(),
        );
      });
    });

    group('getTimeSlots', () {
      test('returns Success on 200 with mapped time slots', () async {
        when(() => apiClient.get('/activities/activity-1/slots', fullResponse: true)).thenAnswer(
          (_) async => {'data': [testTimeSlotJson(), testTimeSlotJson(time: '19:00')]},
        );

        final result = await repository.getTimeSlots('activity-1');

        expect(result, isA<Success<List<TimeSlot>, Failure>>());
        expect((result as Success<List<TimeSlot>, Failure>).data, hasLength(2));
        expect(result.data.first.time, '18:00');
      });

      test('returns Failure(AuthFailure) on 401', () async {
        when(
          () => apiClient.get('/activities/activity-1/slots', fullResponse: true),
        ).thenThrow(const AuthException('API Error: 401 unauthorized'));

        final result = await repository.getTimeSlots('activity-1');

        expect(result, isA<FailureResult<List<TimeSlot>, Failure>>());
        expect(
          (result as FailureResult<List<TimeSlot>, Failure>).failure,
          isA<AuthFailure>(),
        );
      });

      test('returns Failure(NetworkFailure) on network error', () async {
        when(
          () => apiClient.get('/activities/activity-1/slots', fullResponse: true),
        ).thenThrow(const NetworkException('offline'));

        final result = await repository.getTimeSlots('activity-1');

        expect(result, isA<FailureResult<List<TimeSlot>, Failure>>());
        expect(
          (result as FailureResult<List<TimeSlot>, Failure>).failure,
          isA<NetworkFailure>(),
        );
      });

      test('returns Failure(ServerFailure) on 500 error', () async {
        when(
          () => apiClient.get('/activities/activity-1/slots', fullResponse: true),
        ).thenThrow(const ServerException('API Error: 500 server error'));

        final result = await repository.getTimeSlots('activity-1');

        expect(result, isA<FailureResult<List<TimeSlot>, Failure>>());
        expect(
          (result as FailureResult<List<TimeSlot>, Failure>).failure,
          isA<ServerFailure>(),
        );
      });
    });
  });
}
