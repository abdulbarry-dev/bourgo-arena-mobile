import 'package:json_annotation/json_annotation.dart';

part 'course_model.g.dart';

/// DTO for a course template matching GET /courses CourseResource.
/// Fields: id, name, description, category, image_url, status.
@JsonSerializable(fieldRename: FieldRename.snake)
class CourseModel {
  /// Unique identifier.
  final String id;

  /// Course name from API `name` field.
  final String? name;

  /// Legacy `title` field — used by session resource.
  final String? title;

  /// Description of the course.
  final String? description;

  /// Category (Fitness, Academy, Wellness).
  final String? category;

  /// Image URL for the course cover.
  final String? imageUrl;

  /// Array of image URLs
  final List<String>? images;

  /// Course status (active / inactive).
  final String? status;

  /// Instructor name — from session resource.
  final String? instructor;

  /// Start time (HH:mm) — from session resource.
  final String? startTime;

  /// End time (HH:mm) — from session resource.
  final String? endTime;

  /// Day of the week (1-7) — from session resource.
  final int? dayOfWeek;

  /// Maximum capacity — from session resource.
  final int? capacity;

  /// Number of spots already booked — from session resource.
  final int? enrolled;

  /// Material symbol icon name — from session resource.
  final String? icon;

  /// Creates a new [CourseModel] instance.
  const CourseModel({
    required this.id,
    this.name,
    this.title,
    this.description,
    this.category,
    this.imageUrl,
    this.images,
    this.status,
    this.instructor,
    this.startTime,
    this.endTime,
    this.dayOfWeek,
    this.capacity,
    this.enrolled,
    this.icon,
  });

  factory CourseModel.fromJson(Map<String, dynamic> json) =>
      _$CourseModelFromJson(json);

  Map<String, dynamic> toJson() => _$CourseModelToJson(this);

  /// Resolves the display title from either `title` (session) or `name` (list).
  String get displayTitle => title ?? name ?? '';

  /// Returns true if the course is full.
  bool get isFull => (enrolled ?? 0) >= (capacity ?? 0);

  /// Returns the number of remaining spots.
  int get remainingSpots => (capacity ?? 0) - (enrolled ?? 0);
}
