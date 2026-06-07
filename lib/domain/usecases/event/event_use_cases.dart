import 'package:bourgo_arena_mobile/core/utils/result.dart';
import 'package:bourgo_arena_mobile/domain/core/failure.dart';
import 'package:bourgo_arena_mobile/domain/entities/event.dart';
import 'package:bourgo_arena_mobile/domain/repositories/event_repository.dart';

/// Returns the list of published tournament events.
class GetEventsUseCase {
  final EventRepository _repository;

  /// Creates a new [GetEventsUseCase].
  const GetEventsUseCase(this._repository);

  /// Executes the use case.
  Future<Result<List<Event>, Failure>> call() => _repository.getEvents();
}

/// Returns the details for a single event.
class GetEventByIdUseCase {
  final EventRepository _repository;

  /// Creates a new [GetEventByIdUseCase].
  const GetEventByIdUseCase(this._repository);

  /// Executes the use case for [eventId].
  Future<Result<Event, Failure>> call(String eventId) =>
      _repository.getEventById(eventId);
}

/// Returns the bracket matches for an event.
class GetEventBracketUseCase {
  final EventRepository _repository;

  /// Creates a new [GetEventBracketUseCase].
  const GetEventBracketUseCase(this._repository);

  /// Executes the use case for [eventId].
  Future<Result<List<Match>, Failure>> call(String eventId) =>
      _repository.getEventBracket(eventId);
}

/// Registers the current member for an event.
class RegisterForEventUseCase {
  final EventRepository _repository;

  /// Creates a new [RegisterForEventUseCase].
  const RegisterForEventUseCase(this._repository);

  /// Executes the use case for [eventId].
  Future<Result<void, Failure>> call(String eventId) =>
      _repository.registerForEvent(eventId);
}
