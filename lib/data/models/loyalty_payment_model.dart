import 'package:bourgo_arena_mobile/domain/entities/loyalty_payment.dart';

class LoyaltyPaymentModel {
  final String id;
  final int points;
  final String description;
  final String status;
  final String createdAt;

  const LoyaltyPaymentModel({
    required this.id,
    required this.points,
    required this.description,
    required this.status,
    required this.createdAt,
  });

  factory LoyaltyPaymentModel.fromJson(Map<String, dynamic> json) {
    return LoyaltyPaymentModel(
      id: json['id'].toString(),
      points: (json['points'] as num?)?.toInt() ?? 0,
      description: json['description'] as String? ?? '',
      status: json['status'] as String? ?? '',
      createdAt: json['created_at'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'points': points,
    'description': description,
    'status': status,
    'created_at': createdAt,
  };

  LoyaltyPayment toEntity() => LoyaltyPayment(
    id: id,
    points: points,
    description: description,
    status: status,
    createdAt: createdAt,
  );
}
