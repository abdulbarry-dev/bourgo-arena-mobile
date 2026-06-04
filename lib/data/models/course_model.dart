import 'package:json_annotation/json_annotation.dart';

part 'course_model.g.dart';

/// Model representing a group course or training session.
@JsonSerializable(fieldRename: FieldRename.snake)
class CourseModel {
  /// Unique identifier.
  final String id;

  /// Name of the course (e.g. CrossFit Beginners).
  final String title;

  /// Name of the instructor.
  final String instructor;

  /// Start time (e.g. 18:00).
  final String startTime;

  /// End time (e.g. 19:30).
  final String endTime;

  /// Day of the week (1-7).
  final int dayOfWeek;

  /// Category (Fitness, Academy, Wellness).
  final String category;

  /// Image URL for the course cover
  final String? imageUrl;

  /// Maximum capacity.
  final int capacity;

  /// Number of spots already booked.
  final int enrolled;

  /// Material symbol icon name.
  final String icon;

  /// Creates a new [CourseModel] instance.
  const CourseModel({
    required this.id,
    required this.title,
    required this.instructor,
    required this.startTime,
    required this.endTime,
    required this.dayOfWeek,
    required this.category,
    this.imageUrl,
    required this.capacity,
    required this.enrolled,
    required this.icon,
  });

  factory CourseModel.fromJson(Map<String, dynamic> json) =>
      _$CourseModelFromJson(json);
  Map<String, dynamic> toJson() => _$CourseModelToJson(this);

  /// Returns true if the course is full.
  bool get isFull => enrolled >= capacity;

  /// Returns the number of remaining spots.
  int get remainingSpots => capacity - enrolled;
}
