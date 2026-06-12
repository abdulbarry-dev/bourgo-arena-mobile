import 'package:json_annotation/json_annotation.dart';

part 'schedule_item_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class ScheduleItemModel {
  final String type;
  final String? typeLabel;
  final String id;
  final String? date;
  @JsonKey(name: 'course_name')
  final String? courseName;
  @JsonKey(name: 'activity_title')
  final String? activityTitle;
  final String? startTime;
  final String? endTime;
  final int? durationMinutes;
  final String? status;
  final String? statusLabel;
  final bool? isCompleted;

  const ScheduleItemModel({
    required this.type,
    required this.typeLabel,
    required this.id,
    this.date,
    this.courseName,
    this.activityTitle,
    this.startTime,
    this.endTime,
    this.durationMinutes,
    this.status,
    this.statusLabel,
    this.isCompleted,
  });

  String? get name => courseName ?? activityTitle;

  factory ScheduleItemModel.fromJson(Map<String, dynamic> json) =>
      _$ScheduleItemModelFromJson(json);

  Map<String, dynamic> toJson() => _$ScheduleItemModelToJson(this);
}
