import 'package:bourgo_arena_mobile/core/utils/result.dart';
import 'package:bourgo_arena_mobile/data/api/api_client.dart';
import 'package:bourgo_arena_mobile/data/api/api_error_handler.dart';
import 'package:bourgo_arena_mobile/data/mappers/event_mapper.dart';
import 'package:bourgo_arena_mobile/data/models/event_model.dart';
import 'package:bourgo_arena_mobile/domain/core/failure.dart';
import 'package:bourgo_arena_mobile/domain/entities/event.dart';
import 'package:bourgo_arena_mobile/domain/repositories/event_repository.dart';

/// Laravel API implementation of [EventRepository].
class ApiEventRepository implements EventRepository {
  final ApiClient _apiClient;

  ApiEventRepository(this._apiClient);

  @override
  Future<Result<List<Event>, Failure>> getEvents() {
    return executeApiCall(() async {
      final response = await _apiClient.get('/events');
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
  Future<Result<List<Match>, Failure>> getEventBracket(String eventId) {
    return executeApiCall(() async {
      final response = await _apiClient.get('/events/$eventId/bracket');
      final List<dynamic> data = response is List
          ? response
          : ((response as Map<String, dynamic>)['data'] as List<dynamic>? ??
                []);
      final matches = data
          .map(
            (json) => EventMapper.toMatch(
              MatchModel.fromJson(json as Map<String, dynamic>),
            ),
          )
          .toList();
      return Result.success(matches);
    });
  }

  @override
  Future<Result<void, Failure>> registerForEvent(String eventId) {
    return executeApiCall(() async {
      await _apiClient.post('/events/$eventId/register', {});
      return Result.success(null);
    });
  }
}
