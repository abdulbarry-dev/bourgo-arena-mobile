// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PaymentModel _$PaymentModelFromJson(Map<String, dynamic> json) => PaymentModel(
  id: json['id'] as String,
  type: json['type'] as String,
  description: json['description'] as String,
  amount: (json['amount'] as num).toDouble(),
  currency: json['currency'] as String,
  status: json['status'] as String,
  gateway: json['gateway'] as String,
  paymentReference: json['payment_reference'] as String,
  receiptUrl: json['receipt_url'] as String?,
  createdAt: DateTime.parse(json['created_at'] as String),
);

Map<String, dynamic> _$PaymentModelToJson(PaymentModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': instance.type,
      'description': instance.description,
      'amount': instance.amount,
      'currency': instance.currency,
      'status': instance.status,
      'gateway': instance.gateway,
      'payment_reference': instance.paymentReference,
      'receipt_url': instance.receiptUrl,
      'created_at': instance.createdAt.toIso8601String(),
    };
