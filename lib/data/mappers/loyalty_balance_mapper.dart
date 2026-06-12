import 'package:bourgo_arena_mobile/data/models/loyalty_transaction_model.dart';
import 'package:bourgo_arena_mobile/domain/entities/loyalty_balance.dart';

/// Mapper for [LoyaltyBalanceModel] to [LoyaltyBalance].
class LoyaltyBalanceMapper {
  /// Converts [LoyaltyBalanceModel] to [LoyaltyBalance].
  static LoyaltyBalance toEntity(LoyaltyBalanceModel model) {
    final transactions =
        model.transactions
            ?.map(
              (t) => LoyaltyTransaction(
                id: t.id,
                points: t.points,
                description: t.description,
                createdAt: t.createdAt,
                type: t.type,
              ),
            )
            .toList() ??
        const [];

    return LoyaltyBalance(
      totalPoints: model.totalPoints,
      earnedThisMonth: model.earnedThisMonth,
      redeemedThisMonth: model.redeemedThisMonth,
      tierName: model.tierName,
      conversionRate: model.conversionRate,
      minimumPaymentPoints: model.minimumPaymentPoints,
      maximumPerTransaction: model.maximumPerTransaction,
      transactions: transactions,
    );
  }
}
