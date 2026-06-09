import 'package:bourgo_arena_mobile/core/utils/result.dart';
import 'package:bourgo_arena_mobile/domain/core/failure.dart';
import 'package:bourgo_arena_mobile/domain/entities/course.dart';
import 'package:bourgo_arena_mobile/domain/repositories/course_repository.dart';

class GetCourseSessionsUseCase {
  final CourseRepository _repository;
  GetCourseSessionsUseCase(this._repository);

  Future<Result<List<CourseSession>, Failure>> call(String courseId) {
    return _repository.getCourseSessions(courseId);
  }
}
