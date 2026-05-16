// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'subscription_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BenefitModel _$BenefitModelFromJson(Map<String, dynamic> json) =>
    BenefitModel(label: json['label'] as String, icon: json['icon'] as String?);

Map<String, dynamic> _$BenefitModelToJson(BenefitModel instance) =>
    <String, dynamic>{'label': instance.label, 'icon': instance.icon};

SubscriptionModel _$SubscriptionModelFromJson(Map<String, dynamic> json) =>
    SubscriptionModel(
      id: json['id'] as String,
      name: json['name'] as String,
      price: (json['price'] as num).toDouble(),
      benefits: (json['benefits'] as List<dynamic>)
          .map((e) => BenefitModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      durationMonths: (json['duration_months'] as num).toInt(),
    );

Map<String, dynamic> _$SubscriptionModelToJson(SubscriptionModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'price': instance.price,
      'benefits': instance.benefits,
      'duration_months': instance.durationMonths,
    };
