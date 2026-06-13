import 'package:bourgo_arena_mobile/core/utils/result.dart';
import 'package:bourgo_arena_mobile/domain/core/failure.dart';
import 'package:bourgo_arena_mobile/domain/entities/bracket.dart';
import 'package:bourgo_arena_mobile/domain/entities/event.dart';

abstract interface class EventRepository {
  Future<Result<List<Event>, Failure>> getEvents({
    String? sportType,
    int page = 1,
  });
  Future<Result<Event, Failure>> getEventById(String eventId);
  Future<Result<List<BracketRound>, Failure>> getEventBracket(String eventId);
  Future<Result<RegistrationResult, Failure>> registerForEvent(
    String eventId, {
    String? childId,
  });
  Future<Result<List<EventParticipant>, Failure>> getMyEvents();
  Future<Result<List<EventParticipant>, Failure>> getAccountRegistrations();
  Future<Result<void, Failure>> withdrawFromEvent(
    String eventId, {
    String? childId,
  });
  Future<Result<void, Failure>> checkInToEvent(
    String eventId, {
    String? childId,
  });
}
