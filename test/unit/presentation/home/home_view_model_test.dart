import 'package:bourgo_arena_mobile/core/utils/result.dart';
import 'package:bourgo_arena_mobile/domain/core/failure.dart';
import 'package:bourgo_arena_mobile/domain/entities/activity.dart';
import 'package:bourgo_arena_mobile/domain/entities/course.dart' as entity;
import 'package:bourgo_arena_mobile/domain/usecases/activity/get_activities_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/course/get_courses_use_case.dart';
import 'package:bourgo_arena_mobile/presentation/home/home_view_model.dart';
import 'package:checks/checks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockGetActivitiesUseCase extends Mock implements GetActivitiesUseCase {}

class _MockGetCoursesUseCase extends Mock implements GetCoursesUseCase {}

void main() {
  late _MockGetActivitiesUseCase mockGetActivities;
  late _MockGetCoursesUseCase mockGetCourses;
  late HomeViewModel viewModel;

  final testActivities = [
    const Activity(
      id: '1',
      title: 'Soccer',
      category: 'Outdoor',
      basePrice: 50.0,
      currency: 'EUR',
      imageUrl: 'image1',
      description: 'Soccer desc',
      icon: 'sports_soccer',
      features: ['Pitch', 'Lighting'],
    ),
  ];

  final testCourses = [
    entity.Course(
      id: 'c1',
      title: 'Tennis Training',
      instructor: 'Coach John',
      startTime: '10:00',
      endTime: '11:00',
      dayOfWeek: DateTime.now().weekday,
      category: 'Tennis',
      capacity: 10,
      enrolled: 5,
      icon: 'sports_tennis',
    ),
    entity.Course(
      id: 'c2',
      title: 'Yoga',
      instructor: 'Coach Sarah',
      startTime: '08:00',
      endTime: '09:00',
      dayOfWeek: (DateTime.now().weekday % 7) + 1, // Different day
      category: 'Yoga',
      capacity: 20,
      enrolled: 2,
      icon: 'self_improvement',
    ),
  ];

  setUp(() {
    mockGetActivities = _MockGetActivitiesUseCase();
    mockGetCourses = _MockGetCoursesUseCase();
    viewModel = HomeViewModel(
      getActivitiesUseCase: mockGetActivities,
      getCoursesUseCase: mockGetCourses,
    );
  });

  group('HomeViewModel', () {
    test('initial state is correct', () {
      check(viewModel.currentIndex).equals(0);
      check(viewModel.isLoading).isFalse();
      check(viewModel.activities).isEmpty();
      check(viewModel.todayCourses).isEmpty();
    });

    test('setTab updates currentIndex and notifies listeners', () {
      var listenerCalled = false;
      viewModel.addListener(() => listenerCalled = true);

      viewModel.setTab(2);

      check(viewModel.currentIndex).equals(2);
      check(listenerCalled).isTrue();
    });

    test(
      'loadHomeData success populates activities and today courses',
      () async {
        when(
          () => mockGetActivities(),
        ).thenAnswer((_) async => Result.success(testActivities));
        when(
          () => mockGetCourses(),
        ).thenAnswer((_) async => Result.success(testCourses));

        await viewModel.loadHomeData();

        check(viewModel.isLoading).isFalse();
        check(viewModel.activities).deepEquals(testActivities);
        // Only one course matches today's weekday
        check(viewModel.todayCourses).length.equals(1);
        check(viewModel.todayCourses.first.id).equals('c1');
      },
    );

    test('loadHomeData failure handles errors gracefully', () async {
      when(
        () => mockGetActivities(),
      ).thenAnswer((_) async => Result.failure(const ServerFailure('Error')));
      when(
        () => mockGetCourses(),
      ).thenAnswer((_) async => Result.failure(const ServerFailure('Error')));

      await viewModel.loadHomeData();

      check(viewModel.isLoading).isFalse();
      check(viewModel.activities).isEmpty();
      check(viewModel.todayCourses).isEmpty();
    });

    test('loadHomeData catch block handles unexpected exceptions', () async {
      when(() => mockGetActivities()).thenThrow(Exception('Unexpected'));
      when(() => mockGetCourses()).thenThrow(Exception('Unexpected'));

      await viewModel.loadHomeData();

      check(viewModel.isLoading).isFalse();
      check(viewModel.activities).isEmpty();
      check(viewModel.todayCourses).isEmpty();
    });
    group('HomeViewModel fallback day coverage', () {
      test(
        'correctly filters courses for current day when weekday is 7',
        () async {
          // Mock current day as Sunday (7)
          final sundayCourse = entity.Course(
            id: 'sunday',
            title: 'Sunday Yoga',
            instructor: 'Sarah',
            startTime: '10:00',
            endTime: '11:00',
            dayOfWeek: 7,
            category: 'Yoga',
            capacity: 10,
            enrolled: 10,
            icon: 'self_improvement',
          );

          when(
            () => mockGetActivities(),
          ).thenAnswer((_) async => Result.success([]));
          when(
            () => mockGetCourses(),
          ).thenAnswer((_) async => Result.success([sundayCourse]));

          // We can't easily mock DateTime.now() without a wrapper,
          // so we check if the logic matches whatever today is.
          await viewModel.loadHomeData();

          final today = DateTime.now().weekday;
          if (today == 7) {
            check(viewModel.todayCourses).length.equals(1);
          } else {
            check(viewModel.todayCourses).isEmpty();
          }
        },
      );
    });
  });
}
