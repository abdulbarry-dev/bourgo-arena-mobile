class LoyaltyPayment {
  final String id;
  final int points;
  final String description;
  final String status;
  final String createdAt;

  const LoyaltyPayment({
    required this.id,
    required this.points,
    required this.description,
    required this.status,
    required this.createdAt,
  });
}
