import 'package:equatable/equatable.dart';

/// Entity representing a financial transaction.
class Payment extends Equatable {
  final String id;
  final String type;
  final String description;
  final double amount;
  final String status;
  final String? gateway;
  final String paymentReference;
  final String? receiptUrl;
  final int? reservationId;
  final int? subscriptionId;
  final DateTime createdAt;

  const Payment({
    required this.id,
    required this.type,
    required this.description,
    required this.amount,
    required this.status,
    this.gateway,
    required this.paymentReference,
    this.receiptUrl,
    this.reservationId,
    this.subscriptionId,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [
    id,
    type,
    description,
    amount,
    status,
    gateway,
    paymentReference,
    receiptUrl,
    reservationId,
    subscriptionId,
    createdAt,
  ];
}
