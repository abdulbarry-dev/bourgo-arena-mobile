// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'plan_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PlanModel _$PlanModelFromJson(Map<String, dynamic> json) => PlanModel(
  id: json['id'] as String,
  name: json['name'] as String,
  description: json['description'] as String,
  price: (json['price'] as num).toDouble(),
  billingCycle: json['billing_cycle'] as String,
  service: json['service'] as Map<String, dynamic>?,
);

Map<String, dynamic> _$PlanModelToJson(PlanModel instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'description': instance.description,
  'price': instance.price,
  'billing_cycle': instance.billingCycle,
  'service': instance.service,
};
