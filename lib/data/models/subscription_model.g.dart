// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'subscription_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SubscriptionModel _$SubscriptionModelFromJson(Map<String, dynamic> json) =>
    SubscriptionModel(
      id: SubscriptionModel._idToString(json['id']),
      planName: json['plan_name'] as String?,
      planDescription: json['plan_description'] as String?,
      status: json['status'] as String?,
      startsAt: json['starts_at'] as String?,
      endsAt: json['ends_at'] as String?,
      daysRemaining: (json['days_remaining'] as num?)?.toInt(),
      paymentMethod: json['payment_method'] as String?,
      amountPaid: (json['amount_paid'] as num?)?.toDouble(),
      name: json['name'] as String?,
      price: (json['price'] as num?)?.toDouble(),
      durationMonths: (json['duration_months'] as num?)?.toInt(),
    );

Map<String, dynamic> _$SubscriptionModelToJson(SubscriptionModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'plan_name': instance.planName,
      'plan_description': instance.planDescription,
      'status': instance.status,
      'starts_at': instance.startsAt,
      'ends_at': instance.endsAt,
      'days_remaining': instance.daysRemaining,
      'payment_method': instance.paymentMethod,
      'amount_paid': instance.amountPaid,
      'name': instance.name,
      'price': instance.price,
      'duration_months': instance.durationMonths,
    };
