import 'package:bourgo_arena_mobile/core/utils/result.dart';
import 'package:bourgo_arena_mobile/domain/core/failure.dart';
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
      when(() => repository.getNotifications()).thenAnswer(
        (_) async => Success<List<Notification>, Failure>(notifications),
      );

      final result = await useCase();

      expect(result, isA<Success<List<Notification>, Failure>>());
      expect(
        (result as Success<List<Notification>, Failure>).data,
        same(notifications),
      );
      verify(() => repository.getNotifications()).called(1);
      verifyNoMoreInteractions(repository);
    });

    test('propagates repository failures unchanged', () async {
      const failure = ServerFailure(
        AppErrorCode.serverError,
        'notifications unavailable',
      );

      when(() => repository.getNotifications()).thenAnswer(
        (_) async => const FailureResult<List<Notification>, Failure>(failure),
      );

      final result = await useCase();

      expect(result, isA<FailureResult<List<Notification>, Failure>>());
      expect(
        (result as FailureResult<List<Notification>, Failure>).failure,
        same(failure),
      );
      verify(() => repository.getNotifications()).called(1);
      verifyNoMoreInteractions(repository);
    });

    test('returns empty notification lists unchanged', () async {
      when(
        () => repository.getNotifications(),
      ).thenAnswer((_) async => const Success<List<Notification>, Failure>([]));

      final result = await useCase();

      expect(result, isA<Success<List<Notification>, Failure>>());
      expect((result as Success<List<Notification>, Failure>).data, isEmpty);
      verify(() => repository.getNotifications()).called(1);
      verifyNoMoreInteractions(repository);
    });
  });
}
