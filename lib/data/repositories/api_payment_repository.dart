import 'package:bourgo_arena_mobile/core/utils/result.dart';
import 'package:bourgo_arena_mobile/data/api/api_client.dart';
import 'package:bourgo_arena_mobile/data/api/api_error_handler.dart';
import 'package:bourgo_arena_mobile/data/mappers/payment_mapper.dart';
import 'package:bourgo_arena_mobile/data/models/payment_model.dart';
import 'package:bourgo_arena_mobile/domain/core/failure.dart';
import 'package:bourgo_arena_mobile/domain/entities/payment.dart';
import 'package:bourgo_arena_mobile/domain/repositories/payment_repository.dart';

class ApiPaymentRepository implements PaymentRepository {
  final ApiClient _apiClient;

  ApiPaymentRepository(this._apiClient);

  @override
  Future<Result<List<Payment>, Failure>> getUserPayments({
    int page = 1,
    int limit = 15,
  }) {
    return executeApiCall(() async {
      final response =
          await _apiClient.get('/user/payments?page=$page&per_page=$limit')
              as Map<String, dynamic>;

      final data = response['data'] as List<dynamic>? ?? [];
      final payments = data.map((json) {
        return PaymentMapper.toEntity(
          PaymentModel.fromJson(json as Map<String, dynamic>),
        );
      }).toList();

      return Result.success(payments);
    });
  }
}
