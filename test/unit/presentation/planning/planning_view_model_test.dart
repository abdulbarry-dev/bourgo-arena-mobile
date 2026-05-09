import 'package:bourgo_arena_mobile/core/constants/app_constants.dart';
import 'package:bourgo_arena_mobile/core/utils/result.dart';
import 'package:bourgo_arena_mobile/domain/entities/course.dart';
import 'package:bourgo_arena_mobile/domain/usecases/course/get_courses_use_case.dart';
import 'package:bourgo_arena_mobile/presentation/planning/planning_view_model.dart';
import 'package:checks/checks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockGetCoursesUseCase extends Mock implements GetCoursesUseCase {}

void main() {
  late PlanningViewModel viewModel;
  late MockGetCoursesUseCase mockGetCourses;

  final List<Course> testCourses = [
    const Course(
      id: '1',
      title: 'Yoga',
      instructor: 'Alice',
      startTime: '08:00',
      endTime: '09:00',
      dayOfWeek: 1, // Monday
      category: AppConstants.planningCategoryWellness,
      capacity: 20,
      enrolled: 5,
      icon: 'yoga',
    ),
    const Course(
      id: '2',
      title: 'Football',
      instructor: 'Bob',
      startTime: '10:00',
      endTime: '11:00',
      dayOfWeek: 1, // Monday
      category: AppConstants.planningCategoryAcademy,
      capacity: 22,
      enrolled: 10,
      icon: 'sports_soccer',
    ),
    const Course(
      id: '3',
      title: 'Crossfit',
      instructor: 'Charlie',
      startTime: '18:00',
      endTime: '19:00',
      dayOfWeek: 2, // Tuesday
      category: AppConstants.planningCategoryFitness,
      capacity: 15,
      enrolled: 8,
      icon: 'fitness_center',
    ),
  ];

  setUp(() {
    mockGetCourses = MockGetCoursesUseCase();

    when(
      () => mockGetCourses(),
    ).thenAnswer((_) async => Result.success(testCourses));

    viewModel = PlanningViewModel(getCoursesUseCase: mockGetCourses);
  });

  group('PlanningViewModel', () {
    test('initial state filters courses for Monday (day 1)', () async {
      await Future.delayed(Duration.zero);

      check(viewModel.isLoading).isFalse();
      check(viewModel.courses).has((l) => l.length, 'length').equals(2);
      check(viewModel.courses.every((c) => c.dayOfWeek == 1)).isTrue();
    });

    test('selectDay filters courses for that day', () async {
      await Future.delayed(Duration.zero);

      viewModel.selectDay(2);

      check(viewModel.selectedDay).equals(2);
      check(viewModel.courses).has((l) => l.length, 'length').equals(1);
      check(viewModel.courses.first.title).equals('Crossfit');
    });

    test('selectCategory filters courses by category', () async {
      await Future.delayed(Duration.zero);

      viewModel.selectCategory(AppConstants.planningCategoryAcademy);

      check(
        viewModel.selectedCategory,
      ).equals(AppConstants.planningCategoryAcademy);
      check(viewModel.courses).has((l) => l.length, 'length').equals(1);
      check(viewModel.courses.first.title).equals('Football');
    });

    test('selectCategory with "All" resets category filter', () async {
      await Future.delayed(Duration.zero);

      viewModel.selectCategory(AppConstants.planningCategoryAcademy);
      viewModel.selectCategory(AppConstants.planningCategoryAll);

      check(viewModel.courses).has((l) => l.length, 'length').equals(2);
    });
  });
}
