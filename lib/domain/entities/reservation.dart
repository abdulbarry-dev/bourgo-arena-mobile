/// Pure domain entity representing a user's booking reservation.
class Reservation {
  /// Unique identifier.
  final String id;

  /// ID of the booked activity.
  final String activityId;

  /// Display title of the activity.
  final String activityTitle;

  /// Date of the reservation (YYYY-MM-DD).
  final String date;

  /// Start time of the reservation (HH:mm).
  final String time;

  /// Duration.
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
}
