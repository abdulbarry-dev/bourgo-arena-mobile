import 'package:json_annotation/json_annotation.dart';

part 'course.g.dart';

/// Model representing a group course or training session.
@JsonSerializable(fieldRename: FieldRename.snake)
class Course {
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

  /// Maximum capacity.
  final int capacity;

  /// Number of spots already booked.
  final int enrolled;

  /// Material symbol icon name.
  final String icon;

  /// Creates a new [Course] instance.
  const Course({
    required this.id,
    required this.title,
    required this.instructor,
    required this.startTime,
    required this.endTime,
    required this.dayOfWeek,
    required this.category,
    required this.capacity,
    required this.enrolled,
    required this.icon,
  });

  factory Course.fromJson(Map<String, dynamic> json) => _$CourseFromJson(json);
  Map<String, dynamic> toJson() => _$CourseToJson(this);

  /// Returns true if the course is full.
  bool get isFull => enrolled >= capacity;

  /// Returns the number of remaining spots.
  int get remainingSpots => capacity - enrolled;
}
