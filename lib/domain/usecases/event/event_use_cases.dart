import 'package:bourgo_arena_mobile/core/utils/result.dart';
import 'package:bourgo_arena_mobile/domain/core/failure.dart';
import 'package:bourgo_arena_mobile/domain/entities/event.dart';
import 'package:bourgo_arena_mobile/domain/repositories/event_repository.dart';

class GetEventsUseCase {
  final EventRepository _repository;
  const GetEventsUseCase(this._repository);

  Future<Result<List<Event>, Failure>> call({
    String? sportType,
    int page = 1,
  }) => _repository.getEvents(sportType: sportType, page: page);
}

class GetEventByIdUseCase {
  final EventRepository _repository;
  const GetEventByIdUseCase(this._repository);

  Future<Result<Event, Failure>> call(String eventId) =>
      _repository.getEventById(eventId);
}

class GetEventBracketUseCase {
  final EventRepository _repository;
  const GetEventBracketUseCase(this._repository);

  Future<Result<Map<String, dynamic>, Failure>> call(String eventId) =>
      _repository.getEventBracket(eventId);
}

class RegisterForEventUseCase {
  final EventRepository _repository;
  const RegisterForEventUseCase(this._repository);

  Future<Result<RegistrationResult, Failure>> call(String eventId) =>
      _repository.registerForEvent(eventId);
}

class WithdrawFromEventUseCase {
  final EventRepository _repository;
  const WithdrawFromEventUseCase(this._repository);

  Future<Result<void, Failure>> call(String eventId) =>
      _repository.withdrawFromEvent(eventId);
}

class CheckInToEventUseCase {
  final EventRepository _repository;
  const CheckInToEventUseCase(this._repository);

  Future<Result<void, Failure>> call(String eventId) =>
      _repository.checkInToEvent(eventId);
}
