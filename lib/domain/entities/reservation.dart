/// Entity representing a user's booking reservation.
class Reservation {
  /// Unique identifier.
  final String id;

  /// ID of the booked activity.
  final String activityId;

  /// ID of the booked activity slot.
  final String? activitySlotId;

  /// Display title of the activity.
  final String activityTitle;

  /// Date of the reservation (YYYY-MM-DD).
  final String date;

  /// Start time of the reservation (HH:mm).
  final String time;

  /// Duration string (e.g. "1 hour").
  final String? duration;

  /// ISO datetime when reservation starts.
  final String? startsAt;

  /// ISO datetime when reservation ends.
  final String? endsAt;

  /// Total price paid.
  final double price;

  /// Status (confirmed, pending, cancelled).
  final String status;

  /// Payment status (paid, unpaid).
  final String paymentStatus;

  /// QR code string for check-in.
  final String? qrCode;

  /// Optional member id when booking on behalf of a family member.
  final String? memberId;

  /// Creates a new [Reservation] instance.
  const Reservation({
    required this.id,
    required this.activityId,
    this.activitySlotId,
    required this.activityTitle,
    required this.date,
    required this.time,
    this.duration,
    this.startsAt,
    this.endsAt,
    required this.price,
    required this.status,
    required this.paymentStatus,
    this.qrCode,
    this.memberId,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Reservation &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          activityId == other.activityId &&
          activitySlotId == other.activitySlotId &&
          activityTitle == other.activityTitle &&
          date == other.date &&
          time == other.time &&
          price == other.price &&
          status == other.status &&
          paymentStatus == other.paymentStatus &&
          qrCode == other.qrCode &&
          memberId == other.memberId;

  @override
  int get hashCode =>
      id.hashCode ^
      activityId.hashCode ^
      activitySlotId.hashCode ^
      activityTitle.hashCode ^
      date.hashCode ^
      time.hashCode ^
      price.hashCode ^
      status.hashCode ^
      paymentStatus.hashCode ^
      qrCode.hashCode ^
      memberId.hashCode;
}
