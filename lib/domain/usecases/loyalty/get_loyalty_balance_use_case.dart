import 'package:bourgo_arena_mobile/core/utils/result.dart';
import 'package:bourgo_arena_mobile/domain/core/failure.dart';
import 'package:bourgo_arena_mobile/domain/entities/loyalty_balance.dart';
import 'package:bourgo_arena_mobile/domain/repositories/loyalty_repository.dart';

/// Returns the member's loyalty balance and transaction history.
class GetLoyaltyBalanceUseCase {
  final LoyaltyRepository _repository;

  /// Creates a new [GetLoyaltyBalanceUseCase].
  const GetLoyaltyBalanceUseCase(this._repository);

  /// Executes the use case.
  Future<Result<LoyaltyBalance, Failure>> call() =>
      _repository.getLoyaltyBalance();
}
