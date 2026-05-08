import 'package:bourgo_arena_mobile/data/models/time_slot_model.dart';
import 'package:bourgo_arena_mobile/domain/entities/time_slot.dart' as entity;

/// Mapper to convert [TimeSlotModel] model to [entity.TimeSlot] entity.
class TimeSlotMapper {
  /// Converts [TimeSlotModel] model to [entity.TimeSlot] entity.
  static entity.TimeSlot toEntity(TimeSlotModel model) {
    return entity.TimeSlot(time: model.time, available: model.available);
  }

  /// Converts [entity.TimeSlot] entity to [TimeSlotModel] model.
  static TimeSlotModel fromEntity(entity.TimeSlot domainEntity) {
    return TimeSlotModel(
      time: domainEntity.time,
      available: domainEntity.available,
    );
  }
}

/// Extension for convenient mapping of [TimeSlotModel] list.
extension TimeSlotModelListX on List<TimeSlotModel> {
  /// Converts a list of [TimeSlotModel] models to a list of [entity.TimeSlot] entities.
  List<entity.TimeSlot> toEntityList() => map(TimeSlotMapper.toEntity).toList();
}
