import 'package:bourgo_arena_mobile/core/utils/result.dart';
import 'package:bourgo_arena_mobile/domain/core/failure.dart';
import 'package:bourgo_arena_mobile/domain/entities/activity.dart';
import 'package:bourgo_arena_mobile/domain/entities/time_slot.dart';

/// Interface for sport activity data operations.
abstract interface class ActivityRepository {
  /// Retrieves a list of all available activities.
  Future<Result<List<Activity>, Failure>> getActivities();

  /// Retrieves a specific activity by its [id].
  Future<Result<Activity, Failure>> getActivityById(String id);

  /// Retrieves available time slots for a given activity.
  Future<Result<List<TimeSlot>, Failure>> getTimeSlots(String activityId);
}
