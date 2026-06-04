import 'package:bourgo_arena_mobile/core/utils/result.dart';
import 'package:bourgo_arena_mobile/domain/core/failure.dart';
import 'package:bourgo_arena_mobile/domain/core/paginated_result.dart';
import 'package:bourgo_arena_mobile/domain/entities/notification.dart';
import 'package:bourgo_arena_mobile/domain/repositories/notification_repository.dart';

/// Use case for retrieving a paginated list of user notifications.
class GetNotificationsUseCase {
  final NotificationRepository _repository;

  const GetNotificationsUseCase(this._repository);

  /// Executes the get notifications operation.
  Future<Result<PaginatedResult<Notification>, Failure>> call({
    int page = 1,
  }) async {
    return _repository.getNotifications(page: page);
  }
}
