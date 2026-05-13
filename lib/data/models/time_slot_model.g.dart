// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'time_slot_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TimeSlotModel _$TimeSlotModelFromJson(Map<String, dynamic> json) =>
    TimeSlotModel(
      slotId: json['slot_id'] as String,
      time: json['time'] as String,
      available: json['available'] as bool,
    );

Map<String, dynamic> _$TimeSlotModelToJson(TimeSlotModel instance) =>
    <String, dynamic>{
      'slot_id': instance.slotId,
      'time': instance.time,
      'available': instance.available,
    };
