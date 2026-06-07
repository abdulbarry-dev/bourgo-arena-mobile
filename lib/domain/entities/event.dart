/// Entity representing a tournament participant.
class Participant {
  final String? id;
  final String? name;
  final String? avatarUrl;

  const Participant({this.id, this.name, this.avatarUrl});
}

/// Entity representing a bracket match.
class Match {
  final String id;
  final int? round;
  final int? matchNumber;
  final String? scheduledAt;
  final String? score;
  final String? status;
  final Participant? participant1;
  final Participant? participant2;
  final String? winnerId;
  final String? nextMatchId;

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
  /// Unique identifier.
  final String id;

  /// Event name.
  final String? name;

  /// Description.
  final String? description;

  /// Format (single_elimination, round_robin, etc.).
  final String? format;

  /// Maximum number of participants.
  final int? maxParticipants;

  /// Current number of registered participants.
  final int? participantsCount;

  /// Registration deadline (ISO datetime).
  final String? registrationDeadline;

  /// Start date (ISO datetime).
  final String? startDate;

  /// End date (ISO datetime).
  final String? endDate;

  /// Status (published, ongoing, completed).
  final String? status;

  /// Whether participants need to check in.
  final bool requiresCheckIn;

  /// ISO datetime of creation.
  final String? createdAt;

  /// Creates a new [Event] instance.
  const Event({
    required this.id,
    this.name,
    this.description,
    this.format,
    this.maxParticipants,
    this.participantsCount,
    this.registrationDeadline,
    this.startDate,
    this.endDate,
    this.status,
    this.requiresCheckIn = false,
    this.createdAt,
  });

  /// True if registration is still open.
  bool get isRegistrationOpen => status == 'published';
}
