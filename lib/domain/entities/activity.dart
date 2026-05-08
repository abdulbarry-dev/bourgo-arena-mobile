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
}
