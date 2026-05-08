import 'package:bourgo_arena_mobile/core/utils/result.dart';
import 'package:bourgo_arena_mobile/data/api/api_client.dart';
import 'package:bourgo_arena_mobile/data/mappers/activity_mapper.dart';
import 'package:bourgo_arena_mobile/data/mappers/time_slot_mapper.dart';
import 'package:bourgo_arena_mobile/data/models/activity_model.dart';
import 'package:bourgo_arena_mobile/data/models/time_slot_model.dart';
import 'package:bourgo_arena_mobile/domain/core/failure.dart';
import 'package:bourgo_arena_mobile/domain/entities/activity.dart';
import 'package:bourgo_arena_mobile/domain/entities/time_slot.dart';
import 'package:bourgo_arena_mobile/domain/repositories/activity_repository.dart';
import 'dart:developer' as developer;

/// Laravel API implementation of [ActivityRepository].
class ApiActivityRepository implements ActivityRepository {
  final ApiClient _apiClient;

  ApiActivityRepository(this._apiClient);

  @override
  Future<Result<List<Activity>, Failure>> getActivities() async {
    try {
      final response = await _apiClient.get('/activities') as List<dynamic>;
      final entities = response
          .map(
            (json) => ActivityMapper.toEntity(
              ActivityModel.fromJson(json as Map<String, dynamic>),
            ),
          )
          .toList();
      return Result.success(entities);
    } catch (e, stack) {
      developer.log('Error fetching activities', error: e, stackTrace: stack);
      return Result.failure(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Result<Activity, Failure>> getActivityById(String id) async {
    try {
      final response = await _apiClient.get('/activities/$id');
      return Result.success(
        ActivityMapper.toEntity(ActivityModel.fromJson(response)),
      );
    } catch (e, stack) {
      developer.log(
        'Error fetching activity by id: $id',
        error: e,
        stackTrace: stack,
      );
      return Result.failure(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Result<List<TimeSlot>, Failure>> getTimeSlots(String activityId) async {
    try {
      final response =
          await _apiClient.get('/activities/$activityId/slots') as List<dynamic>;
      final entities = response
          .map(
            (json) => TimeSlotMapper.toEntity(
              TimeSlotModel.fromJson(json as Map<String, dynamic>),
            ),
          )
          .toList();
      return Result.success(entities);
    } catch (e, stack) {
      developer.log(
        'Error fetching time slots for activity: $activityId',
        error: e,
        stackTrace: stack,
      );
      return Result.failure(ServerFailure(e.toString()));
    }
  }
}
