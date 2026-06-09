import 'package:json_annotation/json_annotation.dart';

part 'course_session_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class CourseSessionModel {
  final String id;
  final String? title;
  final String? startTime;
  final String? endTime;
  final int? dayOfWeek;
  final int? capacity;
  final int? enrolled;
  final String? imageUrl;
  final bool? isBooked;

  const CourseSessionModel({
    required this.id,
    this.title,
    this.startTime,
    this.endTime,
    this.dayOfWeek,
    this.capacity,
    this.enrolled,
    this.imageUrl,
    this.isBooked,
  });

  factory CourseSessionModel.fromJson(Map<String, dynamic> json) =>
      _$CourseSessionModelFromJson(json);

  Map<String, dynamic> toJson() => _$CourseSessionModelToJson(this);
}
