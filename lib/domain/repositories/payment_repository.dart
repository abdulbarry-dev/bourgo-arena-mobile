import 'package:bourgo_arena_mobile/core/utils/result.dart';
import 'package:bourgo_arena_mobile/domain/core/failure.dart';
import 'package:bourgo_arena_mobile/domain/entities/payment.dart';

abstract interface class PaymentRepository {
  Future<Result<List<Payment>, Failure>> getUserPayments({
    int page = 1,
    int limit = 15,
  });

  /// Initiates a general payment.
  Future<Result<Map<String, dynamic>, Failure>> initiatePayment({
    required double amount,
    String? currency,
    String? provider,
    String? description,
    String? type,
    int? reservationId,
    int? subscriptionId,
    String? successUrl,
    String? failureUrl,
    String? firstName,
    String? lastName,
    String? email,
    String? phone,
  });

  /// Verifies a general payment.
  Future<Result<Map<String, dynamic>, Failure>> verifyPayment({
    String? paymentReference,
    String? gatewayTransactionId,
  });
}
