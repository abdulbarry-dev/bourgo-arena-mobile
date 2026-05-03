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

  factory ActivityModel.fromJson(Map<String, dynamic> json) =>
      _$ActivityModelFromJson(json);

  Map<String, dynamic> toJson() => _$ActivityModelToJson(this);
}
