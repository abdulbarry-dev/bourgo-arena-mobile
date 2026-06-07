import 'package:bourgo_arena_mobile/core/utils/result.dart';
import 'package:bourgo_arena_mobile/domain/core/failure.dart';
import 'package:bourgo_arena_mobile/domain/entities/loyalty_balance.dart';

/// Interface for loyalty-related data operations.
abstract interface class LoyaltyRepository {
  /// Fetches the member's current loyalty balance, tier, and recent
  /// transactions from GET /loyalty/balance.
  Future<Result<LoyaltyBalance, Failure>> getLoyaltyBalance();
}
