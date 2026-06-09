import 'package:bourgo_arena_mobile/core/utils/result.dart';
import 'package:bourgo_arena_mobile/domain/entities/activity.dart';
import 'package:bourgo_arena_mobile/domain/entities/course.dart';
import 'package:bourgo_arena_mobile/domain/usecases/activity/get_activities_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/course/get_courses_use_case.dart';
import 'package:bourgo_arena_mobile/domain/entities/event.dart';
import 'package:bourgo_arena_mobile/domain/entities/service.dart';
import 'package:bourgo_arena_mobile/domain/usecases/service/get_services_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/event/event_use_cases.dart';
import 'package:bourgo_arena_mobile/presentation/home/home_view_model.dart';
import 'package:bourgo_arena_mobile/domain/core/app_error_code.dart';
import 'package:bourgo_arena_mobile/domain/core/failure.dart';
import 'package:checks/checks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockGetActivitiesUseCase extends Mock implements GetActivitiesUseCase {}

class _MockGetCoursesUseCase extends Mock implements GetCoursesUseCase {}

class _MockGetServicesUseCase extends Mock implements GetServicesUseCase {}

class _MockGetEventsUseCase extends Mock implements GetEventsUseCase {}

void main() {
  late _MockGetActivitiesUseCase mockGetActivities;
  late _MockGetCoursesUseCase mockGetCourses;
  late _MockGetServicesUseCase mockGetServices;
  late _MockGetEventsUseCase mockGetEvents;
  late HomeViewModel viewModel;

  final testActivities = [
    const Activity(
      id: 'a1',
      title: 'Soccer',
      name: 'Soccer',
      category: 'Outdoor',
      basePrice: 50.0,
      currency: 'EUR',
      imageUrl: 'image1',
      images: ['image1'],
      description: 'Soccer desc',
      icon: 'sports_soccer',
      features: ['Pitch', 'Lighting'],
    ),
  ];

  final testCourses = [
    Course(
      id: 'c1',
      name: 'Tennis Training',
      description: 'Tennis course',
      images: ['https://example.com/course.jpg'],
      status: 'active',
    ),
  ];

  final testEvents = [
    Event(id: 'e1', name: 'Tournament', status: 'open'),
  ];

  final testServices = [
    const Service(id: 1, name: 'Coaching'),
  ];

  setUp(() {
    mockGetActivities = _MockGetActivitiesUseCase();
    mockGetCourses = _MockGetCoursesUseCase();
    mockGetEvents = _MockGetEventsUseCase();
    mockGetServices = _MockGetServicesUseCase();

    viewModel = HomeViewModel(
      getActivitiesUseCase: mockGetActivities,
      getCoursesUseCase: mockGetCourses,
      getServicesUseCase: mockGetServices,
      getEventsUseCase: mockGetEvents,
    );
  });

  group('HomeViewModel', () {
    test('initial state has loading flags true and empty lists', () {
      check(viewModel.isLoading).isFalse();
      check(viewModel.events).isEmpty();
      check(viewModel.courses).isEmpty();
      check(viewModel.activities).isEmpty();
      check(viewModel.services).isEmpty();
      check(viewModel.eventsLoading).isTrue();
      check(viewModel.coursesLoading).isTrue();
      check(viewModel.activitiesLoading).isTrue();
      check(viewModel.servicesLoading).isTrue();
    });

    test('loadHomeData populates per-type lists', () async {
      when(
        () => mockGetActivities(),
      ).thenAnswer((_) async => Success(testActivities));
      when(
        () => mockGetCourses(),
      ).thenAnswer((_) async => Success(testCourses));
      when(
        () => mockGetEvents(),
      ).thenAnswer((_) async => Success(testEvents));
      when(
        () => mockGetServices(),
      ).thenAnswer((_) async => Success(testServices));

      await viewModel.loadHomeData();

      check(viewModel.activities.length).equals(1);
      check(viewModel.courses.length).equals(1);
      check(viewModel.events.length).equals(1);
      check(viewModel.services.length).equals(1);
      check(viewModel.activitiesLoading).isFalse();
      check(viewModel.coursesLoading).isFalse();
      check(viewModel.eventsLoading).isFalse();
      check(viewModel.servicesLoading).isFalse();
      check(viewModel.isLoading).isFalse();
    });

    test('limits each list to 5 items', () async {
      final manyActivities = List.generate(
        10,
        (i) => Activity(
          id: 'a$i',
          title: 'Activity $i',
          name: 'Activity $i',
          category: 'Sport',
          basePrice: 0,
          currency: 'TND',
          imageUrl: '',
          images: [],
          description: '',
          icon: 'sports_soccer',
          features: [],
        ),
      );

      when(
        () => mockGetActivities(),
      ).thenAnswer((_) async => Success(manyActivities));
      when(
        () => mockGetCourses(),
      ).thenAnswer((_) async => Success(<Course>[]));
      when(
        () => mockGetEvents(),
      ).thenAnswer((_) async => Success(<Event>[]));
      when(
        () => mockGetServices(),
      ).thenAnswer((_) async => Success(<Service>[]));

      await viewModel.loadHomeData();

      check(viewModel.activities.length).equals(5);
    });

    test('failure sets error message for that type', () async {
      when(() => mockGetActivities()).thenAnswer(
        (_) async => FailureResult(
          const ServerFailure(AppErrorCode.serverError, 'Activities error'),
        ),
      );
      when(() => mockGetCourses()).thenAnswer(
        (_) async => const Success(<Course>[]),
      );
      when(() => mockGetEvents()).thenAnswer(
        (_) async => const Success(<Event>[]),
      );
      when(() => mockGetServices()).thenAnswer(
        (_) async => const Success(<Service>[]),
      );

      await viewModel.loadHomeData();

      check(viewModel.activitiesError).equals('Activities error');
      check(viewModel.activitiesLoading).isFalse();
      check(viewModel.activities).isEmpty();
      check(viewModel.coursesError).isNull();
    });

    test('all failures handled gracefully', () async {
      when(() => mockGetActivities()).thenAnswer(
        (_) async => FailureResult(
          const ServerFailure(AppErrorCode.serverError, 'Error'),
        ),
      );
      when(() => mockGetCourses()).thenAnswer(
        (_) async => FailureResult(
          const ServerFailure(AppErrorCode.serverError, 'Error'),
        ),
      );
      when(() => mockGetEvents()).thenAnswer(
        (_) async => FailureResult(
          const ServerFailure(AppErrorCode.serverError, 'Error'),
        ),
      );
      when(() => mockGetServices()).thenAnswer(
        (_) async => FailureResult(
          const ServerFailure(AppErrorCode.serverError, 'Error'),
        ),
      );

      await viewModel.loadHomeData();

      check(viewModel.isLoading).isFalse();
      check(viewModel.activities).isEmpty();
      check(viewModel.courses).isEmpty();
      check(viewModel.events).isEmpty();
      check(viewModel.services).isEmpty();
      check(viewModel.activitiesError).isNotNull();
      check(viewModel.coursesError).isNotNull();
      check(viewModel.eventsError).isNotNull();
      check(viewModel.servicesError).isNotNull();
    });
  });
}
