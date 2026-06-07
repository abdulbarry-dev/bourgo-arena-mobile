// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'loyalty_transaction_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LoyaltyTransactionModel _$LoyaltyTransactionModelFromJson(
  Map<String, dynamic> json,
) => LoyaltyTransactionModel(
  id: LoyaltyTransactionModel._readIdAsString(json, 'id') as String,
  points: (_readInt(json, 'points') as num).toInt(),
  description: json['source_type'] as String?,
  createdAt: json['created_at'] as String?,
  type: json['transaction_type'] as String?,
);

Map<String, dynamic> _$LoyaltyTransactionModelToJson(
  LoyaltyTransactionModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'points': instance.points,
  'source_type': instance.description,
  'created_at': instance.createdAt,
  'transaction_type': instance.type,
};

LoyaltyBalanceModel _$LoyaltyBalanceModelFromJson(Map<String, dynamic> json) =>
    LoyaltyBalanceModel(
      totalPoints: (_readTotalPoints(json, 'total_points') as num).toInt(),
      earnedThisMonth: (json['earned_this_month'] as num?)?.toInt(),
      redeemedThisMonth: (json['redeemed_this_month'] as num?)?.toInt(),
      tierName: json['tier_name'] as String?,
      transactions: (json['transactions'] as List<dynamic>?)
          ?.map(
            (e) => LoyaltyTransactionModel.fromJson(e as Map<String, dynamic>),
          )
          .toList(),
    );

Map<String, dynamic> _$LoyaltyBalanceModelToJson(
  LoyaltyBalanceModel instance,
) => <String, dynamic>{
  'total_points': instance.totalPoints,
  'earned_this_month': instance.earnedThisMonth,
  'redeemed_this_month': instance.redeemedThisMonth,
  'tier_name': instance.tierName,
  'transactions': instance.transactions,
};
