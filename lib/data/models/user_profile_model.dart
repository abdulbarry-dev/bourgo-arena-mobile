import 'package:bourgo_arena_mobile/domain/entities/user.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_profile_model.g.dart';

/// DTO for the user profile data.
@JsonSerializable(fieldRename: FieldRename.snake)
class UserProfileModel {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String avatarUrl;
  final int loyaltyPoints;
  final String subscriptionLevel;
  final String subscriptionExpiry;
  final int totalCheckIns;

  const UserProfileModel({
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

  /// Converts this model to a pure domain entity.
  User toEntity() {
    return User(
      id: id,
      name: name,
      email: email,
      phone: phone,
      avatarUrl: avatarUrl,
      loyaltyPoints: loyaltyPoints,
      subscriptionLevel: subscriptionLevel,
      subscriptionExpiry: subscriptionExpiry,
      totalCheckIns: totalCheckIns,
    );
  }

  /// Creates a model from a domain entity.
  factory UserProfileModel.fromEntity(User user) {
    return UserProfileModel(
      id: user.id,
      name: user.name,
      email: user.email,
      phone: user.phone,
      avatarUrl: user.avatarUrl,
      loyaltyPoints: user.loyaltyPoints,
      subscriptionLevel: user.subscriptionLevel,
      subscriptionExpiry: user.subscriptionExpiry,
      totalCheckIns: user.totalCheckIns,
    );
  }

  factory UserProfileModel.fromJson(Map<String, dynamic> json) =>
      _$UserProfileModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserProfileModelToJson(this);
}
