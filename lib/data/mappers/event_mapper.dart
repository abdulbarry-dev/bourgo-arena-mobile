import 'package:bourgo_arena_mobile/data/models/event_model.dart';
import 'package:bourgo_arena_mobile/domain/entities/event.dart';

/// Mapper for [EventModel] to [Event] and [MatchModel] to [Match].
class EventMapper {
  /// Converts [ParticipantModel] to [Participant].
  static Participant _toParticipant(ParticipantModel model) {
    return Participant(
      id: model.id,
      name: model.name,
      avatarUrl: model.avatarUrl,
    );
  }

  /// Converts [MatchModel] to [Match].
  static Match toMatch(MatchModel model) {
    return Match(
      id: model.id,
      round: model.round,
      matchNumber: model.matchNumber,
      scheduledAt: model.scheduledAt,
      score: model.score,
      status: model.status,
      participant1: model.participant1 != null
          ? _toParticipant(model.participant1!)
          : null,
      participant2: model.participant2 != null
          ? _toParticipant(model.participant2!)
          : null,
      winnerId: model.winnerId,
      nextMatchId: model.nextMatchId,
    );
  }

  /// Converts [EventModel] to [Event].
  static Event toEntity(EventModel model) {
    return Event(
      id: model.id,
      name: model.name,
      description: model.description,
      format: model.format,
      maxParticipants: model.maxParticipants,
      participantsCount: model.participantsCount,
      registrationDeadline: model.registrationDeadline,
      startDate: model.startDate,
      endDate: model.endDate,
      status: model.status,
      requiresCheckIn: model.requiresCheckIn ?? false,
      createdAt: model.createdAt,
    );
  }
}

/// Extension for convenient mapping of [EventModel] list.
extension EventModelListX on List<EventModel> {
  /// Converts a list of [EventModel] to a list of [Event].
  List<Event> toEntityList() => map(EventMapper.toEntity).toList();
}
