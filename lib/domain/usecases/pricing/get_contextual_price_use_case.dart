import 'package:bourgo_arena_mobile/core/utils/result.dart';
import 'package:bourgo_arena_mobile/domain/core/failure.dart';
import 'package:bourgo_arena_mobile/domain/repositories/pricing_repository.dart';

/// Fetches the backend-calculated price for a booking based on member tier.
class GetContextualPriceUseCase {
  final PricingRepository _repository;

  const GetContextualPriceUseCase(this._repository);

  Future<Result<double, Failure>> call({
    required String activityId,
    required String memberId,
  }) {
    return _repository.getContextualPrice(
      activityId: activityId,
      memberId: memberId,
    );
  }
}
