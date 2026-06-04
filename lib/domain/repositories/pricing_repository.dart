import 'package:bourgo_arena_mobile/core/utils/result.dart';
import 'package:bourgo_arena_mobile/domain/core/failure.dart';

/// Provides backend-calculated rates based on member tier.
abstract interface class PricingRepository {
  /// Returns the price to pay for [activityId] when booking for [memberId].
  Future<Result<double, Failure>> getContextualPrice({
    required String activityId,
    required String memberId,
  });
}
