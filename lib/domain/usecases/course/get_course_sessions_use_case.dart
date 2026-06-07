import 'package:bourgo_arena_mobile/core/utils/result.dart';
import 'package:bourgo_arena_mobile/domain/core/failure.dart';
import 'package:bourgo_arena_mobile/domain/entities/course.dart';
import 'package:bourgo_arena_mobile/domain/repositories/course_repository.dart';

/// Use case for fetching sessions for a specific course.
class GetCourseSessionsUseCase {
  final CourseRepository _repository;

  GetCourseSessionsUseCase(this._repository);

  /// Executes the use case.
  Future<Result<List<Course>, Failure>> call(String courseId) {
    return _repository.getCourseSessions(courseId);
  }
}
