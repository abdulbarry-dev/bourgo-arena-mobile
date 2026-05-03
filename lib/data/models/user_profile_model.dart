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

  factory UserProfileModel.fromJson(Map<String, dynamic> json) =>
      _$UserProfileModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserProfileModelToJson(this);
}
