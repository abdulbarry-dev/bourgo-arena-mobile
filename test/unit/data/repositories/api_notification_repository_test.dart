import 'package:bourgo_arena_mobile/core/utils/result.dart';
import 'package:bourgo_arena_mobile/data/api/api_client.dart';
import 'package:bourgo_arena_mobile/data/api/api_exceptions.dart';
import 'package:bourgo_arena_mobile/data/repositories/api_notification_repository.dart';
import 'package:bourgo_arena_mobile/domain/core/failure.dart';
import 'package:bourgo_arena_mobile/domain/entities/notification.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import 'repository_test_fixtures.dart';

class MockApiClient extends Mock implements ApiClient {}

void main() {
  late MockApiClient apiClient;
  late ApiNotificationRepository repository;

  setUp(() {
    apiClient = MockApiClient();
    repository = ApiNotificationRepository(apiClient);
  });

  group('ApiNotificationRepository', () {
    test('returns Success on 200 with mapped notifications', () async {
      when(
        () => apiClient.get('/notifications'),
      ).thenAnswer((_) async => [testNotificationJson()]);

      final result = await repository.getNotifications();

      expect(result, isA<Success<List<Notification>, Failure>>());
      expect(
        (result as Success<List<Notification>, Failure>).data,
        hasLength(1),
      );
      expect(result.data.first.title, 'Booking confirmed');
    });

    test('returns Failure(AuthFailure) on 401', () async {
      when(
        () => apiClient.get('/notifications'),
      ).thenThrow(const AuthException('API Error: 401 unauthorized'));

      final result = await repository.getNotifications();

      expect(result, isA<FailureResult<List<Notification>, Failure>>());
      expect(
        (result as FailureResult<List<Notification>, Failure>).failure,
        isA<AuthFailure>(),
      );
    });

    test('returns Failure(NetworkFailure) on network error', () async {
      when(
        () => apiClient.get('/notifications'),
      ).thenThrow(const NetworkException('offline'));

      final result = await repository.getNotifications();

      expect(result, isA<FailureResult<List<Notification>, Failure>>());
      expect(
        (result as FailureResult<List<Notification>, Failure>).failure,
        isA<NetworkFailure>(),
      );
    });

    test('returns Failure(ServerFailure) on 500 error', () async {
      when(
        () => apiClient.get('/notifications'),
      ).thenThrow(const ServerException('API Error: 500 server error'));

      final result = await repository.getNotifications();

      expect(result, isA<FailureResult<List<Notification>, Failure>>());
      expect(
        (result as FailureResult<List<Notification>, Failure>).failure,
        isA<ServerFailure>(),
      );
    });
  });
}
