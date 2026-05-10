import 'package:collection/collection.dart';

/// Pure domain entity representing a sport activity.
class Activity {
  /// Unique identifier.
  final String id;

  /// Title of the activity.
  final String title;

  /// Category (Outdoor, Indoor, Wellness).
  final String category;

  /// Hourly price.
  final double basePrice;

  /// Currency code.
  final String currency;

  /// URL to the activity image.
  final String imageUrl;

  /// Icon name.
  final String icon;

  /// Full description.
  final String description;

  /// List of key features or amenities.
  final List<String> features;

  /// Average rating
  final double rating;

  /// Number of reviews
  final int reviewCount;

  /// Creates a new [Activity] instance.
  const Activity({
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

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Activity &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          title == other.title &&
          category == other.category &&
          basePrice == other.basePrice &&
          currency == other.currency &&
          imageUrl == other.imageUrl &&
          icon == other.icon &&
          description == other.description &&
          _listEquality.equals(features, other.features) &&
          rating == other.rating &&
          reviewCount == other.reviewCount;

  @override
  int get hashCode =>
      id.hashCode ^
      title.hashCode ^
      category.hashCode ^
      basePrice.hashCode ^
      currency.hashCode ^
      imageUrl.hashCode ^
      icon.hashCode ^
      description.hashCode ^
      _listEquality.hash(features) ^
      rating.hashCode ^
      reviewCount.hashCode;

  static const _listEquality = ListEquality<String>();
}
