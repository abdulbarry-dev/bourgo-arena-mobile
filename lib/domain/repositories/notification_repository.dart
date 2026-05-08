import 'package:bourgo_arena_mobile/core/utils/result.dart';
import 'package:bourgo_arena_mobile/domain/core/failure.dart';
import 'package:bourgo_arena_mobile/domain/entities/notification.dart';

/// Interface for notification-related data operations.
abstract interface class NotificationRepository {
  /// Retrieves a list of all user notifications.
  Future<Result<List<Notification>, Failure>> getNotifications();
}
