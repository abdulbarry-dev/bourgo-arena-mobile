import 'package:bourgo_arena_mobile/core/utils/result.dart';
import 'package:bourgo_arena_mobile/data/api/api_client.dart';
import 'package:bourgo_arena_mobile/data/api/api_error_handler.dart';
import 'package:bourgo_arena_mobile/data/mappers/event_mapper.dart';
import 'package:bourgo_arena_mobile/data/models/event_model.dart';
import 'package:bourgo_arena_mobile/domain/core/failure.dart';
import 'package:bourgo_arena_mobile/domain/entities/bracket.dart';
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
  Future<Result<List<BracketRound>, Failure>> getEventBracket(String eventId) {
    return executeApiCall(() async {
      final response = await _apiClient.get('/events/$eventId/bracket');
      if (response is List) return Result.success([]);
      final responseMap = response as Map<String, dynamic>;
      final data = responseMap['data'] as Map<String, dynamic>? ?? responseMap;
      final rounds = <BracketRound>[];
      for (final entry in data.entries) {
        final roundNumber =
            int.tryParse(entry.key.replaceAll('round_', '')) ?? 0;
        final matches = (entry.value as List)
            .map(
              (m) => EventMapper.toMatch(
                MatchModel.fromJson(m as Map<String, dynamic>),
              ),
            )
            .toList();
        rounds.add(BracketRound(round: roundNumber, matches: matches));
      }
      rounds.sort((a, b) => a.round.compareTo(b.round));
      return Result.success(rounds);
    });
  }

  @override
  Future<Result<RegistrationResult, Failure>> registerForEvent(
    String eventId, {
    String? childId,
  }) {
    return executeApiCall(() async {
      final body = <String, dynamic>{};
      if (childId != null) {
        body['child_id'] = childId;
      }
      final response =
          await _apiClient.post('/events/$eventId/register', body)
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
          : ((response as Map<String, dynamic>)['data'] as List<dynamic>? ??
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
  Future<Result<List<EventParticipant>, Failure>> getAccountRegistrations() {
    return executeApiCall(() async {
      final response = await _apiClient.get('/user/events');
      final List<dynamic> data = response is List
          ? response
          : ((response as Map<String, dynamic>)['data'] as List<dynamic>? ??
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
  Future<Result<void, Failure>> withdrawFromEvent(
    String eventId, {
    String? childId,
  }) {
    return executeApiCall(() async {
      final body = <String, dynamic>{};
      if (childId != null) {
        body['child_id'] = childId;
      }
      await _apiClient.post('/events/$eventId/withdraw', body);
      return Result.success(null);
    });
  }

  @override
  Future<Result<void, Failure>> checkInToEvent(
    String eventId, {
    String? childId,
  }) {
    return executeApiCall(() async {
      final body = <String, dynamic>{};
      if (childId != null) {
        body['child_id'] = childId;
      }
      await _apiClient.post('/events/$eventId/check-in', body);
      return Result.success(null);
    });
  }
}
