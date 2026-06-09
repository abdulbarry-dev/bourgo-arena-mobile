import 'package:bourgo_arena_mobile/core/utils/result.dart';
import 'package:bourgo_arena_mobile/domain/core/failure.dart';
import 'package:bourgo_arena_mobile/domain/repositories/loyalty_repository.dart';

class PayWithLoyaltyUseCase {
  final LoyaltyRepository _repository;

  PayWithLoyaltyUseCase(this._repository);

  Future<Result<Map<String, dynamic>, Failure>> call({
    required String type,
    required int id,
  }) async {
    return _repository.payWithPoints(type, id);
  }
}
