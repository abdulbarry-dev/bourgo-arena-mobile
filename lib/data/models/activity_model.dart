import 'package:json_annotation/json_annotation.dart';

part 'activity_model.g.dart';

/// DTO for activity data.
@JsonSerializable(fieldRename: FieldRename.snake)
class ActivityModel {
  final String id;
  final String title;
  final String category;
  final double basePrice;
  final String currency;
  final String imageUrl;
  final String icon;
  final String description;
  final List<String> features;
  final double rating;
  final int reviewCount;

  const ActivityModel({
    required this.id,
    required this.title,
    required this.category,
    required this.basePrice,
    required this.currency,
    required this.imageUrl,
    required this.icon,
    required this.description,
    required this.features,
    this.rating = 0.0,
    this.reviewCount = 0,
  });

  factory ActivityModel.fromJson(Map<String, dynamic> json) =>
      _$ActivityModelFromJson(json);

  Map<String, dynamic> toJson() => _$ActivityModelToJson(this);
}
