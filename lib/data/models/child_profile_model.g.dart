// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'child_profile_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChildProfileModel _$ChildProfileModelFromJson(Map<String, dynamic> json) =>
    ChildProfileModel(
      id: ChildProfileModel._idFromJson(json['id']),
      firstName: json['first_name'] as String,
      lastName: json['last_name'] as String,
      birthDate: DateTime.parse(json['birth_date'] as String),
      gender: json['gender'] as String?,
      avatarUrl: json['avatar_url'] as String?,
      status: json['status'] as String?,
      isArchived: json['is_archived'] as bool?,
      hasActiveSubscription: json['has_active_subscription'] as bool?,
      activeSubscription: ChildProfileModel._activeSubFromJson(
        json['active_subscription'] as Map<String, dynamic>?,
      ),
      createdAt: json['created_at'] as String?,
    );

Map<String, dynamic> _$ChildProfileModelToJson(ChildProfileModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'first_name': instance.firstName,
      'last_name': instance.lastName,
      'birth_date': instance.birthDate.toIso8601String(),
      'gender': instance.gender,
      'avatar_url': instance.avatarUrl,
      'status': instance.status,
      'is_archived': instance.isArchived,
      'has_active_subscription': instance.hasActiveSubscription,
      'active_subscription': instance.activeSubscription,
      'created_at': instance.createdAt,
    };
