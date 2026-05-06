import 'package:bourgo_arena_mobile/domain/entities/child_profile.dart';

/// Pure domain entity representing a user.
class User {
  /// Unique identifier.
  final String id;

  /// First name.
  final String firstName;

  /// Last name.
  final String lastName;

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

  /// Birth date of the user.
  final DateTime? birthDate;

  /// Whether this is a parent account that can manage children.
  final bool isParentAccount;

  /// List of children profiles associated with this account.
  final List<ChildProfile> children;

  /// Creates a new [User] instance.
  const User({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.avatarUrl,
    required this.loyaltyPoints,
    required this.subscriptionLevel,
    required this.subscriptionExpiry,
    required this.totalCheckIns,
    this.birthDate,
    this.isParentAccount = false,
    this.children = const [],
  });

  /// Returns the full name of the user.
  String get name => '$firstName $lastName';
}
