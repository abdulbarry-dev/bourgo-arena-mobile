import 'package:json_annotation/json_annotation.dart';

part 'reservation_model.g.dart';

/// DTO for reservation data.
@JsonSerializable(fieldRename: FieldRename.snake)
class ReservationModel {
  final String id;
  final String activityId;
  final String? activitySlotId;
  final String activityTitle;
  final String date;
  final String time;
  final String duration;
  final double price;
  final String status;
  final String paymentStatus;
  final String? qrCode;

  const ReservationModel({
    required this.id,
    required this.activityId,
    this.activitySlotId,
    required this.activityTitle,
    required this.date,
    required this.time,
    required this.duration,
    required this.price,
    required this.status,
    required this.paymentStatus,
    this.qrCode,
  });

  factory ReservationModel.fromJson(Map<String, dynamic> json) =>
      _$ReservationModelFromJson(json);

  Map<String, dynamic> toJson() => _$ReservationModelToJson(this);
}
