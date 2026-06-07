// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_profile_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UserProfileModel _$UserProfileModelFromJson(Map<String, dynamic> json) =>
    _UserProfileModel(
      id: _idFromJson(json['id']),
      firstName: json['first_name'] as String?,
      lastName: json['last_name'] as String?,
      name: json['name'] as String?,
      email: json['email'] as String,
      phone: json['phone'] as String?,
      avatarUrl: json['avatar_url'] as String?,
      loyaltyPoints: (json['loyalty_points'] as num?)?.toInt() ?? 0,
      subscriptionLevel: json['subscription_level'] as String?,
      subscriptionExpiry: json['subscription_expiry'] == null
          ? null
          : DateTime.parse(json['subscription_expiry'] as String),
      birthDate: json['birth_date'] == null
          ? null
          : DateTime.parse(json['birth_date'] as String),
      gender: json['gender'] as String?,
      status: json['status'] as String?,
      state: json['state'] as String?,
      isParentAccount: json['is_parent_account'] as bool? ?? false,
      children:
          (json['children'] as List<dynamic>?)
              ?.map(
                (e) => ChildProfileModel.fromJson(e as Map<String, dynamic>),
              )
              .toList() ??
          const [],
      preferences: json['preferences'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$UserProfileModelToJson(_UserProfileModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'first_name': instance.firstName,
      'last_name': instance.lastName,
      'name': instance.name,
      'email': instance.email,
      'phone': instance.phone,
      'avatar_url': instance.avatarUrl,
      'loyalty_points': instance.loyaltyPoints,
      'subscription_level': instance.subscriptionLevel,
      'subscription_expiry': instance.subscriptionExpiry?.toIso8601String(),
      'birth_date': instance.birthDate?.toIso8601String(),
      'gender': instance.gender,
      'status': instance.status,
      'state': instance.state,
      'is_parent_account': instance.isParentAccount,
      'children': instance.children,
      'preferences': instance.preferences,
    };
