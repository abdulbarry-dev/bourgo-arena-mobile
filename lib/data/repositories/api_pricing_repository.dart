import 'package:bourgo_arena_mobile/core/utils/result.dart';
import 'package:bourgo_arena_mobile/data/api/api_client.dart';
import 'package:bourgo_arena_mobile/data/api/api_error_handler.dart';
import 'package:bourgo_arena_mobile/domain/core/app_error_code.dart';
import 'package:bourgo_arena_mobile/domain/core/failure.dart';
import 'package:bourgo_arena_mobile/domain/repositories/pricing_repository.dart';

/// Laravel API implementation of [PricingRepository].
class ApiPricingRepository implements PricingRepository {
  final ApiClient _apiClient;

  ApiPricingRepository(this._apiClient);

  @override
  Future<Result<double, Failure>> getContextualPrice({
    required String activityId,
    required String memberId,
  }) {
    return executeApiCall(() async {
      // Backend should compute member vs public rate based on tier.
      final response = await _apiClient.get(
        '/activities/$activityId/contextual-price?member_id=$memberId',
      );

      if (response is num) {
        return Result.success(response.toDouble());
      }
      if (response is Map<String, dynamic>) {
        final value = response['price'];
        if (value is num) return Result.success(value.toDouble());
      }
      return Result.failure(
        Failure.server(AppErrorCode.serverError, 'invalid_price_response'),
      );
    });
  }
}
