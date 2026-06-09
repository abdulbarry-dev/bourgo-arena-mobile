/// Entity representing a course template from GET /courses.
class Course {
  final String id;
  final String name;
  final String? description;
  final List<String> images;
  final String? imageUrl;
  final String? status;

  const Course({
    required this.id,
    required this.name,
    this.description,
    this.images = const [],
    this.imageUrl,
    this.status,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Course &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          description == other.description &&
          _listEquals(images, other.images) &&
          imageUrl == other.imageUrl &&
          status == other.status;

  @override
  int get hashCode =>
      id.hashCode ^
      name.hashCode ^
      description.hashCode ^
      Object.hashAll(images) ^
      imageUrl.hashCode ^
      status.hashCode;

  static bool _listEquals(List<String> a, List<String> b) {
    if (a.length != b.length) return false;
    for (var i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }
}

/// Entity representing a course session from GET /courses/{id}/sessions.
class CourseSession {
  final String id;
  final String title;
  final String startTime;
  final String endTime;
  final int dayOfWeek;
  final int capacity;
  final int enrolled;
  final String? imageUrl;
  final bool isBooked;

  const CourseSession({
    required this.id,
    required this.title,
    required this.startTime,
    required this.endTime,
    required this.dayOfWeek,
    required this.capacity,
    required this.enrolled,
    this.imageUrl,
    this.isBooked = false,
  });

  bool get isFull => enrolled >= capacity;
  int get remainingSpots => capacity - enrolled;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CourseSession &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          title == other.title &&
          startTime == other.startTime &&
          endTime == other.endTime &&
          dayOfWeek == other.dayOfWeek &&
          capacity == other.capacity &&
          enrolled == other.enrolled &&
          imageUrl == other.imageUrl;

  @override
  int get hashCode =>
      id.hashCode ^
      title.hashCode ^
      startTime.hashCode ^
      endTime.hashCode ^
      dayOfWeek.hashCode ^
      capacity.hashCode ^
      enrolled.hashCode ^
      imageUrl.hashCode;
}
