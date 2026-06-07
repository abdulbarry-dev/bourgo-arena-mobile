// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'course_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CourseModel _$CourseModelFromJson(Map<String, dynamic> json) => CourseModel(
  id: json['id'] as String,
  name: json['name'] as String?,
  title: json['title'] as String?,
  description: json['description'] as String?,
  category: json['category'] as String?,
  imageUrl: json['image_url'] as String?,
  images: (json['images'] as List<dynamic>?)?.map((e) => e as String).toList(),
  status: json['status'] as String?,
  instructor: json['instructor'] as String?,
  startTime: json['start_time'] as String?,
  endTime: json['end_time'] as String?,
  dayOfWeek: (json['day_of_week'] as num?)?.toInt(),
  capacity: (json['capacity'] as num?)?.toInt(),
  enrolled: (json['enrolled'] as num?)?.toInt(),
  icon: json['icon'] as String?,
);

Map<String, dynamic> _$CourseModelToJson(CourseModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'title': instance.title,
      'description': instance.description,
      'category': instance.category,
      'image_url': instance.imageUrl,
      'images': instance.images,
      'status': instance.status,
      'instructor': instance.instructor,
      'start_time': instance.startTime,
      'end_time': instance.endTime,
      'day_of_week': instance.dayOfWeek,
      'capacity': instance.capacity,
      'enrolled': instance.enrolled,
      'icon': instance.icon,
    };
