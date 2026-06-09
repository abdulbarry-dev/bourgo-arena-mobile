import 'package:bourgo_arena_mobile/core/utils/result.dart';
import 'package:bourgo_arena_mobile/domain/core/failure.dart';
import 'package:bourgo_arena_mobile/domain/entities/plan.dart';
import 'package:bourgo_arena_mobile/domain/repositories/plan_repository.dart';

class GetPlansUseCase {
  final PlanRepository _repository;

  GetPlansUseCase(this._repository);

  Future<Result<List<Plan>, Failure>> call() async {
    return _repository.getPlans();
  }
}
