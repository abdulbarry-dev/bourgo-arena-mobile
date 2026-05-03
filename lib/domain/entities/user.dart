/// Pure domain entity representing a user.
class User {
  /// Unique identifier.
  final String id;

  /// Full name.
  final String name;

  /// Email address.
  final String email;

  /// Phone number.
  final String phone;

  /// URL to avatar image.
  final String avatarUrl;

  /// Loyalty points balance.
  final int loyaltyPoints;

  /// Current subscription level.
  final String subscriptionLevel;

  /// Date when the subscription expires.
  final String subscriptionExpiry;

  /// Total number of check-ins.
  final int totalCheckIns;

  /// Creates a new [User] instance.
  const User({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.avatarUrl,
    required this.loyaltyPoints,
    required this.subscriptionLevel,
    required this.subscriptionExpiry,
    required this.totalCheckIns,
  });
}
