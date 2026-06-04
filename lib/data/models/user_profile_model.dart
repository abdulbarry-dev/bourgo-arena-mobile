import 'package:bourgo_arena_mobile/data/models/child_profile_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_profile_model.g.dart';

/// DTO for the user profile data.
@JsonSerializable(fieldRename: FieldRename.snake)
class UserProfileModel {
  @JsonKey(fromJson: _idFromJson)
  final String id;
  final String? firstName;
  final String? lastName;
  final String? name;
  final String email;
  final String? phone;
  final String? avatarUrl;
  final int loyaltyPoints;
  final String? subscriptionLevel;
  final String? subscriptionExpiry;
  final DateTime? birthDate;
  final String? gender;
  final String? status;
  final String? state;
  final bool isParentAccount;
  final List<ChildProfileModel> children;

  static String _idFromJson(dynamic json) => json.toString();

  const UserProfileModel({
    required this.id,
    this.firstName,
    this.lastName,
    this.name,
    required this.email,
    this.phone,
    this.avatarUrl,
    this.loyaltyPoints = 0,
    this.subscriptionLevel,
    this.subscriptionExpiry,
    this.birthDate,
    this.gender,
    this.status,
    this.state,
    this.isParentAccount = false,
    this.children = const [],
  });

  factory UserProfileModel.fromJson(Map<String, dynamic> json) =>
      _$UserProfileModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserProfileModelToJson(this);
}
