import 'package:bourgo_arena_mobile/core/utils/result.dart';
import 'package:bourgo_arena_mobile/domain/core/failure.dart';
import 'package:bourgo_arena_mobile/domain/entities/loyalty_balance.dart';
import 'package:bourgo_arena_mobile/domain/entities/loyalty_payment.dart';

/// Interface for loyalty-related data operations.
abstract interface class LoyaltyRepository {
  /// Fetches the member's current loyalty balance, tier, and recent
  /// transactions from GET /loyalty/balance.
  Future<Result<LoyaltyBalance, Failure>> getLoyaltyBalance();

  /// Pays for a reservation or subscription using loyalty points.
  /// [type] is 'reservation' or 'subscription'.
  /// [id] is the reservation or subscription ID.
  Future<Result<Map<String, dynamic>, Failure>> payWithPoints(
    String type,
    int id,
  );

  /// Retrieves the member's loyalty payment history.
  Future<Result<List<LoyaltyPayment>, Failure>> getLoyaltyPayments();
}
