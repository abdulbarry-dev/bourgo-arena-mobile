import 'package:bourgo_arena_mobile/core/utils/result.dart';
import 'package:bourgo_arena_mobile/domain/core/failure.dart';
import 'package:bourgo_arena_mobile/domain/core/paginated_result.dart';
import 'package:bourgo_arena_mobile/domain/entities/notification.dart'
    as entity;
import 'package:bourgo_arena_mobile/domain/usecases/notification/get_notifications_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/notification/mark_notifications_read_use_case.dart';
import 'package:bourgo_arena_mobile/presentation/notifications/notifications_view_model.dart';
import 'package:checks/checks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:bourgo_arena_mobile/domain/core/app_error_code.dart';

class _MockGetNotificationsUseCase extends Mock
    implements GetNotificationsUseCase {}

class _MockMarkNotificationsReadUseCase extends Mock
    implements MarkNotificationsReadUseCase {}

void main() {
  late _MockGetNotificationsUseCase mockGetNotifications;
  late _MockMarkNotificationsReadUseCase mockMarkNotificationsRead;

  final testNotifications = [
    entity.Notification(
      id: 1,
      title: 'Test 1',
      message: 'Msg 1',
      timestamp: DateTime(2026, 1, 1),
      type: 'system',
      isRead: false,
    ),
    entity.Notification(
      id: 2,
      title: 'Test 2',
      message: 'Msg 2',
      timestamp: DateTime(2026, 1, 2),
      type: 'booking',
      isRead: true,
    ),
  ];

  final testPaginated = PaginatedResult(
    data: testNotifications,
    currentPage: 1,
    lastPage: 1,
    total: 2,
    hasMore: false,
  );

  setUp(() {
    mockGetNotifications = _MockGetNotificationsUseCase();
    mockMarkNotificationsRead = _MockMarkNotificationsReadUseCase();
  });

  group('NotificationsViewModel', () {
    test('loadNotifications populates list on success', () async {
      when(
        () => mockGetNotifications(page: any(named: 'page')),
      ).thenAnswer((_) async => Result.success(testPaginated));
      when(
        () => mockMarkNotificationsRead(),
      ).thenAnswer((_) async => Result.success(null));

      final viewModel = NotificationsViewModel(
        getNotificationsUseCase: mockGetNotifications,
        markNotificationsReadUseCase: mockMarkNotificationsRead,
      );

      // Constructor kicks off loadNotifications(); wait for it to settle.
      await Future.delayed(Duration.zero);

      check(viewModel.isLoading).isFalse();
      check(viewModel.notifications).has((l) => l.length, 'length').equals(2);
      verify(() => mockGetNotifications(page: 1)).called(1);
    });

    test('loadNotifications stops loading on failure', () async {
      when(() => mockGetNotifications(page: any(named: 'page'))).thenAnswer(
        (_) async => FailureResult(
          const ServerFailure(AppErrorCode.serverError, 'Network error'),
        ),
      );

      final viewModel = NotificationsViewModel(
        getNotificationsUseCase: mockGetNotifications,
        markNotificationsReadUseCase: mockMarkNotificationsRead,
      );

      await Future.delayed(Duration.zero);

      check(viewModel.isLoading).isFalse();
      check(viewModel.notifications).isEmpty();
    });

    test('markAllAsRead sets every notification to read', () async {
      when(
        () => mockGetNotifications(page: any(named: 'page')),
      ).thenAnswer((_) async => Result.success(testPaginated));
      when(
        () => mockMarkNotificationsRead(),
      ).thenAnswer((_) async => Result.success(null));

      final viewModel = NotificationsViewModel(
        getNotificationsUseCase: mockGetNotifications,
        markNotificationsReadUseCase: mockMarkNotificationsRead,
      );

      await Future.delayed(Duration.zero);
      await viewModel.markAllAsRead();

      final allRead = viewModel.notifications.every((n) => n.isRead);
      check(allRead).isTrue();
    });
  });
}
