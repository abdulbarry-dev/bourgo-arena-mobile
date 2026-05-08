import 'package:bourgo_arena_mobile/core/utils/result.dart';
import 'package:bourgo_arena_mobile/domain/core/failure.dart';
import 'package:bourgo_arena_mobile/domain/entities/course.dart';

/// Interface for course-related data operations.
abstract interface class CourseRepository {
  /// Retrieves a list of all available courses.
  Future<Result<List<Course>, Failure>> getCourses();
}
