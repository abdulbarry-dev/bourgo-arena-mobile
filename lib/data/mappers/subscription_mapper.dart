import 'package:bourgo_arena_mobile/data/mappers/plan_mapper.dart';
import 'package:bourgo_arena_mobile/data/models/plan_model.dart';
import 'package:bourgo_arena_mobile/data/models/subscription_model.dart';
import 'package:bourgo_arena_mobile/domain/entities/plan.dart';
import 'package:bourgo_arena_mobile/domain/entities/subscription.dart';

/// Mapper to convert [SubscriptionModel] to [Subscription].
class SubscriptionMapper {
  /// Converts [SubscriptionModel] to [Subscription].
  static Subscription toEntity(SubscriptionModel model) {
    return Subscription(
      id: model.id,
      plan: model.plan != null ? PlanMapper.toEntity(model.plan!) : null,
      service: model.service != null
          ? PlanService(
              id: model.service!.id,
              name: model.service!.name,
              slug: model.service!.slug,
              description: model.service!.description,
              imageUrl: model.service!.imageUrl,
              images: model.service!.images,
              status: model.service!.status,
            )
          : null,
      status: model.status ?? 'unknown',
      startsAt: model.startsAt,
      endsAt: model.endsAt,
      daysRemaining: model.daysRemaining,
      paymentMethod: model.paymentMethod,
      amountPaid: model.amountPaid,
      receiptUrl: model.receiptUrl,
    );
  }

  static SubscriptionModel fromEntity(Subscription entity) {
    return SubscriptionModel(
      id: entity.id,
      plan: entity.plan != null ? PlanMapper.fromEntity(entity.plan!) : null,
      service: entity.service != null
          ? PlanServiceModel(
              id: entity.service!.id,
              name: entity.service!.name,
              slug: entity.service!.slug,
              description: entity.service!.description,
              imageUrl: entity.service!.imageUrl,
              images: entity.service!.images,
              status: entity.service!.status,
            )
          : null,
      status: entity.status,
      startsAt: entity.startsAt,
      endsAt: entity.endsAt,
      daysRemaining: entity.daysRemaining,
      paymentMethod: entity.paymentMethod,
      amountPaid: entity.amountPaid,
      receiptUrl: entity.receiptUrl,
    );
  }
}
