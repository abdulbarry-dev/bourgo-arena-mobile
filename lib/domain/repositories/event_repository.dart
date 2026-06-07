import 'package:bourgo_arena_mobile/core/utils/result.dart';
import 'package:bourgo_arena_mobile/domain/core/failure.dart';
import 'package:bourgo_arena_mobile/domain/entities/event.dart';

/// Interface for tournament and event data operations.
abstract interface class EventRepository {
  /// Retrieves the list of published events from GET /events.
  Future<Result<List<Event>, Failure>> getEvents();

  /// Retrieves details for a specific event from GET /events/{id}.
  Future<Result<Event, Failure>> getEventById(String eventId);

  /// Retrieves the bracket matches for a specific event from
  /// GET /events/{id}/bracket.
  Future<Result<List<Match>, Failure>> getEventBracket(String eventId);

  /// Registers the current user in an event via POST /events/{id}/register.
  Future<Result<void, Failure>> registerForEvent(String eventId);
}
