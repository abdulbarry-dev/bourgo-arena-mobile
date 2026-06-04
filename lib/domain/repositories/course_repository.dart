import 'package:bourgo_arena_mobile/core/utils/result.dart';
import 'package:bourgo_arena_mobile/domain/core/failure.dart';
import 'package:bourgo_arena_mobile/domain/entities/course.dart';

/// Interface for course-related data operations.
abstract interface class CourseRepository {
  /// Retrieves a list of all available courses.
  Future<Result<List<Course>, Failure>> getCourses();

  /// Retrieves details for a specific course.
  Future<Result<Course, Failure>> getCourseDetails(String courseId);

  /// Retrieves upcoming sessions for a specific course.
  Future<Result<List<dynamic>, Failure>> getCourseSessions(String courseId);
}
