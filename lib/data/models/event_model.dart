import 'package:json_annotation/json_annotation.dart';

part 'event_model.g.dart';

/// DTO for a tournament/championship participant.
@JsonSerializable(fieldRename: FieldRename.snake)
class ParticipantModel {
  final String? id;
  final String? name;
  final String? avatarUrl;

  const ParticipantModel({this.id, this.name, this.avatarUrl});

  factory ParticipantModel.fromJson(Map<String, dynamic> json) =>
      _$ParticipantModelFromJson(json);

  Map<String, dynamic> toJson() => _$ParticipantModelToJson(this);
}

/// DTO for a bracket match.
@JsonSerializable(fieldRename: FieldRename.snake)
class MatchModel {
  final String id;
  final int? round;
  final int? matchNumber;
  final String? scheduledAt;
  final String? score;
  final String? status;
  final ParticipantModel? participant1;
  final ParticipantModel? participant2;
  final String? winnerId;
  final String? nextMatchId;

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
  final String id;
  final String? name;
  final String? description;
  final List<String>? images;
  final String? format;
  final int? maxParticipants;
  final int? participantsCount;
  final String? registrationDeadline;
  final String? startDate;
  final String? endDate;
  final String? status;
  final bool? requiresCheckIn;
  final String? createdAt;

  const EventModel({
    required this.id,
    this.name,
    this.description,
    this.images,
    this.format,
    this.maxParticipants,
    this.participantsCount,
    this.registrationDeadline,
    this.startDate,
    this.endDate,
    this.status,
    this.requiresCheckIn,
    this.createdAt,
  });

  factory EventModel.fromJson(Map<String, dynamic> json) =>
      _$EventModelFromJson(json);

  Map<String, dynamic> toJson() => _$EventModelToJson(this);
}
