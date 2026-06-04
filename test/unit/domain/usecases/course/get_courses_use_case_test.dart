import 'package:bourgo_arena_mobile/core/utils/result.dart';
import 'package:bourgo_arena_mobile/domain/core/failure.dart';
import 'package:bourgo_arena_mobile/domain/entities/course.dart';
import 'package:bourgo_arena_mobile/domain/repositories/course_repository.dart';
import 'package:bourgo_arena_mobile/domain/usecases/course/get_courses_use_case.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import '../usecase_test_fixtures.dart';
import 'package:bourgo_arena_mobile/domain/core/app_error_code.dart';

class MockCourseRepository extends Mock implements CourseRepository {}

void main() {
  late MockCourseRepository repository;
  late GetCoursesUseCase useCase;

  setUp(() {
    registerFallbackValue(testCourse());
    repository = MockCourseRepository();
    useCase = GetCoursesUseCase(repository);
  });

  group('GetCoursesUseCase', () {
    test('returns the course list on success', () async {
      final courses = <Course>[testCourse()];
      when(
        () => repository.getCourses(),
      ).thenAnswer((_) async => Success<List<Course>, Failure>(courses));

      final result = await useCase();

      expect(result, isA<Success<List<Course>, Failure>>());
      expect((result as Success<List<Course>, Failure>).data, same(courses));
      verify(() => repository.getCourses()).called(1);
      verifyNoMoreInteractions(repository);
    });

    test('propagates repository failures unchanged', () async {
      const failure = ServerFailure(
        AppErrorCode.serverError,
        'courses unavailable',
      );

      when(() => repository.getCourses()).thenAnswer(
        (_) async => const FailureResult<List<Course>, Failure>(failure),
      );

      final result = await useCase();

      expect(result, isA<FailureResult<List<Course>, Failure>>());
      expect(
        (result as FailureResult<List<Course>, Failure>).failure,
        same(failure),
      );
      verify(() => repository.getCourses()).called(1);
      verifyNoMoreInteractions(repository);
    });

    test('returns empty lists unchanged', () async {
      when(
        () => repository.getCourses(),
      ).thenAnswer((_) async => const Success<List<Course>, Failure>([]));

      final result = await useCase();

      expect(result, isA<Success<List<Course>, Failure>>());
      expect((result as Success<List<Course>, Failure>).data, isEmpty);
      verify(() => repository.getCourses()).called(1);
      verifyNoMoreInteractions(repository);
    });
  });
}
