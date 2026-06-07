// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ParticipantModel _$ParticipantModelFromJson(Map<String, dynamic> json) =>
    ParticipantModel(
      id: json['id'] as String?,
      name: json['name'] as String?,
      avatarUrl: json['avatar_url'] as String?,
    );

Map<String, dynamic> _$ParticipantModelToJson(ParticipantModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'avatar_url': instance.avatarUrl,
    };

MatchModel _$MatchModelFromJson(Map<String, dynamic> json) => MatchModel(
  id: json['id'] as String,
  round: (json['round'] as num?)?.toInt(),
  matchNumber: (json['match_number'] as num?)?.toInt(),
  scheduledAt: json['scheduled_at'] as String?,
  score: json['score'] as String?,
  status: json['status'] as String?,
  participant1: json['participant1'] == null
      ? null
      : ParticipantModel.fromJson(json['participant1'] as Map<String, dynamic>),
  participant2: json['participant2'] == null
      ? null
      : ParticipantModel.fromJson(json['participant2'] as Map<String, dynamic>),
  winnerId: json['winner_id'] as String?,
  nextMatchId: json['next_match_id'] as String?,
);

Map<String, dynamic> _$MatchModelToJson(MatchModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'round': instance.round,
      'match_number': instance.matchNumber,
      'scheduled_at': instance.scheduledAt,
      'score': instance.score,
      'status': instance.status,
      'participant1': instance.participant1,
      'participant2': instance.participant2,
      'winner_id': instance.winnerId,
      'next_match_id': instance.nextMatchId,
    };

EventModel _$EventModelFromJson(Map<String, dynamic> json) => EventModel(
  id: json['id'] as String,
  name: json['name'] as String?,
  description: json['description'] as String?,
  images: (json['images'] as List<dynamic>?)?.map((e) => e as String).toList(),
  format: json['format'] as String?,
  maxParticipants: (json['max_participants'] as num?)?.toInt(),
  participantsCount: (json['participants_count'] as num?)?.toInt(),
  registrationDeadline: json['registration_deadline'] as String?,
  startDate: json['start_date'] as String?,
  endDate: json['end_date'] as String?,
  status: json['status'] as String?,
  requiresCheckIn: json['requires_check_in'] as bool?,
  createdAt: json['created_at'] as String?,
);

Map<String, dynamic> _$EventModelToJson(EventModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'images': instance.images,
      'format': instance.format,
      'max_participants': instance.maxParticipants,
      'participants_count': instance.participantsCount,
      'registration_deadline': instance.registrationDeadline,
      'start_date': instance.startDate,
      'end_date': instance.endDate,
      'status': instance.status,
      'requires_check_in': instance.requiresCheckIn,
      'created_at': instance.createdAt,
    };
