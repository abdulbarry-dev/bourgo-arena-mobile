import 'package:bourgo_arena_mobile/core/utils/result.dart';
import 'package:bourgo_arena_mobile/domain/core/failure.dart';
import 'package:bourgo_arena_mobile/domain/entities/course.dart';
import 'package:bourgo_arena_mobile/domain/repositories/course_repository.dart';

/// Use case for retrieving available group courses.
class GetCoursesUseCase {
  final CourseRepository _repository;

  const GetCoursesUseCase(this._repository);

  /// Executes the operation to fetch courses.
  Future<Result<List<Course>, Failure>> call() async {
    return _repository.getCourses();
  }
}
