import 'package:json_annotation/json_annotation.dart';

part 'time_slot_model.g.dart';

/// Model representing an available time slot for booking.
@JsonSerializable(fieldRename: FieldRename.snake)
class TimeSlotModel {
  /// Time string (e.g. 18:00).
  final String time;

  /// Whether the slot is currently available for booking.
  final bool available;

  /// Creates a new [TimeSlotModel] instance.
  const TimeSlotModel({required this.time, required this.available});

  /// Creates a [TimeSlotModel] from JSON.
  factory TimeSlotModel.fromJson(Map<String, dynamic> json) =>
      _$TimeSlotModelFromJson(json);

  /// Converts a [TimeSlotModel] to JSON.
  Map<String, dynamic> toJson() => _$TimeSlotModelToJson(this);
}
