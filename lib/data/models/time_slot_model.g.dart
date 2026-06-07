// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'time_slot_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TimeSlotModel _$TimeSlotModelFromJson(Map<String, dynamic> json) =>
    TimeSlotModel(
      id: json['id'] as String?,
      time: json['time'] as String?,
      available: json['available'] as bool?,
      startTime: json['start_time'] as String?,
      endTime: json['end_time'] as String?,
      capacity: (json['capacity'] as num?)?.toInt(),
      bookedCount: (json['booked_count'] as num?)?.toInt(),
      isAvailable: json['is_available'] as bool?,
      isFullyBooked: json['is_fully_booked'] as bool?,
    );

Map<String, dynamic> _$TimeSlotModelToJson(TimeSlotModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'time': instance.time,
      'available': instance.available,
      'start_time': instance.startTime,
      'end_time': instance.endTime,
      'capacity': instance.capacity,
      'booked_count': instance.bookedCount,
      'is_available': instance.isAvailable,
      'is_fully_booked': instance.isFullyBooked,
    };
