import 'package:json_annotation/json_annotation.dart';

part 'activity_model.g.dart';

/// DTO for activity data matching ActivityResource.
@JsonSerializable(fieldRename: FieldRename.snake)
class ActivityModel {
  final String id;

  /// Primary display title.
  final String? title;

  /// API alias for title — use [displayTitle] to resolve.
  final String? name;

  final String? category;
  final double? basePrice;
  final String? currency;
  final String? imageUrl;
  final String? icon;
  final String? description;
  final List<String>? features;
  final int? capacity;
  @JsonKey(defaultValue: 0.0)
  final double? rating;
  @JsonKey(defaultValue: 0)
  final int? reviewCount;
  final List<String>? images;

  const ActivityModel({
    required this.id,
    this.title,
    this.name,
    this.category,
    this.basePrice,
    this.currency,
    this.imageUrl,
    this.icon,
    this.description,
    this.features,
    this.capacity,
    this.rating,
    this.reviewCount,
    this.images,
  });

  /// Resolves display title from either `title` or `name`.
  String get displayTitle => title ?? name ?? '';

  factory ActivityModel.fromJson(Map<String, dynamic> json) =>
      _$ActivityModelFromJson(json);

  Map<String, dynamic> toJson() => _$ActivityModelToJson(this);
}
