import 'package:bourgo_arena_mobile/data/models/child_profile_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_profile.g.dart';

/// Model representing the user's profile and membership status.
@JsonSerializable(fieldRename: FieldRename.snake)
class UserProfile {
  /// User's unique ID.
  final String id;

  /// First name.
  final String firstName;

  /// Last name.
  final String lastName;

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

  /// Birth date.
  final DateTime? birthDate;

  /// Whether this is a parent account.
  final bool isParentAccount;

  /// List of children models.
  final List<ChildProfileModel> children;

  /// Creates a new [UserProfile] instance.
  const UserProfile({
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

  /// Creates a copy of this [UserProfile] but with the given fields replaced.
  UserProfile copyWith({
    String? firstName,
    String? lastName,
    String? email,
    String? phone,
    String? avatarUrl,
    int? loyaltyPoints,
    String? subscriptionLevel,
    String? subscriptionExpiry,
    int? totalCheckIns,
    DateTime? birthDate,
    bool? isParentAccount,
    List<ChildProfileModel>? children,
  }) {
    return UserProfile(
      id: id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      loyaltyPoints: loyaltyPoints ?? this.loyaltyPoints,
      subscriptionLevel: subscriptionLevel ?? this.subscriptionLevel,
      subscriptionExpiry: subscriptionExpiry ?? this.subscriptionExpiry,
      totalCheckIns: totalCheckIns ?? this.totalCheckIns,
      birthDate: birthDate ?? this.birthDate,
      isParentAccount: isParentAccount ?? this.isParentAccount,
      children: children ?? this.children,
    );
  }

  factory UserProfile.fromJson(Map<String, dynamic> json) =>
      _$UserProfileFromJson(json);
  Map<String, dynamic> toJson() => _$UserProfileToJson(this);
}
