import 'package:bourgo_arena_mobile/data/models/schedule_item_model.dart';
import 'package:bourgo_arena_mobile/domain/entities/schedule_item.dart';

class ScheduleItemMapper {
  static ScheduleItem toEntity(ScheduleItemModel model) {
    return ScheduleItem(
      type: model.type == 'activity'
          ? ScheduleItemType.activity
          : ScheduleItemType.course,
      typeLabel: model.typeLabel ?? '',
      id: model.id,
      date: model.date ?? '',
      name: model.name ?? '',
      startTime: model.startTime ?? '',
      durationMinutes: model.durationMinutes ?? 0,
      status: model.status ?? '',
      statusLabel: model.statusLabel ?? '',
      isCompleted: model.isCompleted ?? false,
    );
  }

  static ScheduleItemModel fromEntity(ScheduleItem entity) {
    return ScheduleItemModel(
      type: entity.type == ScheduleItemType.activity ? 'activity' : 'course',
      typeLabel: entity.typeLabel,
      id: entity.id,
      date: entity.date,
      name: entity.name,
      startTime: entity.startTime,
      durationMinutes: entity.durationMinutes,
      status: entity.status,
      statusLabel: entity.statusLabel,
      isCompleted: entity.isCompleted,
    );
  }
}
