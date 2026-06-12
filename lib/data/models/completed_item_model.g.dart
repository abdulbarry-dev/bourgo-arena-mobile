// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'completed_item_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CompletedItemModel _$CompletedItemModelFromJson(Map<String, dynamic> json) =>
    CompletedItemModel(
      type: json['type'] as String,
      typeLabel: json['type_label'] as String?,
      id: json['id'] as String,
      date: json['date'] as String?,
      courseName: json['course_name'] as String?,
      activityTitle: json['activity_title'] as String?,
      status: json['status'] as String?,
      completedAt: json['completed_at'] as String?,
    );

Map<String, dynamic> _$CompletedItemModelToJson(CompletedItemModel instance) =>
    <String, dynamic>{
      'type': instance.type,
      'type_label': instance.typeLabel,
      'id': instance.id,
      'date': instance.date,
      'course_name': instance.courseName,
      'activity_title': instance.activityTitle,
      'status': instance.status,
      'completed_at': instance.completedAt,
    };
