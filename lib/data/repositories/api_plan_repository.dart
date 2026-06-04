import 'package:bourgo_arena_mobile/core/utils/result.dart';
import 'package:bourgo_arena_mobile/data/api/api_client.dart';
import 'package:bourgo_arena_mobile/data/api/api_error_handler.dart';
import 'package:bourgo_arena_mobile/data/mappers/plan_mapper.dart';
import 'package:bourgo_arena_mobile/data/models/plan_model.dart';
import 'package:bourgo_arena_mobile/domain/core/failure.dart';
import 'package:bourgo_arena_mobile/domain/entities/plan.dart';
import 'package:bourgo_arena_mobile/domain/repositories/plan_repository.dart';

class ApiPlanRepository implements PlanRepository {
  final ApiClient _apiClient;

  ApiPlanRepository(this._apiClient);

  @override
  Future<Result<List<Plan>, Failure>> getPlans() {
    return executeApiCall(() async {
      final response = await _apiClient.get('/plans') as Map<String, dynamic>;
      final data = response['data'] as List<dynamic>? ?? [];
      final entities = data
          .map((json) => PlanMapper.toEntity(PlanModel.fromJson(json as Map<String, dynamic>)))
          .toList();
      return Result.success(entities);
    });
  }

  @override
  Future<Result<Plan, Failure>> getPlanDetails(String planId) {
    return executeApiCall(() async {
      final response = await _apiClient.get('/plans/$planId') as Map<String, dynamic>;
      final data = response['data'] as Map<String, dynamic>? ?? response;
      final entity = PlanMapper.toEntity(PlanModel.fromJson(data));
      return Result.success(entity);
    });
  }
}
