import 'package:bourgo_arena_mobile/core/utils/result.dart';
import 'package:bourgo_arena_mobile/domain/core/failure.dart';
import 'package:bourgo_arena_mobile/domain/entities/payment.dart';
import 'package:bourgo_arena_mobile/domain/repositories/payment_repository.dart';

/// Use case to retrieve the authenticated member's full payment history.
class GetFullPaymentHistoryUseCase {
  final PaymentRepository _repository;

  GetFullPaymentHistoryUseCase(this._repository);

  Future<Result<List<Payment>, Failure>> execute() {
    return _repository.getUserPayments();
  }
}
