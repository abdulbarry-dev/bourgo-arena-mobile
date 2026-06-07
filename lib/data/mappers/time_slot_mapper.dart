import 'package:bourgo_arena_mobile/data/models/time_slot_model.dart';
import 'package:bourgo_arena_mobile/domain/entities/time_slot.dart' as entity;

/// Mapper to convert [TimeSlotModel] to [entity.TimeSlot] and vice-versa.
class TimeSlotMapper {
  /// Converts [TimeSlotModel] to [entity.TimeSlot].
  static entity.TimeSlot toEntity(TimeSlotModel model) {
    final isAvailable =
        model.available ?? model.isAvailable ?? !(model.isFullyBooked ?? false);
    final displayTime = model.time ?? model.startTime ?? '';

    return entity.TimeSlot(
      id: model.id,
      time: displayTime,
      available: isAvailable,
      startTime: model.startTime,
      endTime: model.endTime,
      capacity: model.capacity,
      bookedCount: model.bookedCount,
      isFullyBooked: model.isFullyBooked ?? false,
    );
  }

  /// Converts [entity.TimeSlot] to [TimeSlotModel].
  static TimeSlotModel fromEntity(entity.TimeSlot domainEntity) {
    return TimeSlotModel(
      id: domainEntity.id,
      time: domainEntity.time,
      available: domainEntity.available,
      startTime: domainEntity.startTime,
      endTime: domainEntity.endTime,
      capacity: domainEntity.capacity,
      bookedCount: domainEntity.bookedCount,
      isFullyBooked: domainEntity.isFullyBooked,
    );
  }
}

/// Extension for convenient mapping of [TimeSlotModel] list.
extension TimeSlotModelListX on List<TimeSlotModel> {
  /// Converts a list of [TimeSlotModel] to a list of [entity.TimeSlot].
  List<entity.TimeSlot> toEntityList() => map(TimeSlotMapper.toEntity).toList();
}
