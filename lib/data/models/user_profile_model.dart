import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:bourgo_arena_mobile/data/models/child_profile_model.dart';

part 'user_profile_model.freezed.dart';
part 'user_profile_model.g.dart';

/// DTO for the user profile data.
@freezed
@JsonSerializable(fieldRename: FieldRename.snake)
abstract class UserProfileModel with _$UserProfileModel {
  const factory UserProfileModel({
    @JsonKey(fromJson: _idFromJson) required String id,
    String? firstName,
    String? lastName,
    String? name,
    required String email,
    String? phone,
    String? avatarUrl,
    @Default(0) int loyaltyPoints,
    String? subscriptionLevel,
    String? subscriptionExpiry,
    DateTime? birthDate,
    String? gender,
    String? status,
    String? state,
    @Default(false) bool isParentAccount,
    @Default([]) List<ChildProfileModel> children,
    Map<String, dynamic>? preferences,
  }) = _UserProfileModel;

  factory UserProfileModel.fromJson(Map<String, dynamic> json) =>
      _$UserProfileModelFromJson(json);
}

String _idFromJson(dynamic json) => json.toString();
