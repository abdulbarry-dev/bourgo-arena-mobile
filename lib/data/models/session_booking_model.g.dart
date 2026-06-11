// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'session_booking_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SessionBookingModel _$SessionBookingModelFromJson(Map<String, dynamic> json) =>
    SessionBookingModel(
      id: json['id'] as String,
      sessionId: json['session_id'] as String,
      status: json['status'] as String,
      bookedAt: DateTime.parse(json['booked_at'] as String),
    );

Map<String, dynamic> _$SessionBookingModelToJson(
  SessionBookingModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'session_id': instance.sessionId,
  'status': instance.status,
  'booked_at': instance.bookedAt.toIso8601String(),
};
