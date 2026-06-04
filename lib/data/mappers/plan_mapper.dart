import 'package:bourgo_arena_mobile/data/models/plan_model.dart';
import 'package:bourgo_arena_mobile/domain/entities/plan.dart';

class PlanMapper {
  static Plan toEntity(PlanModel model) {
    return Plan(
      id: model.id,
      name: model.name,
      description: model.description,
      price: model.price,
      billingCycle: model.billingCycle,
      serviceImageUrl: model.serviceImageUrl,
    );
  }

  static PlanModel fromEntity(Plan entity) {
    return PlanModel(
      id: entity.id,
      name: entity.name,
      description: entity.description,
      price: entity.price,
      billingCycle: entity.billingCycle,
    );
  }
}
