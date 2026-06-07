import 'package:bourgo_arena_mobile/core/utils/result.dart';
import 'package:bourgo_arena_mobile/data/api/api_client.dart';
import 'package:bourgo_arena_mobile/data/api/api_error_handler.dart';
import 'package:bourgo_arena_mobile/data/mappers/activity_mapper.dart';
import 'package:bourgo_arena_mobile/data/mappers/time_slot_mapper.dart';
import 'package:bourgo_arena_mobile/data/models/activity_model.dart';
import 'package:bourgo_arena_mobile/data/models/time_slot_model.dart';
import 'package:bourgo_arena_mobile/domain/core/failure.dart';
import 'package:bourgo_arena_mobile/domain/entities/activity.dart';
import 'package:bourgo_arena_mobile/domain/entities/time_slot.dart';
import 'package:bourgo_arena_mobile/domain/repositories/activity_repository.dart';

/// Laravel API implementation of [ActivityRepository].
class ApiActivityRepository implements ActivityRepository {
  final ApiClient _apiClient;

  ApiActivityRepository(this._apiClient);

  @override
  Future<Result<List<Activity>, Failure>> getActivities() {
    return executeApiCall(() async {
      final response =
          await _apiClient.get('/activities', fullResponse: true)
              as Map<String, dynamic>;
      final data = response['data'] as List<dynamic>? ?? [];
      final entities = data
          .map(
            (json) => ActivityMapper.toEntity(
              ActivityModel.fromJson(json as Map<String, dynamic>),
            ),
          )
          .toList();
      return Result.success(entities);
    });
  }

  @override
  Future<Result<Activity, Failure>> getActivityById(String id) {
    return executeApiCall(() async {
      final response =
          await _apiClient.get('/activities/$id', fullResponse: true)
              as Map<String, dynamic>;
      final data = response['data'] as Map<String, dynamic>;
      return Result.success(
        ActivityMapper.toEntity(ActivityModel.fromJson(data)),
      );
    });
  }

  @override
  Future<Result<List<TimeSlot>, Failure>> getTimeSlots(String activityId) {
    return executeApiCall(() async {
      final response =
          await _apiClient.get(
                '/activities/$activityId/slots',
                fullResponse: true,
              )
              as Map<String, dynamic>;
      final data = response['data'] as List<dynamic>? ?? [];
      final entities = data
          .map(
            (json) => TimeSlotMapper.toEntity(
              TimeSlotModel.fromJson(json as Map<String, dynamic>),
            ),
          )
          .toList();
      return Result.success(entities);
    });
  }
}
