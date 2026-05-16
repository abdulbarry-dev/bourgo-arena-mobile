// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'verification_status_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VerificationStatusModel _$VerificationStatusModelFromJson(
  Map<String, dynamic> json,
) => VerificationStatusModel(
  emailVerified: json['email_verified'] as bool,
  phoneVerified: json['phone_verified'] as bool,
  onboardingCompleted: json['onboarding_completed'] as bool,
  isFullyVerified: json['is_fully_verified'] as bool,
  email: json['email'] as String?,
  phone: json['phone'] as String?,
  unverifiedMethod: json['unverified_method'] as String?,
);

Map<String, dynamic> _$VerificationStatusModelToJson(
  VerificationStatusModel instance,
) => <String, dynamic>{
  'email_verified': instance.emailVerified,
  'phone_verified': instance.phoneVerified,
  'onboarding_completed': instance.onboardingCompleted,
  'is_fully_verified': instance.isFullyVerified,
  'email': instance.email,
  'phone': instance.phone,
  'unverified_method': instance.unverifiedMethod,
};
