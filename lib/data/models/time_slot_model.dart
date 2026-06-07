import 'package:json_annotation/json_annotation.dart';

part 'time_slot_model.g.dart';

/// DTO for an available activity time slot matching ActivitySlotResource.
@JsonSerializable(fieldRename: FieldRename.snake)
class TimeSlotModel {
  /// Unique slot identifier.
  final String? id;

  /// Display time string (e.g. "18:00").
  final String? time;

  /// Whether the slot is available (legacy field).
  final bool? available;

  /// Slot start time in HH:mm:ss format.
  final String? startTime;

  /// Slot end time in HH:mm:ss format.
  final String? endTime;

  /// Maximum number of bookings for this slot.
  final int? capacity;

  /// Number of confirmed bookings.
  final int? bookedCount;

  /// Convenience alias: true when available (from API).
  final bool? isAvailable;

  /// True when all spots are taken.
  final bool? isFullyBooked;

  /// Creates a new [TimeSlotModel] instance.
  const TimeSlotModel({
    this.id,
    this.time,
    this.available,
    this.startTime,
    this.endTime,
    this.capacity,
    this.bookedCount,
    this.isAvailable,
    this.isFullyBooked,
  });

  /// Creates a [TimeSlotModel] from JSON.
  factory TimeSlotModel.fromJson(Map<String, dynamic> json) {
    if (json['id'] != null && json['id'] is int) {
      json['id'] = json['id'].toString();
    }
    return _$TimeSlotModelFromJson(json);
  }

  /// Converts a [TimeSlotModel] to JSON.
  Map<String, dynamic> toJson() => _$TimeSlotModelToJson(this);
}
