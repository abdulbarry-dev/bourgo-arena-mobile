import 'package:bourgo_arena_mobile/core/utils/result.dart';
import 'package:bourgo_arena_mobile/data/api/api_client.dart';
import 'package:bourgo_arena_mobile/data/api/api_error_handler.dart';
import 'package:bourgo_arena_mobile/data/mappers/notification_mapper.dart';
import 'package:bourgo_arena_mobile/data/models/notification_model.dart';
import 'package:bourgo_arena_mobile/domain/core/failure.dart';
import 'package:bourgo_arena_mobile/domain/core/paginated_result.dart';
import 'package:bourgo_arena_mobile/domain/entities/notification.dart';
import 'package:bourgo_arena_mobile/domain/repositories/notification_repository.dart';

/// Laravel API implementation of [NotificationRepository].
class ApiNotificationRepository implements NotificationRepository {
  final ApiClient _apiClient;

  ApiNotificationRepository(this._apiClient);

  @override
  Future<Result<PaginatedResult<Notification>, Failure>> getNotifications({
    int page = 1,
  }) {
    if (!_apiClient.hasToken) {
      return Future.value(
        const Success(
          PaginatedResult(
            data: [],
            currentPage: 1,
            lastPage: 1,
            total: 0,
            hasMore: false,
          ),
        ),
      );
    }
    return executeApiCall(() async {
      final response =
          await _apiClient.get(
                '/notifications?page=$page',
                fullResponse: true,
                skipAuthError: true,
              )
              as Map<String, dynamic>;

      final List<dynamic> data = response['data'] as List<dynamic>;
      final metaJson = response['meta'] as Map<String, dynamic>;
      final currentPage = (metaJson['current_page'] as num?)?.toInt() ?? 1;
      final lastPage = (metaJson['last_page'] as num?)?.toInt() ?? 1;
      final total = (metaJson['total'] as num?)?.toInt() ?? 0;

      final entities = data
          .map(
            (json) => NotificationMapper.toEntity(
              NotificationModel.fromJson(json as Map<String, dynamic>),
            ),
          )
          .toList();

      return Result.success(
        PaginatedResult(
          data: entities,
          currentPage: currentPage,
          lastPage: lastPage,
          total: total,
          hasMore: currentPage < lastPage,
        ),
      );
    });
  }

  @override
  Future<Result<void, Failure>> markAllAsRead() {
    return executeApiCall(() async {
      await _apiClient.post(
        '/notifications/mark-all-read',
        null,
        skipAuthError: true,
      );
      return const Success(null);
    });
  }
}
