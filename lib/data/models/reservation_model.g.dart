// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reservation_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReservationActivityModel _$ReservationActivityModelFromJson(
  Map<String, dynamic> json,
) => ReservationActivityModel(
  id: json['id'] as String,
  title: json['title'] as String?,
  imageUrl: json['image_url'] as String?,
  icon: json['icon'] as String?,
  category: json['category'] as String?,
);

Map<String, dynamic> _$ReservationActivityModelToJson(
  ReservationActivityModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'image_url': instance.imageUrl,
  'icon': instance.icon,
  'category': instance.category,
};

ReservationSlotModel _$ReservationSlotModelFromJson(
  Map<String, dynamic> json,
) => ReservationSlotModel(
  id: (json['id'] as num?)?.toInt(),
  time: json['time'] as String?,
  startTime: json['start_time'] as String?,
  endTime: json['end_time'] as String?,
);

Map<String, dynamic> _$ReservationSlotModelToJson(
  ReservationSlotModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'time': instance.time,
  'start_time': instance.startTime,
  'end_time': instance.endTime,
};

ReservationModel _$ReservationModelFromJson(Map<String, dynamic> json) =>
    ReservationModel(
      id: json['id'] as String,
      memberId: json['member_id'] as String?,
      activityId: json['activity_id'] as String?,
      activitySlotId: json['activity_slot_id'] as String?,
      activityTitle: json['activity_title'] as String?,
      date: json['date'] as String?,
      time: json['time'] as String?,
      duration: json['duration'] as String?,
      startsAt: json['starts_at'] as String?,
      endsAt: json['ends_at'] as String?,
      price: (json['price'] as num?)?.toDouble(),
      status: json['status'] as String?,
      paymentStatus: json['payment_status'] as String?,
      qrCode: json['qr_code'] as String?,
      activity: json['activity'] == null
          ? null
          : ReservationActivityModel.fromJson(
              json['activity'] as Map<String, dynamic>,
            ),
      slot: json['slot'] == null
          ? null
          : ReservationSlotModel.fromJson(json['slot'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ReservationModelToJson(ReservationModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'member_id': instance.memberId,
      'activity_id': instance.activityId,
      'activity_slot_id': instance.activitySlotId,
      'activity_title': instance.activityTitle,
      'date': instance.date,
      'time': instance.time,
      'duration': instance.duration,
      'starts_at': instance.startsAt,
      'ends_at': instance.endsAt,
      'price': instance.price,
      'status': instance.status,
      'payment_status': instance.paymentStatus,
      'qr_code': instance.qrCode,
      'activity': instance.activity,
      'slot': instance.slot,
    };
