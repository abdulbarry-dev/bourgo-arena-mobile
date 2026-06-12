import 'package:bourgo_arena_mobile/core/utils/result.dart';
import 'package:bourgo_arena_mobile/data/api/api_client.dart';
import 'package:bourgo_arena_mobile/data/api/api_error_handler.dart';
import 'package:bourgo_arena_mobile/data/mappers/event_mapper.dart';
import 'package:bourgo_arena_mobile/data/models/event_model.dart';
import 'package:bourgo_arena_mobile/domain/core/failure.dart';
import 'package:bourgo_arena_mobile/domain/entities/event.dart';
import 'package:bourgo_arena_mobile/domain/repositories/event_repository.dart';

class ApiEventRepository implements EventRepository {
  final ApiClient _apiClient;

  ApiEventRepository(this._apiClient);

  @override
  Future<Result<List<Event>, Failure>> getEvents({
    String? sportType,
    int page = 1,
  }) {
    return executeApiCall(() async {
      final queryParams = <String, dynamic>{'page': page.toString()};
      if (sportType != null) queryParams['sport_type'] = sportType;

      final response = await _apiClient.get(
        '/events',
        queryParameters: queryParams,
      );
      final List<dynamic> data = response is List
          ? response
          : ((response as Map<String, dynamic>)['data'] as List<dynamic>? ??
                []);
      final entities = data
          .map(
            (json) => EventMapper.toEntity(
              EventModel.fromJson(json as Map<String, dynamic>),
            ),
          )
          .toList();
      return Result.success(entities);
    });
  }

  @override
  Future<Result<Event, Failure>> getEventById(String eventId) {
    return executeApiCall(() async {
      final response =
          await _apiClient.get('/events/$eventId') as Map<String, dynamic>;
      final data = response['data'] as Map<String, dynamic>? ?? response;
      return Result.success(EventMapper.toEntity(EventModel.fromJson(data)));
    });
  }

  @override
  Future<Result<Map<String, dynamic>, Failure>> getEventBracket(
    String eventId,
  ) {
    return executeApiCall(() async {
      final response =
          await _apiClient.get('/events/$eventId/bracket')
              as Map<String, dynamic>;
      final data = response['data'] as Map<String, dynamic>? ?? response;
      return Result.success(data);
    });
  }

  @override
  Future<Result<RegistrationResult, Failure>> registerForEvent(String eventId) {
    return executeApiCall(() async {
      final response =
          await _apiClient.post('/events/$eventId/register', {})
              as Map<String, dynamic>;
      final status = response['status'] as String? ?? 'pending';
      return Result.success(RegistrationResult(status: status));
    });
  }

  @override
  Future<Result<List<EventParticipant>, Failure>> getMyEvents() {
    return executeApiCall(() async {
      final response = await _apiClient.get('/user/events');
      final List<dynamic> data = response is List
          ? response
          : ((response as Map<String, dynamic>)['data']
                  as List<dynamic>? ??
              []);
      final entities = data
          .map(
            (json) => EventMapper.toParticipantEntity(
              EventParticipantModel.fromJson(json as Map<String, dynamic>),
            ),
          )
          .toList();
      return Result.success(entities);
    });
  }

  @override
  Future<Result<void, Failure>> withdrawFromEvent(String eventId) {
    return executeApiCall(() async {
      await _apiClient.post('/events/$eventId/withdraw', {});
      return Result.success(null);
    });
  }

  @override
  Future<Result<void, Failure>> checkInToEvent(String eventId) {
    return executeApiCall(() async {
      await _apiClient.post('/events/$eventId/check-in', {});
      return Result.success(null);
    });
  }
}
