import 'package:bourgo_arena_mobile/data/models/completed_item_model.dart';
import 'package:bourgo_arena_mobile/domain/entities/completed_item.dart';

class CompletedItemMapper {
  static CompletedItem toEntity(CompletedItemModel model) {
    return CompletedItem(
      type: model.type == 'reservation'
          ? CompletedItemType.reservation
          : CompletedItemType.booking,
      typeLabel: model.typeLabel ?? '',
      id: model.id,
      date: model.date ?? '',
      name: model.name ?? '',
      status: model.status,
      completedAt: model.completedAt ?? '',
    );
  }

  static CompletedItemModel fromEntity(CompletedItem entity) {
    return CompletedItemModel(
      type: entity.type == CompletedItemType.reservation ? 'reservation' : 'booking',
      typeLabel: entity.typeLabel,
      id: entity.id,
      date: entity.date,
      courseName: entity.type == CompletedItemType.booking ? entity.name : null,
      activityTitle: entity.type == CompletedItemType.reservation ? entity.name : null,
      status: entity.status,
      completedAt: entity.completedAt,
    );
  }
}
