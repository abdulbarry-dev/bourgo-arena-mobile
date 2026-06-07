/// Entity representing a member's loyalty balance and transaction history.
class LoyaltyTransaction {
  /// Unique identifier of the transaction.
  final String id;

  /// Points earned (positive) or redeemed (negative).
  final int points;

  /// Human-readable reason (e.g. "Activity booking bonus").
  final String? description;

  /// ISO datetime of the transaction.
  final String? createdAt;

  /// Source type (e.g. "booking", "redemption").
  final String? type;

  /// Creates a new [LoyaltyTransaction].
  const LoyaltyTransaction({
    required this.id,
    required this.points,
    this.description,
    this.createdAt,
    this.type,
  });
}

/// Entity representing the full loyalty balance from GET /loyalty/balance.
class LoyaltyBalance {
  /// Current points total.
  final int totalPoints;

  /// Points earned this month.
  final int? earnedThisMonth;

  /// Points redeemed this month.
  final int? redeemedThisMonth;

  /// Current tier label (e.g. "Standard", "Ultra").
  final String? tierName;

  /// Recent transactions.
  final List<LoyaltyTransaction> transactions;

  /// Creates a new [LoyaltyBalance].
  const LoyaltyBalance({
    required this.totalPoints,
    this.earnedThisMonth,
    this.redeemedThisMonth,
    this.tierName,
    this.transactions = const [],
  });
}
