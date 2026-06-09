import 'package:bourgo_arena_mobile/data/models/event_model.dart';
import 'package:bourgo_arena_mobile/domain/entities/event.dart';

class EventMapper {
  static Participant _toParticipant(ParticipantModel model) {
    return Participant(
      id: model.id,
      name: model.name ?? model.user?.name,
      initials: model.initials ?? model.user?.initials,
      avatarUrl: model.avatarUrl,
    );
  }

  static Match toMatch(MatchModel model) {
    return Match(
      id: model.id,
      round: model.round,
      matchNumber: model.matchNumber,
      scheduledAt: model.scheduledAt,
      score: model.score,
      status: model.status,
      participant1:
          model.participant1 != null ? _toParticipant(model.participant1!) : null,
      participant2:
          model.participant2 != null ? _toParticipant(model.participant2!) : null,
      winnerId: model.winnerId,
      nextMatchId: model.nextMatchId,
    );
  }

  static Event toEntity(EventModel model) {
    return Event(
      id: model.id,
      name: model.name,
      description: model.description,
      sportType: model.sportType,
      format: model.format,
      maxParticipants: model.maxParticipants,
      participantsCount: model.participantsCount,
      registrationDeadline: model.registrationDeadline,
      startDate: model.startDate,
      endDate: model.endDate,
      images: model.images ?? const [],
      imageUrl: model.imageUrl ?? (model.images?.isNotEmpty == true ? model.images!.first : null),
      status: model.status,
      requiresCheckIn: model.requiresCheckIn ?? false,
      createdAt: model.createdAt,
    );
  }

  static EventParticipant toParticipantEntity(EventParticipantModel model) {
    return EventParticipant(
      id: model.id,
      eventId: model.eventId,
      user: model.user != null
          ? ParticipantUser(
              id: model.user!.id,
              name: model.user!.name,
              initials: model.user!.initials,
            )
          : null,
      seedNumber: model.seedNumber,
      status: model.status,
      hasCheckedIn: model.hasCheckedIn ?? false,
      registeredAt: model.registeredAt,
      event: model.event != null ? toEntity(model.event!) : null,
    );
  }
}

extension EventModelListX on List<EventModel> {
  List<Event> toEntityList() => map(EventMapper.toEntity).toList();
}

extension EventParticipantModelListX on List<EventParticipantModel> {
  List<EventParticipant> toEntityList() =>
      map(EventMapper.toParticipantEntity).toList();
}
