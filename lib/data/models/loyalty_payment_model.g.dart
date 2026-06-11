// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'loyalty_payment_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LoyaltyPaymentModel _$LoyaltyPaymentModelFromJson(Map<String, dynamic> json) =>
    LoyaltyPaymentModel(
      id: json['id'] as String,
      points: (json['points'] as num).toInt(),
      description: json['description'] as String,
      status: json['status'] as String,
      createdAt: json['created_at'] as String,
    );

Map<String, dynamic> _$LoyaltyPaymentModelToJson(
  LoyaltyPaymentModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'points': instance.points,
  'description': instance.description,
  'status': instance.status,
  'created_at': instance.createdAt,
};
