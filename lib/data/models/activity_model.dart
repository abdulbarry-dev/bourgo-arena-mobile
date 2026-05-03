import 'package:bourgo_arena_mobile/domain/entities/activity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'activity_model.g.dart';

/// DTO for activity data.
@JsonSerializable(fieldRename: FieldRename.snake)
class ActivityModel {
  final String id;
  final String title;
  final String category;
  final double price;
  final String currency;
  final String imageUrl;
  final String icon;
  final String description;
  final List<String> features;

  const ActivityModel({
    required this.id,
    required this.title,
    required this.category,
    required this.price,
    required this.currency,
    required this.imageUrl,
    required this.icon,
    required this.description,
    required this.features,
  });

  /// Converts this model to a pure domain entity.
  Activity toEntity() {
    return Activity(
      id: id,
      title: title,
      category: category,
      price: price,
      currency: currency,
      imageUrl: imageUrl,
      icon: icon,
      description: description,
      features: features,
    );
  }

  /// Creates a model from a domain entity.
  factory ActivityModel.fromEntity(Activity entity) {
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

  factory ActivityModel.fromJson(Map<String, dynamic> json) =>
      _$ActivityModelFromJson(json);

  Map<String, dynamic> toJson() => _$ActivityModelToJson(this);
}
