import 'package:bourgo_arena_mobile/core/utils/result.dart';
import 'package:bourgo_arena_mobile/domain/core/failure.dart';
import 'package:bourgo_arena_mobile/domain/entities/loyalty_payment.dart';
import 'package:bourgo_arena_mobile/domain/repositories/loyalty_repository.dart';

class GetLoyaltyPaymentsUseCase {
  final LoyaltyRepository _repository;

  const GetLoyaltyPaymentsUseCase(this._repository);

  Future<Result<List<LoyaltyPayment>, Failure>> call() {
    return _repository.getLoyaltyPayments();
  }
}
