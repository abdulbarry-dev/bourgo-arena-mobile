import 'package:json_annotation/json_annotation.dart';

part 'reservation_model.g.dart';

/// DTO for a nested activity within a reservation.
@JsonSerializable(fieldRename: FieldRename.snake)
class ReservationActivityModel {
  final String id;
  final String? title;
  final String? imageUrl;
  final String? icon;
  final String? category;

  const ReservationActivityModel({
    required this.id,
    this.title,
    this.imageUrl,
    this.icon,
    this.category,
  });

  factory ReservationActivityModel.fromJson(Map<String, dynamic> json) =>
      _$ReservationActivityModelFromJson(json);

  Map<String, dynamic> toJson() => _$ReservationActivityModelToJson(this);
}

/// DTO for a nested slot within a reservation.
@JsonSerializable(fieldRename: FieldRename.snake)
class ReservationSlotModel {
  final int? id;
  final String? time;
  final String? startTime;
  final String? endTime;

  const ReservationSlotModel({
    this.id,
    this.time,
    this.startTime,
    this.endTime,
  });

  factory ReservationSlotModel.fromJson(Map<String, dynamic> json) =>
      _$ReservationSlotModelFromJson(json);

  Map<String, dynamic> toJson() => _$ReservationSlotModelToJson(this);
}

/// DTO for reservation data matching ApiReservationResource.
@JsonSerializable(fieldRename: FieldRename.snake)
class ReservationModel {
  final String id;
  final String? memberId;
  final String? activityId;
  final String? activitySlotId;
  final String? activityTitle;
  final String? date;
  final String? time;
  final String? duration;
  final String? startsAt;
  final String? endsAt;
  final double? price;
  final String? status;
  final String? paymentStatus;
  final String? qrCode;
  final ReservationActivityModel? activity;
  final ReservationSlotModel? slot;

  const ReservationModel({
    required this.id,
    this.memberId,
    this.activityId,
    this.activitySlotId,
    this.activityTitle,
    this.date,
    this.time,
    this.duration,
    this.startsAt,
    this.endsAt,
    this.price,
    this.status,
    this.paymentStatus,
    this.qrCode,
    this.activity,
    this.slot,
  });

  factory ReservationModel.fromJson(Map<String, dynamic> json) =>
      _$ReservationModelFromJson(json);

  Map<String, dynamic> toJson() => _$ReservationModelToJson(this);
}
