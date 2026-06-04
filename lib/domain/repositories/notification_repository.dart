import 'package:bourgo_arena_mobile/core/utils/result.dart';
import 'package:bourgo_arena_mobile/domain/core/failure.dart';
import 'package:bourgo_arena_mobile/domain/core/paginated_result.dart';
import 'package:bourgo_arena_mobile/domain/entities/notification.dart';

/// Interface for notification-related data operations.
abstract interface class NotificationRepository {
  /// Retrieves a paginated list of user notifications.
  Future<Result<PaginatedResult<Notification>, Failure>> getNotifications({
    int page = 1,
  });

  /// Marks all unread notifications for the current user as read.
  Future<Result<void, Failure>> markAllAsRead();
}
