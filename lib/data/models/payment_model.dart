import 'package:json_annotation/json_annotation.dart';

part 'payment_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class PaymentModel {
  final String id;
  final String type;
  final String description;
  final double amount;
  final String? currency;
  final String status;
  final String? gateway;
  final String paymentReference;
  final String? receiptUrl;
  final int? reservationId;
  final int? subscriptionId;
  final DateTime createdAt;

  const PaymentModel({
    required this.id,
    required this.type,
    required this.description,
    required this.amount,
    this.currency,
    required this.status,
    this.gateway,
    required this.paymentReference,
    this.receiptUrl,
    this.reservationId,
    this.subscriptionId,
    required this.createdAt,
  });

  factory PaymentModel.fromJson(Map<String, dynamic> json) {
    if (json['id'] != null && json['id'] is int) {
      json['id'] = json['id'].toString();
    }
    return _$PaymentModelFromJson(json);
  }
  Map<String, dynamic> toJson() => _$PaymentModelToJson(this);
}
