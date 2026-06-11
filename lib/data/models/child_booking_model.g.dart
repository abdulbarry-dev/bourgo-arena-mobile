// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'child_booking_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChildBookingModel _$ChildBookingModelFromJson(Map<String, dynamic> json) =>
    ChildBookingModel(
      id: ChildBookingModel._idToString(json['id']),
      sessionId: ChildBookingModel._idToString(json['session_id']),
      courseId: ChildBookingModel._idToString(json['course_id']),
      courseName: json['course_name'] as String?,
      date: json['date'] as String?,
      startTime: json['start_time'] as String?,
      endTime: json['end_time'] as String?,
      status: json['status'] as String?,
      completedAt: json['completed_at'] as String?,
    );

Map<String, dynamic> _$ChildBookingModelToJson(ChildBookingModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'session_id': instance.sessionId,
      'course_id': instance.courseId,
      'course_name': instance.courseName,
      'date': instance.date,
      'start_time': instance.startTime,
      'end_time': instance.endTime,
      'status': instance.status,
      'completed_at': instance.completedAt,
    };
