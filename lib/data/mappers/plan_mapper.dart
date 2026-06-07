import 'package:bourgo_arena_mobile/data/models/plan_model.dart';
import 'package:bourgo_arena_mobile/domain/entities/plan.dart';

/// Mapper to convert [PlanModel] to [Plan] and vice-versa.
class PlanMapper {
  /// Converts [PlanModel] to [Plan].
  static Plan toEntity(PlanModel model) {
    PlanService? service;
    if (model.service != null) {
      service = PlanService(
        id: model.service!.id,
        name: model.service!.name,
        description: model.service!.description,
        imageUrl: model.service!.imageUrl,
        status: model.service!.status,
      );
    }

    return Plan(
      id: model.id,
      name: model.name,
      description: model.description,
      price: model.price,
      durationDays: model.durationDays,
      billingCycle: model.billingCycle,
      hasAllCourses: model.hasAllCourses ?? false,
      service: service,
    );
  }

  /// Converts [Plan] to [PlanModel].
  static PlanModel fromEntity(Plan entity) {
    PlanServiceModel? serviceModel;
    if (entity.service != null) {
      serviceModel = PlanServiceModel(
        id: entity.service!.id,
        name: entity.service!.name,
        description: entity.service!.description,
        imageUrl: entity.service!.imageUrl,
        status: entity.service!.status,
      );
    }

    return PlanModel(
      id: entity.id,
      name: entity.name,
      description: entity.description,
      price: entity.price,
      durationDays: entity.durationDays,
      billingCycle: entity.billingCycle,
      hasAllCourses: entity.hasAllCourses,
      service: serviceModel,
    );
  }
}
