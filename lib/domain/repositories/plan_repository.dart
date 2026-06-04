import 'package:bourgo_arena_mobile/core/utils/result.dart';
import 'package:bourgo_arena_mobile/domain/core/failure.dart';
import 'package:bourgo_arena_mobile/domain/entities/plan.dart';

abstract interface class PlanRepository {
  Future<Result<List<Plan>, Failure>> getPlans();
  Future<Result<Plan, Failure>> getPlanDetails(String planId);
}
