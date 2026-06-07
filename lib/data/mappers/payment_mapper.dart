import 'package:bourgo_arena_mobile/data/models/payment_model.dart';
import 'package:bourgo_arena_mobile/domain/entities/payment.dart';

/// Mapper to convert [PaymentModel] to [Payment].
class PaymentMapper {
  /// Converts [PaymentModel] to [Payment].
  static Payment toEntity(PaymentModel model) {
    return Payment(
      id: model.id,
      type: model.type,
      description: model.description,
      amount: model.amount,
      status: model.status,
      gateway: model.gateway,
      paymentReference: model.paymentReference,
      receiptUrl: model.receiptUrl,
      createdAt: model.createdAt,
    );
  }
}
