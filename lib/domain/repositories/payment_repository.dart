import 'package:bourgo_arena_mobile/core/utils/result.dart';
import 'package:bourgo_arena_mobile/domain/core/failure.dart';
import 'package:bourgo_arena_mobile/domain/entities/payment.dart';

abstract interface class PaymentRepository {
  Future<Result<List<Payment>, Failure>> getUserPayments({
    int page = 1,
    int limit = 15,
  });
}
