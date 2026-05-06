/// Pure domain entity representing a sport activity.
class Activity {
  /// Unique identifier.
  final String id;

  /// Title of the activity.
  final String title;

  /// Category (Outdoor, Indoor, Wellness).
  final String category;

  /// Hourly price.
  final double price;

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
}
