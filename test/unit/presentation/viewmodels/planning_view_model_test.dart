import 'package:bourgo_arena_mobile/core/constants/app_constants.dart';
import 'package:bourgo_arena_mobile/core/utils/result.dart';
import 'package:bourgo_arena_mobile/domain/core/failure.dart';
import 'package:bourgo_arena_mobile/domain/entities/course.dart';
import 'package:bourgo_arena_mobile/domain/usecases/course/get_courses_use_case.dart';
import 'package:bourgo_arena_mobile/presentation/planning/planning_view_model.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class MockGetCourses extends Mock implements GetCoursesUseCase {}

void main() {
  late MockGetCourses mockGetCourses;

  final tCourses = [
    Course(
      id: 'c1',
      title: 'Pilates',
      instructor: 'I',
      startTime: '09:00',
      endTime: '10:00',
      dayOfWeek: 1,
      category: 'Wellness',
      capacity: 10,
      enrolled: 0,
      icon: 'icon',
    ),
  ];

  setUp(() {
    mockGetCourses = MockGetCourses();
    when(
      () => mockGetCourses(),
    ).thenAnswer((_) async => Result.success(tCourses));
  });

  test('courses load on init and filter works', () async {
    final vm = PlanningViewModel(getCoursesUseCase: mockGetCourses);

    // constructor triggers load
    expect(vm.isLoading, isTrue);
    await Future.delayed(Duration.zero);

    expect(vm.isLoading, isFalse);
    // default selectedDay is 1 and our course has dayOfWeek 1
    expect(vm.courses.length, 1);
  });

  test('failure propagates and results empty', () async {
    when(
      () => mockGetCourses(),
    ).thenAnswer((_) async => FailureResult(const ServerFailure('err')));

    final vm = PlanningViewModel(getCoursesUseCase: mockGetCourses);
    await Future.delayed(Duration.zero);

    expect(vm.courses, isEmpty);
  });

  test('empty list handled', () async {
    when(
      () => mockGetCourses(),
    ).thenAnswer((_) async => Result.success(<Course>[]));

    final vm = PlanningViewModel(getCoursesUseCase: mockGetCourses);
    await Future.delayed(Duration.zero);

    expect(vm.courses, isEmpty);
  });
}
