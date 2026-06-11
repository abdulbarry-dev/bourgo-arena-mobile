import 'package:json_annotation/json_annotation.dart';

part 'child_booking_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class ChildBookingModel {
  @JsonKey(fromJson: _idToString)
  final String id;

  @JsonKey(name: 'session_id', fromJson: _idToString)
  final String sessionId;

  @JsonKey(name: 'course_id', fromJson: _idToString)
  final String courseId;

  @JsonKey(name: 'course_name')
  final String? courseName;

  final String? date;
  final String? startTime;
  final String? endTime;
  final String? status;

  @JsonKey(name: 'completed_at')
  final String? completedAt;

  const ChildBookingModel({
    required this.id,
    required this.sessionId,
    required this.courseId,
    this.courseName,
    this.date,
    this.startTime,
    this.endTime,
    this.status,
    this.completedAt,
  });

  factory ChildBookingModel.fromJson(Map<String, dynamic> json) =>
      _$ChildBookingModelFromJson(json);

  Map<String, dynamic> toJson() => _$ChildBookingModelToJson(this);

  static String _idToString(dynamic id) => id.toString();

  DateTime? get completedAtDateTime =>
      completedAt != null ? DateTime.tryParse(completedAt!) : null;
}
