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
          await _apiClient.get(
                '/user/payments',
                queryParams: {
                  'page': page.toString(),
                  'per_page': limit.toString(),
                },
              )
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

  @override
  Future<Result<Map<String, dynamic>, Failure>> initiatePayment({
    required double amount,
    String? currency = 'TND',
    String? provider,
    String? description,
    String? successUrl,
    String? failureUrl,
  }) {
    return executeApiCall(() async {
      final body = <String, dynamic>{'amount': amount};
      if (currency != null) body['currency'] = currency;
      if (provider != null) body['provider'] = provider;
      if (description != null) body['description'] = description;
      if (successUrl != null) body['success_url'] = successUrl;
      if (failureUrl != null) body['failure_url'] = failureUrl;

      final response =
          await _apiClient.post('/payments/initiate', body)
              as Map<String, dynamic>;
      return Result.success(response);
    });
  }

  @override
  Future<Result<Map<String, dynamic>, Failure>> verifyPayment({
    String? paymentReference,
    String? gatewayTransactionId,
  }) {
    return executeApiCall(() async {
      final body = <String, dynamic>{};
      if (paymentReference != null)
        body['payment_reference'] = paymentReference;
      if (gatewayTransactionId != null)
        body['gateway_transaction_id'] = gatewayTransactionId;

      final response =
          await _apiClient.post('/payments/verify', body)
              as Map<String, dynamic>;
      return Result.success(response);
    });
  }
}
