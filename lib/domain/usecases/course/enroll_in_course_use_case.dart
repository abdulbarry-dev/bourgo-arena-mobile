import 'package:bourgo_arena_mobile/core/utils/result.dart';
import 'package:bourgo_arena_mobile/domain/core/failure.dart';
import 'package:bourgo_arena_mobile/domain/repositories/course_repository.dart';

class BookCourseSessionUseCase {
  final CourseRepository _repository;
  const BookCourseSessionUseCase(this._repository);

  Future<Result<void, Failure>> call(String courseId, String sessionId, String date) {
    return _repository.bookSession(courseId, sessionId, date);
  }
}
