// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'family_member_profile_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FamilyMemberProfileModel _$FamilyMemberProfileModelFromJson(
  Map<String, dynamic> json,
) => FamilyMemberProfileModel(
  id: const _StringIdConverter().fromJson(json['id']),
  name: json['name'] as String,
  relation: json['relation'] as String,
  birthDate: const _NullableDateTimeConverter().fromJson(json['birth_date']),
  initials: json['initials'] as String?,
  avatarUrl: json['avatar_url'] as String?,
  createdAt: DateTime.parse(json['created_at'] as String),
);

Map<String, dynamic> _$FamilyMemberProfileModelToJson(
  FamilyMemberProfileModel instance,
) => <String, dynamic>{
  'id': const _StringIdConverter().toJson(instance.id),
  'name': instance.name,
  'relation': instance.relation,
  'birth_date': const _NullableDateTimeConverter().toJson(instance.birthDate),
  'initials': instance.initials,
  'avatar_url': instance.avatarUrl,
  'created_at': instance.createdAt.toIso8601String(),
};
