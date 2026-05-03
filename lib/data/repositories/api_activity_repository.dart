import 'package:bourgo_arena_mobile/data/api/api_client.dart';
import 'package:bourgo_arena_mobile/data/models/activity_model.dart';
import 'package:bourgo_arena_mobile/domain/entities/activity.dart';
import 'package:bourgo_arena_mobile/domain/repositories/activity_repository.dart';

/// Laravel API implementation of [ActivityRepository].
class ApiActivityRepository implements ActivityRepository {
  final ApiClient _apiClient;

  ApiActivityRepository(this._apiClient);

  @override
  Future<List<Activity>> getActivities() async {
    final response = await _apiClient.get('/activities') as List<dynamic>;
    return response
        .map(
          (json) =>
              ActivityModel.fromJson(json as Map<String, dynamic>).toEntity(),
        )
        .toList();
  }

  @override
  Future<Activity> getActivityById(String id) async {
    final response = await _apiClient.get('/activities/$id');
    return ActivityModel.fromJson(response).toEntity();
  }
}
