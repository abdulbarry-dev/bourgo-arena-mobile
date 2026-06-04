import 'package:bourgo_arena_mobile/data/models/payment_model.dart';
import 'package:bourgo_arena_mobile/domain/entities/payment.dart';

class PaymentMapper {
  static Payment toEntity(PaymentModel model) {
    return Payment(
      id: model.id,
      type: model.type,
      amount: model.amount,
      currency: model.currency,
      status: model.status,
      gateway: model.gateway,
      paymentReference: model.paymentReference,
      createdAt: model.createdAt,
    );
  }
}
