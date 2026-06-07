// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'subscription_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SubscriptionModel _$SubscriptionModelFromJson(Map<String, dynamic> json) =>
    SubscriptionModel(
      id: SubscriptionModel._idToString(json['id']),
      plan: json['plan'] == null
          ? null
          : PlanModel.fromJson(json['plan'] as Map<String, dynamic>),
      service: json['service'] == null
          ? null
          : PlanServiceModel.fromJson(json['service'] as Map<String, dynamic>),
      status: json['status'] as String?,
      startsAt: json['starts_at'] as String?,
      endsAt: json['ends_at'] as String?,
      daysRemaining: (json['days_remaining'] as num?)?.toInt(),
      paymentMethod: json['payment_method'] as String?,
      amountPaid: (json['amount_paid'] as num?)?.toDouble(),
      isActive: json['is_active'] as bool?,
      receiptUrl: json['receipt_url'] as String?,
    );

Map<String, dynamic> _$SubscriptionModelToJson(SubscriptionModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'plan': instance.plan?.toJson(),
      'service': instance.service?.toJson(),
      'status': instance.status,
      'starts_at': instance.startsAt,
      'ends_at': instance.endsAt,
      'days_remaining': instance.daysRemaining,
      'payment_method': instance.paymentMethod,
      'amount_paid': instance.amountPaid,
      'is_active': instance.isActive,
      'receipt_url': instance.receiptUrl,
    };
