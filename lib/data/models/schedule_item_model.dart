import 'package:json_annotation/json_annotation.dart';

part 'schedule_item_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class ScheduleItemModel {
  final String type;
  final String typeLabel;
  final String id;
  final String? date;
  final String? name;
  final String? startTime;
  final int? durationMinutes;
  final String? status;
  final String? statusLabel;
  final bool? isCompleted;

  const ScheduleItemModel({
    required this.type,
    required this.typeLabel,
    required this.id,
    this.date,
    this.name,
    this.startTime,
    this.durationMinutes,
    this.status,
    this.statusLabel,
    this.isCompleted,
  });

  factory ScheduleItemModel.fromJson(Map<String, dynamic> json) =>
      _$ScheduleItemModelFromJson(json);

  Map<String, dynamic> toJson() => _$ScheduleItemModelToJson(this);
}
