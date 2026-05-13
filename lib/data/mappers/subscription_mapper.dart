import 'package:bourgo_arena_mobile/data/models/subscription_model.dart';
import 'package:bourgo_arena_mobile/domain/entities/subscription.dart';

/// Mapper to convert [SubscriptionModel] to [Subscription] and vice-versa.
class SubscriptionMapper {
  /// Converts [SubscriptionModel] to [Subscription].
  static Subscription toEntity(SubscriptionModel model) {
    return Subscription(
      id: model.id,
      name: model.name,
      price: model.price,
      benefits: model.benefits,
      durationMonths: model.durationMonths,
    );
  }

  /// Converts [Subscription] to [SubscriptionModel].
  static SubscriptionModel fromEntity(Subscription entity) {
    return SubscriptionModel(
      id: entity.id,
      name: entity.name,
      price: entity.price,
      benefits: entity.benefits,
      durationMonths: entity.durationMonths,
    );
  }
}
