import 'package:bourgo_arena_mobile/data/models/completed_item_model.dart';
import 'package:bourgo_arena_mobile/domain/entities/completed_item.dart';

class CompletedItemMapper {
  static CompletedItem toEntity(CompletedItemModel model) {
    return CompletedItem(
      type: model.type == 'activity'
          ? CompletedItemType.activity
          : CompletedItemType.course,
      typeLabel: model.typeLabel ?? '',
      id: model.id,
      date: model.date ?? '',
      name: model.name ?? '',
      completedAt: model.completedAt ?? '',
    );
  }

  static CompletedItemModel fromEntity(CompletedItem entity) {
    return CompletedItemModel(
      type: entity.type == CompletedItemType.activity ? 'activity' : 'course',
      typeLabel: entity.typeLabel,
      id: entity.id,
      date: entity.date,
      name: entity.name,
      completedAt: entity.completedAt,
    );
  }
}
