import 'package:bourgo_arena_mobile/data/models/subscription_model.dart';
import 'package:bourgo_arena_mobile/domain/entities/subscription.dart';

/// Mapper to convert [SubscriptionModel] to [Subscription].
class SubscriptionMapper {
  /// Converts [SubscriptionModel] to [Subscription].
  static Subscription toEntity(SubscriptionModel model) {
    return Subscription(
      id: model.id,
      planName: model.planName ?? model.name ?? 'Unknown Plan',
      planDescription: model.planDescription,
      status: model.status ?? 'unknown',
      startsAt: model.startsAt,
      endsAt: model.endsAt,
      daysRemaining: model.daysRemaining,
      paymentMethod: model.paymentMethod,
      amountPaid: model.amountPaid ?? model.price,
    );
  }

  /// Converts [Subscription] to [SubscriptionModel].
  static SubscriptionModel fromEntity(Subscription entity) {
    return SubscriptionModel(
      id: entity.id,
      planName: entity.planName,
      planDescription: entity.planDescription,
      status: entity.status,
      startsAt: entity.startsAt,
      endsAt: entity.endsAt,
      daysRemaining: entity.daysRemaining,
      paymentMethod: entity.paymentMethod,
      amountPaid: entity.amountPaid,
    );
  }
}
