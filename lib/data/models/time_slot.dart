import 'package:json_annotation/json_annotation.dart';

part 'time_slot.g.dart';

/// Model representing an available time slot for booking.
@JsonSerializable(fieldRename: FieldRename.snake)
class TimeSlot {
  /// Time string (e.g. 18:00).
  final String time;

  /// Whether the slot is currently available for booking.
  final bool available;

  /// Creates a new [TimeSlot] instance.
  const TimeSlot({required this.time, required this.available});

  /// Creates a [TimeSlot] from JSON.
  factory TimeSlot.fromJson(Map<String, dynamic> json) =>
      _$TimeSlotFromJson(json);

  /// Converts a [TimeSlot] to JSON.
  Map<String, dynamic> toJson() => _$TimeSlotToJson(this);
}
