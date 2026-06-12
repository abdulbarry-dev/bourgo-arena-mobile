/// Entity representing a participant user.
class ParticipantUser {
  final int? id;
  final String? name;
  final String? initials;

  const ParticipantUser({this.id, this.name, this.initials});
}

/// Entity representing a tournament participant.
class Participant {
  final int? id;
  final String? name;
  final String? avatarUrl;
  final String? initials;

  const Participant({this.id, this.name, this.avatarUrl, this.initials});
}

/// Entity representing a bracket match.
class Match {
  final int id;
  final int? round;
  final int? matchNumber;
  final String? scheduledAt;
  final String? score;
  final String? status;
  final Participant? participant1;
  final Participant? participant2;
  final int? winnerId;
  final int? nextMatchId;

  const Match({
    required this.id,
    this.round,
    this.matchNumber,
    this.scheduledAt,
    this.score,
    this.status,
    this.participant1,
    this.participant2,
    this.winnerId,
    this.nextMatchId,
  });
}

/// Pure domain entity representing a tournament or championship event.
class Event {
  final String id;
  final String? name;
  final String? description;
  final String? sportType;
  final String? format;
  final int? maxParticipants;
  final int? participantsCount;
  final String? registrationDeadline;
  final String? startDate;
  final String? endDate;
  final List<String> images;
  final String? imageUrl;
  final String? status;
  final bool requiresCheckIn;
  final bool isRegistered;
  final String? createdAt;

  const Event({
    required this.id,
    this.name,
    this.description,
    this.sportType,
    this.format,
    this.maxParticipants,
    this.participantsCount,
    this.registrationDeadline,
    this.startDate,
    this.endDate,
    this.images = const [],
    this.imageUrl,
    this.status,
    this.requiresCheckIn = false,
    this.isRegistered = false,
    this.createdAt,
  });

  bool get isRegistrationOpen => status == 'open';
}

/// Entity representing a registered event participant (from GET /user/events).
class EventParticipant {
  final int id;
  final String eventId;
  final ParticipantUser? user;
  final int? seedNumber;
  final String? status;
  final bool hasCheckedIn;
  final String? registeredAt;
  final Event? event;

  const EventParticipant({
    required this.id,
    required this.eventId,
    this.user,
    this.seedNumber,
    this.status,
    this.hasCheckedIn = false,
    this.registeredAt,
    this.event,
  });

  bool get isApproved => status == 'approved';
  bool get isPending => status == 'pending';
  bool get isWaitlisted => status == 'waitlisted';
}

/// Result of registering for an event.
class RegistrationResult {
  final String status;

  const RegistrationResult({required this.status});

  bool get isRegistered => status == 'pending' || status == 'approved';
  bool get isWaitlisted => status == 'waitlisted';
}
