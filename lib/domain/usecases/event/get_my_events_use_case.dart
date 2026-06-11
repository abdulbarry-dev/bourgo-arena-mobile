import 'package:bourgo_arena_mobile/core/utils/result.dart';
import 'package:bourgo_arena_mobile/domain/core/failure.dart';
import 'package:bourgo_arena_mobile/domain/entities/event.dart';
import 'package:bourgo_arena_mobile/domain/repositories/event_repository.dart';

/// Use case for fetching the list of events the current user is participating in.
class GetMyEventsUseCase {
  final EventRepository _repository;

  /// Creates a new [GetMyEventsUseCase].
  const GetMyEventsUseCase(this._repository);

  /// Executes the use case.
  Future<Result<List<EventParticipant>, Failure>> call() =>
      _repository.getMyEvents();
}
