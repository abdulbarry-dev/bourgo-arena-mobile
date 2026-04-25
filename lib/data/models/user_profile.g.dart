// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_profile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserProfile _$UserProfileFromJson(Map<String, dynamic> json) => UserProfile(
  id: json['id'] as String,
  name: json['name'] as String,
  email: json['email'] as String,
  avatarUrl: json['avatar_url'] as String,
  loyaltyPoints: (json['loyalty_points'] as num).toInt(),
  subscriptionLevel: json['subscription_level'] as String,
  subscriptionExpiry: json['subscription_expiry'] as String,
  totalCheckIns: (json['total_check_ins'] as num).toInt(),
);

Map<String, dynamic> _$UserProfileToJson(UserProfile instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'email': instance.email,
      'avatar_url': instance.avatarUrl,
      'loyalty_points': instance.loyaltyPoints,
      'subscription_level': instance.subscriptionLevel,
      'subscription_expiry': instance.subscriptionExpiry,
      'total_check_ins': instance.totalCheckIns,
    };
