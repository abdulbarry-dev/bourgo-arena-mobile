import 'package:bourgo_arena_mobile/core/utils/result.dart';
import 'package:bourgo_arena_mobile/domain/core/failure.dart';
import 'package:bourgo_arena_mobile/domain/entities/time_slot.dart';
import 'package:bourgo_arena_mobile/domain/repositories/activity_repository.dart';

/// Use case for retrieving available time slots for an activity.
class GetTimeSlotsUseCase {
  final ActivityRepository _repository;

  const GetTimeSlotsUseCase(this._repository);

  /// Executes the operation to fetch time slots for the given [activityId].
  Future<Result<List<TimeSlot>, Failure>> call(String activityId) async {
    return _repository.getTimeSlots(activityId);
  }
}
