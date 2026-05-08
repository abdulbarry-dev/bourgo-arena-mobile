import 'package:bourgo_arena_mobile/core/utils/result.dart';
import 'package:bourgo_arena_mobile/domain/core/failure.dart';
import 'package:bourgo_arena_mobile/domain/entities/notification.dart';
import 'package:bourgo_arena_mobile/domain/repositories/notification_repository.dart';

/// Use case for retrieving user notifications.
class GetNotificationsUseCase {
  final NotificationRepository _repository;

  const GetNotificationsUseCase(this._repository);

  /// Executes the operation to fetch notifications.
  Future<Result<List<Notification>, Failure>> call() async {
    return _repository.getNotifications();
  }
}
