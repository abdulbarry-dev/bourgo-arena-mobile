import 'package:json_annotation/json_annotation.dart';

part 'loyalty_transaction_model.g.dart';

int _readInt(Map<dynamic, dynamic> json, String key) {
  final val = json[key];
  if (val is int) return val;
  if (val is double) return val.toInt();
  if (val is String) return int.tryParse(val) ?? 0;
  return 0;
}

int _readTotalPoints(Map<dynamic, dynamic> json, String key) {
  final val = json['points'];
  if (val is int) return val;
  if (val is double) return val.toInt();
  if (val is String) return int.tryParse(val) ?? 0;
  return 0;
}

/// DTO for a single loyalty transaction from GET /loyalty/balance.
@JsonSerializable(fieldRename: FieldRename.snake)
class LoyaltyTransactionModel {
  @JsonKey(readValue: _readIdAsString)
  final String id;
  @JsonKey(readValue: _readInt)
  final int points;
  @JsonKey(name: 'source_type')
  final String? description;
  final String? createdAt;
  @JsonKey(name: 'transaction_type')
  final String? type;

  const LoyaltyTransactionModel({
    required this.id,
    required this.points,
    this.description,
    this.createdAt,
    this.type,
  });

  factory LoyaltyTransactionModel.fromJson(Map<String, dynamic> json) =>
      _$LoyaltyTransactionModelFromJson(json);

  Map<String, dynamic> toJson() => _$LoyaltyTransactionModelToJson(this);

  static String _readIdAsString(Map<dynamic, dynamic> json, String key) {
    return json['id']?.toString() ?? '';
  }
}

/// DTO for the loyalty balance response matching GET /loyalty/balance.
@JsonSerializable(fieldRename: FieldRename.snake)
class LoyaltyBalanceModel {
  @JsonKey(readValue: _readTotalPoints)
  final int totalPoints;
  final int? earnedThisMonth;
  final int? redeemedThisMonth;
  final String? tierName;
  final List<LoyaltyTransactionModel>? transactions;

  @JsonKey(name: 'conversion_rate')
  final double? conversionRate;

  @JsonKey(name: 'minimum_payment_points')
  final int? minimumPaymentPoints;

  @JsonKey(name: 'maximum_per_transaction')
  final int? maximumPerTransaction;

  const LoyaltyBalanceModel({
    required this.totalPoints,
    this.earnedThisMonth,
    this.redeemedThisMonth,
    this.tierName,
    this.transactions,
    this.conversionRate,
    this.minimumPaymentPoints,
    this.maximumPerTransaction,
  });

  factory LoyaltyBalanceModel.fromJson(Map<String, dynamic> json) =>
      _$LoyaltyBalanceModelFromJson(json);

  Map<String, dynamic> toJson() => _$LoyaltyBalanceModelToJson(this);
}
