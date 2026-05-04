// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_profile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserProfile _$UserProfileFromJson(Map<String, dynamic> json) => UserProfile(
  id: json['id'] as String,
  firstName: json['first_name'] as String,
  lastName: json['last_name'] as String,
  email: json['email'] as String,
  phone: json['phone'] as String,
  avatarUrl: json['avatar_url'] as String,
  loyaltyPoints: (json['loyalty_points'] as num).toInt(),
  subscriptionLevel: json['subscription_level'] as String,
  subscriptionExpiry: json['subscription_expiry'] as String,
  totalCheckIns: (json['total_check_ins'] as num).toInt(),
  birthDate: json['birth_date'] == null
      ? null
      : DateTime.parse(json['birth_date'] as String),
  isParentAccount: json['is_parent_account'] as bool? ?? false,
  children:
      (json['children'] as List<dynamic>?)
          ?.map((e) => ChildProfileModel.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
);

Map<String, dynamic> _$UserProfileToJson(UserProfile instance) =>
    <String, dynamic>{
      'id': instance.id,
      'first_name': instance.firstName,
      'last_name': instance.lastName,
      'email': instance.email,
      'avatar_url': instance.avatarUrl,
      'loyalty_points': instance.loyaltyPoints,
      'subscription_level': instance.subscriptionLevel,
      'subscription_expiry': instance.subscriptionExpiry,
      'phone': instance.phone,
      'total_check_ins': instance.totalCheckIns,
      'birth_date': instance.birthDate?.toIso8601String(),
      'is_parent_account': instance.isParentAccount,
      'children': instance.children,
    };
