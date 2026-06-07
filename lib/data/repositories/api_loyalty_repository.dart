import 'package:bourgo_arena_mobile/core/utils/result.dart';
import 'package:bourgo_arena_mobile/data/api/api_client.dart';
import 'package:bourgo_arena_mobile/data/api/api_error_handler.dart';
import 'package:bourgo_arena_mobile/data/mappers/loyalty_balance_mapper.dart';
import 'package:bourgo_arena_mobile/data/models/loyalty_transaction_model.dart';
import 'package:bourgo_arena_mobile/domain/core/failure.dart';
import 'package:bourgo_arena_mobile/domain/entities/loyalty_balance.dart';
import 'package:bourgo_arena_mobile/domain/repositories/loyalty_repository.dart';

/// Laravel API implementation of [LoyaltyRepository].
class ApiLoyaltyRepository implements LoyaltyRepository {
  final ApiClient _apiClient;

  ApiLoyaltyRepository(this._apiClient);

  @override
  Future<Result<LoyaltyBalance, Failure>> getLoyaltyBalance() {
    if (!_apiClient.hasToken) {
      return Future.value(const Success(LoyaltyBalance(totalPoints: 0)));
    }
    return executeApiCall(() async {
      final response =
          await _apiClient.get('/loyalty/balance') as Map<String, dynamic>;

      final data = response['data'] as Map<String, dynamic>? ?? response;
      final model = LoyaltyBalanceModel.fromJson(data);
      return Success(LoyaltyBalanceMapper.toEntity(model));
    });
  }
}
