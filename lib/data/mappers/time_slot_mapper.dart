import 'package:bourgo_arena_mobile/data/models/time_slot.dart';
import 'package:bourgo_arena_mobile/domain/entities/time_slot.dart' as entity;

/// Mapper to convert [TimeSlot] model to [entity.TimeSlot] entity.
class TimeSlotMapper {
  /// Converts [TimeSlot] model to [entity.TimeSlot] entity.
  static entity.TimeSlot toEntity(TimeSlot model) {
    return entity.TimeSlot(time: model.time, available: model.available);
  }

  /// Converts [entity.TimeSlot] entity to [TimeSlot] model.
  static TimeSlot fromEntity(entity.TimeSlot domainEntity) {
    return TimeSlot(time: domainEntity.time, available: domainEntity.available);
  }
}

/// Extension for convenient mapping of [TimeSlot] list.
extension TimeSlotModelListX on List<TimeSlot> {
  /// Converts a list of [TimeSlot] models to a list of [entity.TimeSlot] entities.
  List<entity.TimeSlot> toEntityList() => map(TimeSlotMapper.toEntity).toList();
}
