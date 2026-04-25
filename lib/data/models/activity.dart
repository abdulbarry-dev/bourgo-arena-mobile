import 'package:json_annotation/json_annotation.dart';

part 'activity.g.dart';

/// Model representing a sport activity in Bourgo Arena.
@JsonSerializable(fieldRename: FieldRename.snake)
class Activity {
  /// Unique identifier for the activity.
  final String id;

  /// Title of the activity (e.g. Football 5x5).
  final String title;

  /// Category (Outdoor, Indoor, Wellness).
  final String category;

  /// Hourly price.
  final double price;

  /// Currency code (e.g. TND).
  final String currency;

  /// URL to the activity image.
  final String imageUrl;

  /// Material symbol icon name.
  final String icon;

  /// Full description of the activity.
  final String description;

  /// List of key features or amenities.
  final List<String> features;

  /// Creates a new [Activity] instance.
  const Activity({
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

  /// Creates an [Activity] from JSON.
  factory Activity.fromJson(Map<String, dynamic> json) =>
      _$ActivityFromJson(json);

  /// Converts an [Activity] to JSON.
  Map<String, dynamic> toJson() => _$ActivityToJson(this);
}
