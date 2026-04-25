// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reservation.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Reservation _$ReservationFromJson(Map<String, dynamic> json) => Reservation(
  id: json['id'] as String,
  activityId: json['activity_id'] as String,
  activityTitle: json['activity_title'] as String,
  date: json['date'] as String,
  time: json['time'] as String,
  duration: json['duration'] as String,
  price: (json['price'] as num).toDouble(),
  status: json['status'] as String,
  paymentStatus: json['payment_status'] as String,
  qrCode: json['qr_code'] as String,
);

Map<String, dynamic> _$ReservationToJson(Reservation instance) =>
    <String, dynamic>{
      'id': instance.id,
      'activity_id': instance.activityId,
      'activity_title': instance.activityTitle,
      'date': instance.date,
      'time': instance.time,
      'duration': instance.duration,
      'price': instance.price,
      'status': instance.status,
      'payment_status': instance.paymentStatus,
      'qr_code': instance.qrCode,
    };
