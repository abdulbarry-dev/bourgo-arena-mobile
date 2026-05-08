// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'course_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CourseModel _$CourseModelFromJson(Map<String, dynamic> json) => CourseModel(
  id: json['id'] as String,
  title: json['title'] as String,
  instructor: json['instructor'] as String,
  startTime: json['start_time'] as String,
  endTime: json['end_time'] as String,
  dayOfWeek: (json['day_of_week'] as num).toInt(),
  category: json['category'] as String,
  capacity: (json['capacity'] as num).toInt(),
  enrolled: (json['enrolled'] as num).toInt(),
  icon: json['icon'] as String,
);

Map<String, dynamic> _$CourseModelToJson(CourseModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'instructor': instance.instructor,
      'start_time': instance.startTime,
      'end_time': instance.endTime,
      'day_of_week': instance.dayOfWeek,
      'category': instance.category,
      'capacity': instance.capacity,
      'enrolled': instance.enrolled,
      'icon': instance.icon,
    };
