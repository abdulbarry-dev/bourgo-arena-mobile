import 'package:bourgo_arena_mobile/core/utils/result.dart';
import 'package:bourgo_arena_mobile/domain/core/failure.dart';
import 'package:bourgo_arena_mobile/domain/repositories/course_repository.dart';

/// Use case for enrolling a user in a specific course session.
class EnrollInCourseUseCase {
  final CourseRepository _repository;

  const EnrollInCourseUseCase(this._repository);

  /// Executes the enrollment operation.
  Future<Result<void, Failure>> call(String courseId) async {
    return _repository.enrollInCourse(courseId);
  }
}
