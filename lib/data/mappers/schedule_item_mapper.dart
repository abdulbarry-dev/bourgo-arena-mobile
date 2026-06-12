import 'package:bourgo_arena_mobile/data/models/schedule_item_model.dart';
import 'package:bourgo_arena_mobile/domain/entities/schedule_item.dart';

class ScheduleItemMapper {
  static ScheduleItem toEntity(ScheduleItemModel model) {
    return ScheduleItem(
      type: model.type == 'reservation'
          ? ScheduleItemType.reservation
          : ScheduleItemType.booking,
      typeLabel: model.typeLabel ?? '',
      id: model.id,
      date: model.date ?? '',
      name: model.name ?? '',
      startTime: model.startTime ?? '',
      endTime: model.endTime,
      durationMinutes: model.durationMinutes ?? 0,
      status: model.status ?? '',
      statusLabel: model.statusLabel ?? '',
      isCompleted: model.isCompleted ?? false,
    );
  }

  static ScheduleItemModel fromEntity(ScheduleItem entity) {
    return ScheduleItemModel(
      type: entity.type == ScheduleItemType.reservation
          ? 'reservation'
          : 'booking',
      typeLabel: entity.typeLabel,
      id: entity.id,
      date: entity.date,
      courseName: entity.type == ScheduleItemType.booking ? entity.name : null,
      activityTitle: entity.type == ScheduleItemType.reservation
          ? entity.name
          : null,
      startTime: entity.startTime,
      endTime: entity.endTime,
      durationMinutes: entity.durationMinutes,
      status: entity.status,
      statusLabel: entity.statusLabel,
      isCompleted: entity.isCompleted,
    );
  }
}
