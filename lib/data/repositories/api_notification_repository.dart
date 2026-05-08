import 'package:bourgo_arena_mobile/core/utils/result.dart';
import 'package:bourgo_arena_mobile/data/api/api_client.dart';
import 'package:bourgo_arena_mobile/data/mappers/notification_mapper.dart';
import 'package:bourgo_arena_mobile/data/models/notification_model.dart';
import 'package:bourgo_arena_mobile/domain/core/failure.dart';
import 'package:bourgo_arena_mobile/domain/entities/notification.dart';
import 'package:bourgo_arena_mobile/domain/repositories/notification_repository.dart';
import 'dart:developer' as developer;

/// Laravel API implementation of [NotificationRepository].
class ApiNotificationRepository implements NotificationRepository {
  final ApiClient _apiClient;

  ApiNotificationRepository(this._apiClient);

  @override
  Future<Result<List<Notification>, Failure>> getNotifications() async {
    try {
      final response = await _apiClient.get('/notifications') as List<dynamic>;
      final entities = response
          .map(
            (json) => NotificationMapper.toEntity(
              NotificationModel.fromJson(json as Map<String, dynamic>),
            ),
          )
          .toList();
      return Result.success(entities);
    } catch (e, stack) {
      developer.log('Error fetching notifications', error: e, stackTrace: stack);
      return Result.failure(ServerFailure(e.toString()));
    }
  }
}
