import 'package:bourgo_arena_mobile/data/models/activity_model.dart';
import 'package:bourgo_arena_mobile/domain/entities/activity.dart';

/// Mapper to convert [ActivityModel] to [Activity] and vice-versa.
class ActivityMapper {
  /// Converts [ActivityModel] to [Activity].
  static Activity toEntity(ActivityModel model) {
    return Activity(
      id: model.id,
      title: model.displayTitle,
      name: model.name ?? model.displayTitle,
      category: model.category ?? '',
      basePrice: model.basePrice ?? 0.0,
      currency: model.currency ?? 'TND',
      imageUrl: (model.images?.isNotEmpty == true)
          ? model.images!.first
          : (model.imageUrl ?? ''),
      images: model.images ?? (model.imageUrl != null ? [model.imageUrl!] : const []),
      icon: model.icon ?? 'sports',
      description: model.description ?? '',
      features: model.features ?? const [],
      capacity: model.capacity,
      rating: model.rating ?? 0.0,
      reviewCount: model.reviewCount ?? 0,
    );
  }

  /// Converts [Activity] to [ActivityModel].
  static ActivityModel fromEntity(Activity entity) {
    return ActivityModel(
      id: entity.id,
      title: entity.title,
      name: entity.name,
      category: entity.category,
      basePrice: entity.basePrice,
      currency: entity.currency,
      imageUrl: entity.imageUrl,
      icon: entity.icon,
      description: entity.description,
      features: entity.features,
      capacity: entity.capacity,
      rating: entity.rating,
      reviewCount: entity.reviewCount,
    );
  }
}

/// Extension for convenient mapping of [ActivityModel] list.
extension ActivityModelListX on List<ActivityModel> {
  /// Converts a list of [ActivityModel] to a list of [Activity].
  List<Activity> toEntityList() => map(ActivityMapper.toEntity).toList();
}
