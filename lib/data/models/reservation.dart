import 'package:json_annotation/json_annotation.dart';

part 'reservation.g.dart';

/// Model representing a user's booking reservation.
@JsonSerializable(fieldRename: FieldRename.snake)
class Reservation {
  /// Unique identifier for the reservation.
  final String id;

  /// ID of the booked activity.
  final String activityId;

  /// Display title of the activity.
  final String activityTitle;

  /// Date of the reservation (YYYY-MM-DD).
  final String date;

  /// Start time of the reservation (HH:mm).
  final String time;

  /// Duration (e.g. 60 min).
  final String duration;

  /// Total price paid.
  final double price;

  /// Status (confirmed, pending, cancelled).
  final String status;

  /// Payment status (paid, unpaid).
  final String paymentStatus;

  /// QR code string for check-in.
  final String qrCode;

  /// Creates a new [Reservation] instance.
  const Reservation({
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

  /// Creates a [Reservation] from JSON.
  factory Reservation.fromJson(Map<String, dynamic> json) =>
      _$ReservationFromJson(json);

  /// Converts a [Reservation] to JSON.
  Map<String, dynamic> toJson() => _$ReservationToJson(this);
}
