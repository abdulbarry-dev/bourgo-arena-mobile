import 'package:bourgo_arena_mobile/core/utils/result.dart';
import 'package:bourgo_arena_mobile/domain/core/failure.dart';
import 'package:bourgo_arena_mobile/domain/repositories/notification_repository.dart';

/// Use case for marking all user notifications as read.
class MarkNotificationsReadUseCase {
  final NotificationRepository _repository;

  const MarkNotificationsReadUseCase(this._repository);

  /// Executes the mark notifications read operation.
  Future<Result<void, Failure>> call() async {
    return _repository.markAllAsRead();
  }
}
