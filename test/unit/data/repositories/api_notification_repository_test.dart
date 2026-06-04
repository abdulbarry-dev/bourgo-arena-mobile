import 'package:bourgo_arena_mobile/core/utils/result.dart';
import 'package:bourgo_arena_mobile/data/api/api_client.dart';
import 'package:bourgo_arena_mobile/data/api/api_exceptions.dart';
import 'package:bourgo_arena_mobile/data/repositories/api_notification_repository.dart';
import 'package:bourgo_arena_mobile/domain/core/failure.dart';
import 'package:bourgo_arena_mobile/domain/core/paginated_result.dart';
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
        () => apiClient.get(
          any(),
          fullResponse: any(named: 'fullResponse'),
          skipAuthError: any(named: 'skipAuthError'),
        ),
      ).thenAnswer(
        (_) async =>
            testPaginatedNotificationsJson(data: [testNotificationJson()]),
      );

      final result = await repository.getNotifications();

      expect(result, isA<Success<PaginatedResult<Notification>, Failure>>());
      final paginated =
          (result as Success<PaginatedResult<Notification>, Failure>).data;
      expect(paginated.data, hasLength(1));
      expect(paginated.data.first.title, 'Booking confirmed');
    });

    test('returns Failure(AuthFailure) on 401', () async {
      when(
        () => apiClient.get(
          any(),
          fullResponse: any(named: 'fullResponse'),
          skipAuthError: any(named: 'skipAuthError'),
        ),
      ).thenThrow(const AuthException('API Error: 401 unauthorized'));

      final result = await repository.getNotifications();

      expect(
        result,
        isA<FailureResult<PaginatedResult<Notification>, Failure>>(),
      );
      expect(
        (result as FailureResult<PaginatedResult<Notification>, Failure>)
            .failure,
        isA<AuthFailure>(),
      );
    });

    test('returns Failure(NetworkFailure) on network error', () async {
      when(
        () => apiClient.get(
          any(),
          fullResponse: any(named: 'fullResponse'),
          skipAuthError: any(named: 'skipAuthError'),
        ),
      ).thenThrow(const NetworkException('offline'));

      final result = await repository.getNotifications();

      expect(
        result,
        isA<FailureResult<PaginatedResult<Notification>, Failure>>(),
      );
      expect(
        (result as FailureResult<PaginatedResult<Notification>, Failure>)
            .failure,
        isA<NetworkFailure>(),
      );
    });

    test('returns Failure(ServerFailure) on 500 error', () async {
      when(
        () => apiClient.get(
          any(),
          fullResponse: any(named: 'fullResponse'),
          skipAuthError: any(named: 'skipAuthError'),
        ),
      ).thenThrow(const ServerException('API Error: 500 server error'));

      final result = await repository.getNotifications();

      expect(
        result,
        isA<FailureResult<PaginatedResult<Notification>, Failure>>(),
      );
      expect(
        (result as FailureResult<PaginatedResult<Notification>, Failure>)
            .failure,
        isA<ServerFailure>(),
      );
    });
  });
}
