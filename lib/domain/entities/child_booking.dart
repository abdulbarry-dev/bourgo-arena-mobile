class ChildBooking {
  final String id;
  final String sessionId;
  final String courseId;
  final String courseName;
  final String date;
  final String startTime;
  final String endTime;
  final String status;
  final DateTime? completedAt;

  const ChildBooking({
    required this.id,
    required this.sessionId,
    required this.courseId,
    required this.courseName,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.status,
    this.completedAt,
  });

  bool get isCompleted => completedAt != null;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ChildBooking &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          sessionId == other.sessionId &&
          courseId == other.courseId &&
          courseName == other.courseName &&
          date == other.date &&
          startTime == other.startTime &&
          endTime == other.endTime &&
          status == other.status &&
          completedAt == other.completedAt;

  @override
  int get hashCode =>
      id.hashCode ^
      sessionId.hashCode ^
      courseId.hashCode ^
      courseName.hashCode ^
      date.hashCode ^
      startTime.hashCode ^
      endTime.hashCode ^
      status.hashCode ^
      completedAt.hashCode;
}
