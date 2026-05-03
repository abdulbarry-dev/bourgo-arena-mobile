import 'package:json_annotation/json_annotation.dart';

part 'user_profile.g.dart';

/// Model representing the user's profile and membership status.
@JsonSerializable(fieldRename: FieldRename.snake)
class UserProfile {
  /// User's unique ID.
  final String id;

  /// Full name.
  final String name;

  /// Email address.
  final String email;

  /// URL to avatar image.
  final String avatarUrl;

  /// Loyalty points balance.
  final int loyaltyPoints;

  /// Current subscription level (e.g. Premium, Basic).
  final String subscriptionLevel;

  /// Date when the subscription expires.
  final String subscriptionExpiry;

  /// Phone number.
  final String phone;

  /// Total number of check-ins.
  final int totalCheckIns;

  /// Creates a new [UserProfile] instance.
  const UserProfile({
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

  /// Creates a copy of this [UserProfile] but with the given fields replaced.
  UserProfile copyWith({
    String? name,
    String? email,
    String? phone,
    String? avatarUrl,
    int? loyaltyPoints,
    String? subscriptionLevel,
    String? subscriptionExpiry,
    int? totalCheckIns,
  }) {
    return UserProfile(
      id: id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      loyaltyPoints: loyaltyPoints ?? this.loyaltyPoints,
      subscriptionLevel: subscriptionLevel ?? this.subscriptionLevel,
      subscriptionExpiry: subscriptionExpiry ?? this.subscriptionExpiry,
      totalCheckIns: totalCheckIns ?? this.totalCheckIns,
    );
  }

  factory UserProfile.fromJson(Map<String, dynamic> json) =>
      _$UserProfileFromJson(json);
  Map<String, dynamic> toJson() => _$UserProfileToJson(this);
}
