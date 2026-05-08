import 'package:bourgo_arena_mobile/data/models/child_profile_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_profile_model.g.dart';

/// DTO for the user profile data.
@JsonSerializable(fieldRename: FieldRename.snake)
class UserProfileModel {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String? avatarUrl;
  final int loyaltyPoints;
  final String subscriptionLevel;
  final String? subscriptionExpiry;
  final int totalCheckIns;
  final DateTime? birthDate;
  final bool isParentAccount;
  final List<ChildProfileModel> children;

  const UserProfileModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    this.avatarUrl,
    required this.loyaltyPoints,
    required this.subscriptionLevel,
    this.subscriptionExpiry,
    required this.totalCheckIns,
    this.birthDate,
    this.isParentAccount = false,
    this.children = const [],
  });

  factory UserProfileModel.fromJson(Map<String, dynamic> json) =>
      _$UserProfileModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserProfileModelToJson(this);
}
