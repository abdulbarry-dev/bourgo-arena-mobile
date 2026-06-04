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
      final response = await _apiClient.get(
        '/services?page=$page&per_page=$limit',
      );
      final List<dynamic> data = response is List
          ? response
          : (response['data'] as List<dynamic>? ?? []);

      final services = data.map((json) {
        final map = json as Map<String, dynamic>;
        return Service(
          id: map['id'] as int,
          name: map['name'] as String,
          imageUrl: map['image_url'] as String?,
          description: map['description'] as String?,
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
        id: data['id'] as int,
        name: data['name'] as String,
        imageUrl: data['image_url'] as String?,
        description: data['description'] as String?,
      );

      return Success(service);
    });
  }
}
