import 'package:bourgo_arena_mobile/domain/entities/activity.dart';
import 'package:bourgo_arena_mobile/core/utils/result.dart';
import 'package:bourgo_arena_mobile/domain/entities/course.dart' as entity;
import 'package:bourgo_arena_mobile/domain/core/failure.dart';
import 'package:bourgo_arena_mobile/domain/usecases/activity/get_activities_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/course/get_courses_use_case.dart';
import 'package:bourgo_arena_mobile/presentation/home/home_view_model.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class MockGetActivities extends Mock implements GetActivitiesUseCase {}

class MockGetCourses extends Mock implements GetCoursesUseCase {}

void main() {
  late MockGetActivities mockActivities;
  late MockGetCourses mockCourses;

  final tActivities = [
    const Activity(
      id: 'a1',
      title: 'Soccer',
      category: 'Outdoor',
      basePrice: 10,
      currency: 'EUR',
      imageUrl: '',
      description: '',
      icon: 'sports_soccer',
      features: [],
    ),
  ];

  final today = DateTime.now().weekday;
  final tCourses = [
    entity.Course(
      id: 'c1',
      title: 'Yoga',
      instructor: 'Inst',
      startTime: '10:00',
      endTime: '11:00',
      dayOfWeek: today,
      category: 'Wellness',
      capacity: 10,
      enrolled: 1,
      icon: 'self_improvement',
    ),
  ];

  setUp(() {
    mockActivities = MockGetActivities();
    mockCourses = MockGetCourses();

    when(
      () => mockActivities(),
    ).thenAnswer((_) async => Result.success(tActivities));
    when(() => mockCourses()).thenAnswer((_) async => Result.success(tCourses));
  });

  test('loads activities and todays courses on init', () async {
    final vm = HomeViewModel(
      getActivitiesUseCase: mockActivities,
      getCoursesUseCase: mockCourses,
    );

    expect(vm.isLoading, isFalse);

    await vm.loadHomeData();

    expect(vm.activities, tActivities);
    expect(vm.todayCourses.length, 1);
    verify(() => mockActivities()).called(1);
    verify(() => mockCourses()).called(1);
  });

  test(
    'failure on activities does not crash and activities remain empty',
    () async {
      when(
        () => mockActivities(),
      ).thenAnswer((_) async => FailureResult(const ServerFailure('err')));

      final vm = HomeViewModel(
        getActivitiesUseCase: mockActivities,
        getCoursesUseCase: mockCourses,
      );

      await vm.loadHomeData();

      expect(vm.activities, isEmpty);
    },
  );

  test('failure on courses propagates but does not throw', () async {
    when(
      () => mockCourses(),
    ).thenAnswer((_) async => FailureResult(const ServerFailure('err')));

    final vm = HomeViewModel(
      getActivitiesUseCase: mockActivities,
      getCoursesUseCase: mockCourses,
    );

    await vm.loadHomeData();

    expect(vm.todayCourses, isEmpty);
  });
}
