// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'schedule_item_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ScheduleItemModel _$ScheduleItemModelFromJson(Map<String, dynamic> json) =>
    ScheduleItemModel(
      type: json['type'] as String,
      typeLabel: json['type_label'] as String,
      id: json['id'] as String,
      date: json['date'] as String?,
      name: json['name'] as String?,
      startTime: json['start_time'] as String?,
      durationMinutes: (json['duration_minutes'] as num?)?.toInt(),
      status: json['status'] as String?,
      statusLabel: json['status_label'] as String?,
      isCompleted: json['is_completed'] as bool?,
    );

Map<String, dynamic> _$ScheduleItemModelToJson(ScheduleItemModel instance) =>
    <String, dynamic>{
      'type': instance.type,
      'type_label': instance.typeLabel,
      'id': instance.id,
      'date': instance.date,
      'name': instance.name,
      'start_time': instance.startTime,
      'duration_minutes': instance.durationMinutes,
      'status': instance.status,
      'status_label': instance.statusLabel,
      'is_completed': instance.isCompleted,
    };
