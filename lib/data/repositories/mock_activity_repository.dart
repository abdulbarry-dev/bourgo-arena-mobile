import 'package:bourgo_arena_mobile/data/mappers/activity_mapper.dart';
import 'package:bourgo_arena_mobile/data/mappers/time_slot_mapper.dart';
import 'package:bourgo_arena_mobile/data/services/data_service.dart';
import 'package:bourgo_arena_mobile/domain/entities/activity.dart';
import 'package:bourgo_arena_mobile/domain/entities/time_slot.dart';
import 'package:bourgo_arena_mobile/domain/repositories/activity_repository.dart';

/// Mock implementation of [ActivityRepository].
class MockActivityRepository implements ActivityRepository {
  final DataService _dataService;

  MockActivityRepository({DataService? dataService})
    : _dataService = dataService ?? DataService();

  @override
  Future<List<Activity>> getActivities() async {
    final models = await _dataService.getActivities();
    return models.toEntityList();
  }

  @override
  Future<Activity> getActivityById(String id) async {
    final activities = await getActivities();
    return activities.firstWhere((a) => a.id == id);
  }

  @override
  Future<List<TimeSlot>> getTimeSlots(String activityId) async {
    final models = await _dataService.getTimeSlots(activityId);
    return models.toEntityList();
  }
}
