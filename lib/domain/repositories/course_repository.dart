import 'package:bourgo_arena_mobile/core/utils/result.dart';
import 'package:bourgo_arena_mobile/domain/core/failure.dart';
import 'package:bourgo_arena_mobile/domain/entities/course.dart';

/// Interface for course-related data operations.
abstract interface class CourseRepository {
  /// Retrieves a list of all available course templates from GET /courses.
  Future<Result<List<Course>, Failure>> getCourses();

  /// Retrieves details for a specific course from GET /courses/{id}.
  Future<Result<Course, Failure>> getCourseDetails(String courseId);

  /// Retrieves upcoming sessions for a specific course from
  /// GET /courses/{id}/sessions. Returns [Course] sessions with
  /// schedule data (start_time, end_time, day_of_week, capacity, enrolled).
  Future<Result<List<Course>, Failure>> getCourseSessions(String courseId);

  /// Enrolls the current user in a specific course session.
  Future<Result<void, Failure>> enrollInCourse(String courseId);
}
