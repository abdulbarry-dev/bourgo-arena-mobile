import 'package:bourgo_arena_mobile/domain/entities/reservation.dart';
import 'package:json_annotation/json_annotation.dart';

part 'reservation_model.g.dart';

/// DTO for reservation data.
@JsonSerializable(fieldRename: FieldRename.snake)
class ReservationModel {
  final String id;
  final String activityId;
  final String activityTitle;
  final String date;
  final String time;
  final String duration;
  final double price;
  final String status;
  final String paymentStatus;
  final String qrCode;

  const ReservationModel({
    required this.id,
    required this.activityId,
    required this.activityTitle,
    required this.date,
    required this.time,
    required this.duration,
    required this.price,
    required this.status,
    required this.paymentStatus,
    required this.qrCode,
  });

  /// Converts this model to a pure domain entity.
  Reservation toEntity() {
    return Reservation(
      id: id,
      activityId: activityId,
      activityTitle: activityTitle,
      date: date,
      time: time,
      duration: duration,
      price: price,
      status: status,
      paymentStatus: paymentStatus,
      qrCode: qrCode,
    );
  }

  /// Creates a model from a domain entity.
  factory ReservationModel.fromEntity(Reservation entity) {
    return ReservationModel(
      id: entity.id,
      activityId: entity.activityId,
      activityTitle: entity.activityTitle,
      date: entity.date,
      time: entity.time,
      duration: entity.duration,
      price: entity.price,
      status: entity.status,
      paymentStatus: entity.paymentStatus,
      qrCode: entity.qrCode,
    );
  }

  factory ReservationModel.fromJson(Map<String, dynamic> json) =>
      _$ReservationModelFromJson(json);

  Map<String, dynamic> toJson() => _$ReservationModelToJson(this);
}
