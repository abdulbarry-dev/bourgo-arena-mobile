// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'plan_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PlanServiceModel _$PlanServiceModelFromJson(Map<String, dynamic> json) =>
    PlanServiceModel(
      id: PlanServiceModel._idToString(json['id']),
      name: json['name'] as String?,
      slug: json['slug'] as String?,
      description: json['description'] as String?,
      imageUrl: json['image_url'] as String?,
      images: (json['images'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      status: json['status'] as String?,
    );

Map<String, dynamic> _$PlanServiceModelToJson(PlanServiceModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'slug': instance.slug,
      'description': instance.description,
      'image_url': instance.imageUrl,
      'images': instance.images,
      'status': instance.status,
    };

PlanModel _$PlanModelFromJson(Map<String, dynamic> json) => PlanModel(
  id: PlanModel._idToString(json['id']),
  name: json['name'] as String,
  description: json['description'] as String?,
  price: (json['price'] as num).toDouble(),
  durationDays: (json['duration_days'] as num?)?.toInt(),
  billingCycle: json['billing_cycle'] as String?,
  hasAllCourses: json['has_all_courses'] as bool?,
  service: json['service'] == null
      ? null
      : PlanServiceModel.fromJson(json['service'] as Map<String, dynamic>),
);

Map<String, dynamic> _$PlanModelToJson(PlanModel instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'description': instance.description,
  'price': instance.price,
  'duration_days': instance.durationDays,
  'billing_cycle': instance.billingCycle,
  'has_all_courses': instance.hasAllCourses,
  'service': instance.service,
};
