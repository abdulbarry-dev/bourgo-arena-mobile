import 'package:equatable/equatable.dart';

class Payment extends Equatable {
  final String id;
  final String type;
  final double amount;
  final String currency;
  final String status;
  final String gateway;
  final String paymentReference;
  final DateTime createdAt;

  const Payment({
    required this.id,
    required this.type,
    required this.amount,
    required this.currency,
    required this.status,
    required this.gateway,
    required this.paymentReference,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [
    id,
    type,
    amount,
    currency,
    status,
    gateway,
    paymentReference,
    createdAt,
  ];
}
