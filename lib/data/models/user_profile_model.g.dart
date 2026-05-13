// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_profile_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserProfileModel _$UserProfileModelFromJson(Map<String, dynamic> json) =>
    UserProfileModel(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String,
      avatarUrl: json['avatar_url'] as String?,
      loyaltyPoints: (json['loyalty_points'] as num).toInt(),
      subscriptionLevel: json['subscription_level'] as String,
      subscriptionExpiry: json['subscription_expiry'] as String?,
      totalCheckIns: (json['total_check_ins'] as num).toInt(),
      birthDate: json['birth_date'] == null
          ? null
          : DateTime.parse(json['birth_date'] as String),
      gender: json['gender'] as String?,
      isParentAccount: json['is_parent_account'] as bool? ?? false,
      children:
          (json['children'] as List<dynamic>?)
              ?.map(
                (e) => ChildProfileModel.fromJson(e as Map<String, dynamic>),
              )
              .toList() ??
          const [],
    );

Map<String, dynamic> _$UserProfileModelToJson(UserProfileModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'email': instance.email,
      'phone': instance.phone,
      'avatar_url': instance.avatarUrl,
      'loyalty_points': instance.loyaltyPoints,
      'subscription_level': instance.subscriptionLevel,
      'subscription_expiry': instance.subscriptionExpiry,
      'total_check_ins': instance.totalCheckIns,
      'birth_date': instance.birthDate?.toIso8601String(),
      'gender': instance.gender,
      'is_parent_account': instance.isParentAccount,
      'children': instance.children,
    };
