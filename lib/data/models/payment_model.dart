import 'package:json_annotation/json_annotation.dart';

part 'payment_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class PaymentModel {
  final String id;
  final String type;
  final double amount;
  final String currency;
  final String status;
  final String gateway;
  final String paymentReference;
  final DateTime createdAt;

  const PaymentModel({
    required this.id,
    required this.type,
    required this.amount,
    required this.currency,
    required this.status,
    required this.gateway,
    required this.paymentReference,
    required this.createdAt,
  });

  factory PaymentModel.fromJson(Map<String, dynamic> json) => _$PaymentModelFromJson(json);
  Map<String, dynamic> toJson() => _$PaymentModelToJson(this);
}
