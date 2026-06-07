import 'package:bourgo_arena_mobile/domain/entities/time_slot.dart';

/// Entity representing a group course or training session.
class Course {
  /// Unique identifier.
  final String id;

  /// Course name.
  final String name;

  /// Description.
  final String? description;

  /// Course time slot.
  final TimeSlot? timeSlot;

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

  /// Creates a new [Course] instance.
  const Course({
    required this.id,
    required this.name,
    this.description,
    this.timeSlot,
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

  /// Returns true if the course is full.
  bool get isFull => enrolled >= capacity;

  /// Returns the number of remaining spots.
  int get remainingSpots => capacity - enrolled;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Course &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          description == other.description &&
          timeSlot == other.timeSlot &&
          title == other.title &&
          instructor == other.instructor &&
          startTime == other.startTime &&
          endTime == other.endTime &&
          dayOfWeek == other.dayOfWeek &&
          category == other.category &&
          imageUrl == other.imageUrl &&
          capacity == other.capacity &&
          enrolled == other.enrolled &&
          icon == other.icon;

  @override
  int get hashCode =>
      id.hashCode ^
      name.hashCode ^
      description.hashCode ^
      timeSlot.hashCode ^
      title.hashCode ^
      instructor.hashCode ^
      startTime.hashCode ^
      endTime.hashCode ^
      dayOfWeek.hashCode ^
      category.hashCode ^
      imageUrl.hashCode ^
      capacity.hashCode ^
      enrolled.hashCode ^
      icon.hashCode;
}
