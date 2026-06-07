import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:bourgo_arena_mobile/data/models/child_profile_model.dart';

part 'user_profile_model.freezed.dart';
part 'user_profile_model.g.dart';

@freezed
abstract class UserProfileModel with _$UserProfileModel {
  const factory UserProfileModel({
    @JsonKey(fromJson: _idFromJson) required String id,
    @JsonKey(name: 'first_name') String? firstName,
    @JsonKey(name: 'last_name') String? lastName,
    String? name,
    required String email,
    String? phone,
    @JsonKey(name: 'avatar_url') String? avatarUrl,
    @JsonKey(name: 'loyalty_points') @Default(0) int loyaltyPoints,
    @JsonKey(name: 'subscription_level') String? subscriptionLevel,
    @JsonKey(name: 'subscription_expiry') String? subscriptionExpiry,
    @JsonKey(name: 'birth_date') DateTime? birthDate,
    String? gender,
    String? status,
    String? state,
    @JsonKey(name: 'is_parent_account') @Default(false) bool isParentAccount,
    @Default([]) List<ChildProfileModel> children,
    Map<String, dynamic>? preferences,
  }) = _UserProfileModel;

  factory UserProfileModel.fromJson(Map<String, dynamic> json) =>
      _$UserProfileModelFromJson(json);
}

String _idFromJson(dynamic json) => json.toString();
