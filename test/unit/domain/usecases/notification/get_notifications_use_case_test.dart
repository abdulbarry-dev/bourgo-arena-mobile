import 'package:bourgo_arena_mobile/core/utils/result.dart';
import 'package:bourgo_arena_mobile/domain/core/failure.dart';
import 'package:bourgo_arena_mobile/domain/core/paginated_result.dart';
import 'package:bourgo_arena_mobile/domain/entities/notification.dart';
import 'package:bourgo_arena_mobile/domain/repositories/notification_repository.dart';
import 'package:bourgo_arena_mobile/domain/usecases/notification/get_notifications_use_case.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import '../usecase_test_fixtures.dart';
import 'package:bourgo_arena_mobile/domain/core/app_error_code.dart';

class MockNotificationRepository extends Mock
    implements NotificationRepository {}

void main() {
  late MockNotificationRepository repository;
  late GetNotificationsUseCase useCase;

  setUp(() {
    registerFallbackValue(testNotification());
    repository = MockNotificationRepository();
    useCase = GetNotificationsUseCase(repository);
  });

  group('GetNotificationsUseCase', () {
    test('returns notifications on success', () async {
      final notifications = <Notification>[testNotification()];
      final paginated = PaginatedResult(
        data: notifications,
        currentPage: 1,
        lastPage: 1,
        total: 1,
        hasMore: false,
      );
      when(
        () => repository.getNotifications(page: any(named: 'page')),
      ).thenAnswer(
        (_) async => Success<PaginatedResult<Notification>, Failure>(paginated),
      );

      final result = await useCase();

      expect(result, isA<Success<PaginatedResult<Notification>, Failure>>());
      expect(
        (result as Success<PaginatedResult<Notification>, Failure>).data,
        same(paginated),
      );
      verify(() => repository.getNotifications(page: 1)).called(1);
      verifyNoMoreInteractions(repository);
    });

    test('propagates repository failures unchanged', () async {
      const failure = ServerFailure(
        AppErrorCode.serverError,
        'notifications unavailable',
      );

      when(
        () => repository.getNotifications(page: any(named: 'page')),
      ).thenAnswer(
        (_) async =>
            const FailureResult<PaginatedResult<Notification>, Failure>(
              failure,
            ),
      );

      final result = await useCase();

      expect(
        result,
        isA<FailureResult<PaginatedResult<Notification>, Failure>>(),
      );
      expect(
        (result as FailureResult<PaginatedResult<Notification>, Failure>)
            .failure,
        same(failure),
      );
      verify(() => repository.getNotifications(page: 1)).called(1);
      verifyNoMoreInteractions(repository);
    });

    test('returns empty notification lists unchanged', () async {
      final emptyPaginated = PaginatedResult<Notification>(
        data: [],
        currentPage: 1,
        lastPage: 1,
        total: 0,
        hasMore: false,
      );
      when(
        () => repository.getNotifications(page: any(named: 'page')),
      ).thenAnswer(
        (_) async =>
            Success<PaginatedResult<Notification>, Failure>(emptyPaginated),
      );

      final result = await useCase();

      expect(result, isA<Success<PaginatedResult<Notification>, Failure>>());
      expect(
        (result as Success<PaginatedResult<Notification>, Failure>).data.data,
        isEmpty,
      );
      verify(() => repository.getNotifications(page: 1)).called(1);
      verifyNoMoreInteractions(repository);
    });
  });
}
