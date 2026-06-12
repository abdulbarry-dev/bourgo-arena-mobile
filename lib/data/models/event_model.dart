import 'package:json_annotation/json_annotation.dart';

part 'event_model.g.dart';

/// DTO for a participant user (from bracket / my-events responses).
@JsonSerializable(fieldRename: FieldRename.snake)
class ParticipantUserModel {
  final int? id;
  final String? name;
  final String? initials;

  const ParticipantUserModel({this.id, this.name, this.initials});

  factory ParticipantUserModel.fromJson(Map<String, dynamic> json) =>
      _$ParticipantUserModelFromJson(json);

  Map<String, dynamic> toJson() => _$ParticipantUserModelToJson(this);
}

/// DTO for a tournament/championship participant.
@JsonSerializable(fieldRename: FieldRename.snake)
class ParticipantModel {
  final int? id;
  final String? name;
  final String? avatarUrl;
  final String? initials;
  final ParticipantUserModel? user;

  const ParticipantModel({
    this.id,
    this.name,
    this.avatarUrl,
    this.initials,
    this.user,
  });

  factory ParticipantModel.fromJson(Map<String, dynamic> json) =>
      _$ParticipantModelFromJson(json);

  Map<String, dynamic> toJson() => _$ParticipantModelToJson(this);
}

/// DTO for a bracket match.
@JsonSerializable(fieldRename: FieldRename.snake)
class MatchModel {
  final int id;
  final int? round;
  final int? matchNumber;
  final String? scheduledAt;
  final String? score;
  final String? status;
  final ParticipantModel? participant1;
  final ParticipantModel? participant2;
  final int? winnerId;
  final int? nextMatchId;

  const MatchModel({
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

  factory MatchModel.fromJson(Map<String, dynamic> json) =>
      _$MatchModelFromJson(json);

  Map<String, dynamic> toJson() => _$MatchModelToJson(this);
}

/// DTO for an event/tournament matching EventResource.
@JsonSerializable(fieldRename: FieldRename.snake)
class EventModel {
  @JsonKey(fromJson: _idToString)
  final String id;
  final String? name;
  final String? description;
  final String? sportType;
  final List<String>? images;
  final String? imageUrl;
  final String? format;
  final int? maxParticipants;
  final int? participantsCount;
  final String? registrationDeadline;
  final String? startDate;
  final String? endDate;
  final String? status;
  final bool? requiresCheckIn;
  @JsonKey(defaultValue: false)
  final bool isRegistered;
  final String? createdAt;

  const EventModel({
    required this.id,
    this.name,
    this.description,
    this.sportType,
    this.images,
    this.imageUrl,
    this.format,
    this.maxParticipants,
    this.participantsCount,
    this.registrationDeadline,
    this.startDate,
    this.endDate,
    this.status,
    this.requiresCheckIn,
    this.isRegistered = false,
    this.createdAt,
  });

  factory EventModel.fromJson(Map<String, dynamic> json) =>
      _$EventModelFromJson(json);

  Map<String, dynamic> toJson() => _$EventModelToJson(this);

  static String _idToString(dynamic id) => id.toString();
}

/// DTO for a registered event participant (from GET /user/events).
@JsonSerializable(fieldRename: FieldRename.snake)
class EventParticipantModel {
  final int id;
  @JsonKey(fromJson: _idToString)
  final String eventId;
  final ParticipantUserModel? user;
  final int? seedNumber;
  final String? status;
  final bool? hasCheckedIn;
  final String? registeredAt;
  final EventModel? event;

  const EventParticipantModel({
    required this.id,
    required this.eventId,
    this.user,
    this.seedNumber,
    this.status,
    this.hasCheckedIn,
    this.registeredAt,
    this.event,
  });

  factory EventParticipantModel.fromJson(Map<String, dynamic> json) =>
      _$EventParticipantModelFromJson(json);

  Map<String, dynamic> toJson() => _$EventParticipantModelToJson(this);

  static String _idToString(dynamic id) => id.toString();
}
