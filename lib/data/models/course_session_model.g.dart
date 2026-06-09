// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'course_session_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CourseSessionModel _$CourseSessionModelFromJson(Map<String, dynamic> json) =>
    CourseSessionModel(
      id: json['id'] as String,
      title: json['title'] as String?,
      startTime: json['start_time'] as String?,
      endTime: json['end_time'] as String?,
      dayOfWeek: (json['day_of_week'] as num?)?.toInt(),
      capacity: (json['capacity'] as num?)?.toInt(),
      enrolled: (json['enrolled'] as num?)?.toInt(),
      imageUrl: json['image_url'] as String?,
      isBooked: json['is_booked'] as bool?,
    );

Map<String, dynamic> _$CourseSessionModelToJson(CourseSessionModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'start_time': instance.startTime,
      'end_time': instance.endTime,
      'day_of_week': instance.dayOfWeek,
      'capacity': instance.capacity,
      'enrolled': instance.enrolled,
      'image_url': instance.imageUrl,
      'is_booked': instance.isBooked,
    };
