/// Entity representing an available time slot for booking.
class TimeSlot {
  /// Unique slot identifier.
  final String? id;

  /// Display time string (e.g. "18:00").
  final String time;

  /// Whether the slot is currently available for booking.
  final bool available;

  /// Slot start time in HH:mm:ss format (from API).
  final String? startTime;

  /// Slot end time in HH:mm:ss format (from API).
  final String? endTime;

  /// Maximum number of bookings allowed.
  final int? capacity;

  /// Number of confirmed bookings.
  final int? bookedCount;

  /// True when all spots are taken.
  final bool isFullyBooked;

  /// Creates a new [TimeSlot] instance.
  const TimeSlot({
    this.id,
    required this.time,
    required this.available,
    this.startTime,
    this.endTime,
    this.capacity,
    this.bookedCount,
    this.isFullyBooked = false,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TimeSlot &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          time == other.time &&
          available == other.available;

  @override
  int get hashCode => id.hashCode ^ time.hashCode ^ available.hashCode;
}
