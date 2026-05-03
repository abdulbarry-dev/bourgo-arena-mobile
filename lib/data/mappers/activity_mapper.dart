import 'package:bourgo_arena_mobile/data/models/activity_model.dart';
import 'package:bourgo_arena_mobile/domain/entities/activity.dart';

/// Mapper to convert [ActivityModel] to [Activity] and vice-versa.
class ActivityMapper {
  /// Converts [ActivityModel] to [Activity].
  static Activity toEntity(ActivityModel model) {
    return Activity(
      id: model.id,
      title: model.title,
      category: model.category,
      price: model.price,
      currency: model.currency,
      imageUrl: model.imageUrl,
      icon: model.icon,
      description: model.description,
      features: model.features,
    );
  }

  /// Converts [Activity] to [ActivityModel].
  static ActivityModel fromEntity(Activity entity) {
    return ActivityModel(
      id: entity.id,
      title: entity.title,
      category: entity.category,
      price: entity.price,
      currency: entity.currency,
      imageUrl: entity.imageUrl,
      icon: entity.icon,
      description: entity.description,
      features: entity.features,
    );
  }
}

/// Extension for convenient mapping of [ActivityModel] list.
extension ActivityModelListX on List<ActivityModel> {
  /// Converts a list of [ActivityModel] to a list of [Activity].
  List<Activity> toEntityList() => map(ActivityMapper.toEntity).toList();
}
