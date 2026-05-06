import 'package:bourgo_arena_mobile/domain/entities/activity.dart';
import 'package:bourgo_arena_mobile/domain/entities/time_slot.dart';

/// Interface for sport activity data operations.
abstract interface class ActivityRepository {
  /// Retrieves a list of all available activities.
  Future<List<Activity>> getActivities();

  /// Retrieves a specific activity by its [id].
  Future<Activity> getActivityById(String id);

  /// Retrieves available time slots for a given activity.
  Future<List<TimeSlot>> getTimeSlots(String activityId);
}
