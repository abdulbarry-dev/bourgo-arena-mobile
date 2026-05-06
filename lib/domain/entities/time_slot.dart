/// Entity representing an available time slot for booking.
class TimeSlot {
  /// Time string (e.g. 18:00).
  final String time;

  /// Whether the slot is currently available for booking.
  final bool available;

  /// Creates a new [TimeSlot] instance.
  const TimeSlot({required this.time, required this.available});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TimeSlot &&
          runtimeType == other.runtimeType &&
          time == other.time &&
          available == other.available;

  @override
  int get hashCode => time.hashCode ^ available.hashCode;
}
