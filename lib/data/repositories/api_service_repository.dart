import 'package:bourgo_arena_mobile/core/utils/result.dart';
import 'package:bourgo_arena_mobile/data/api/api_client.dart';
import 'package:bourgo_arena_mobile/data/api/api_error_handler.dart';
import 'package:bourgo_arena_mobile/domain/core/failure.dart';
import 'package:bourgo_arena_mobile/domain/entities/service.dart';
import 'package:bourgo_arena_mobile/domain/repositories/service_repository.dart';

class ApiServiceRepository implements ServiceRepository {
  final ApiClient _apiClient;

  ApiServiceRepository(this._apiClient);

  @override
  Future<Result<List<Service>, Failure>> getServices({
    int page = 1,
    int limit = 15,
  }) {
    return executeApiCall(() async {
      final response =
          await _apiClient.get(
                '/services',
                queryParameters: {
                  'page': page.toString(),
                  'per_page': limit.toString(),
                },
              )
              as Map<String, dynamic>;

      final data = response['data'] as List<dynamic>? ?? [];

      final services = data.map((json) {
        final map = json as Map<String, dynamic>;
        return Service(
          id: map['id'] is int
              ? map['id'] as int
              : int.parse(map['id'].toString()),
          name: map['name'] as String,
          imageUrl: map['image_url'] as String?,
          description: map['description'] as String?,
          plansCount: map['plans_count'] as int? ?? 0,
          coursesCount: map['courses_count'] as int? ?? 0,
          eventsCount: map['events_count'] as int? ?? 0,
          activitiesCount: map['activities_count'] as int? ?? 0,
        );
      }).toList();

      return Success(services);
    });
  }

  @override
  Future<Result<Service, Failure>> getServiceDetails(int serviceId) {
    return executeApiCall(() async {
      final response =
          await _apiClient.get('/services/$serviceId') as Map<String, dynamic>;
      final data = response['data'] as Map<String, dynamic>? ?? response;

      final service = Service(
        id: data['id'] is int
            ? data['id'] as int
            : int.parse(data['id'].toString()),
        name: data['name'] as String,
        imageUrl: data['image_url'] as String?,
        description: data['description'] as String?,
        plansCount: data['plans_count'] as int? ?? 0,
        coursesCount: data['courses_count'] as int? ?? 0,
        eventsCount: data['events_count'] as int? ?? 0,
        activitiesCount: data['activities_count'] as int? ?? 0,
      );

      return Success(service);
    });
  }
}
