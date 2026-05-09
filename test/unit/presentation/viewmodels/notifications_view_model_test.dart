import 'package:bourgo_arena_mobile/core/utils/result.dart';
import 'package:bourgo_arena_mobile/domain/core/failure.dart';
import 'package:bourgo_arena_mobile/domain/entities/notification.dart'
    as entity;
import 'package:bourgo_arena_mobile/domain/usecases/notification/get_notifications_use_case.dart';
import 'package:bourgo_arena_mobile/presentation/notifications/notifications_view_model.dart';
import 'package:checks/checks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockGetNotificationsUseCase extends Mock
    implements GetNotificationsUseCase {}

void main() {
  late _MockGetNotificationsUseCase mockGetNotifications;

  final testNotifications = [
    entity.Notification(
      id: '1',
      title: 'Test 1',
      message: 'Msg 1',
      timestamp: DateTime(2026, 1, 1),
      type: 'system',
      isRead: false,
    ),
    entity.Notification(
      id: '2',
      title: 'Test 2',
      message: 'Msg 2',
      timestamp: DateTime(2026, 1, 2),
      type: 'booking',
      isRead: true,
    ),
  ];

  setUp(() {
    mockGetNotifications = _MockGetNotificationsUseCase();
  });

  group('NotificationsViewModel', () {
    test('loadNotifications populates list on success', () async {
      when(
        () => mockGetNotifications(),
      ).thenAnswer((_) async => Result.success(testNotifications));

      final viewModel = NotificationsViewModel(
        getNotificationsUseCase: mockGetNotifications,
      );

      // Constructor kicks off loadNotifications(); wait for it to settle.
      await Future.delayed(Duration.zero);

      check(viewModel.isLoading).isFalse();
      check(
        viewModel.notifications,
      ).isNotNull().has((l) => l.length, 'length').equals(2);
      verify(() => mockGetNotifications()).called(1);
    });

    test(
      'loadNotifications keeps list null and stops loading on failure',
      () async {
        when(() => mockGetNotifications()).thenAnswer(
          (_) async => FailureResult(const ServerFailure('Network error')),
        );

        final viewModel = NotificationsViewModel(
          getNotificationsUseCase: mockGetNotifications,
        );

        await Future.delayed(Duration.zero);

        check(viewModel.isLoading).isFalse();
        check(viewModel.notifications).isNull();
      },
    );

    test('markAllAsRead sets every notification to read', () async {
      when(
        () => mockGetNotifications(),
      ).thenAnswer((_) async => Result.success(testNotifications));

      final viewModel = NotificationsViewModel(
        getNotificationsUseCase: mockGetNotifications,
      );

      await Future.delayed(Duration.zero);
      await viewModel.markAllAsRead();

      final allRead = viewModel.notifications?.every((n) => n.isRead) ?? false;
      check(allRead).isTrue();
    });
  });
}
