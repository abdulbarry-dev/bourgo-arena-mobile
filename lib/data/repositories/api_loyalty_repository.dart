import 'package:bourgo_arena_mobile/core/utils/result.dart';
import 'package:bourgo_arena_mobile/data/api/api_client.dart';
import 'package:bourgo_arena_mobile/data/api/api_error_handler.dart';
import 'package:bourgo_arena_mobile/data/mappers/loyalty_balance_mapper.dart';
import 'package:bourgo_arena_mobile/data/models/loyalty_payment_model.dart';
import 'package:bourgo_arena_mobile/data/models/loyalty_transaction_model.dart';
import 'package:bourgo_arena_mobile/domain/core/failure.dart';
import 'package:bourgo_arena_mobile/domain/entities/loyalty_balance.dart';
import 'package:bourgo_arena_mobile/domain/entities/loyalty_payment.dart';
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

  @override
  Future<Result<Map<String, dynamic>, Failure>> payWithPoints(
    String type,
    int id,
  ) {
    return executeApiCall(() async {
      final response =
          await _apiClient.post('/loyalty/pay', {'type': type, 'id': id})
              as Map<String, dynamic>;
      final data = response['data'] as Map<String, dynamic>? ?? response;
      return Success(data);
    });
  }

  @override
  Future<Result<List<LoyaltyPayment>, Failure>> getLoyaltyPayments() {
    if (!_apiClient.hasToken) {
      return Future.value(const Success([]));
    }
    return executeApiCall(() async {
      final response =
          await _apiClient.get('/loyalty/payments', fullResponse: true)
              as Map<String, dynamic>;
      final data = response['data'] as List<dynamic>? ?? [];
      final payments = data
          .map(
            (json) => LoyaltyPaymentModel.fromJson(
              json as Map<String, dynamic>,
            ).toEntity(),
          )
          .toList();
      return Success(payments);
    });
  }
}
