import 'package:bourgo_arena_mobile/core/utils/result.dart';
import 'package:bourgo_arena_mobile/domain/core/failure.dart';
import 'package:bourgo_arena_mobile/domain/usecases/activity/get_activities_use_case.dart';
import 'package:bourgo_arena_mobile/domain/entities/activity.dart';
import 'package:bourgo_arena_mobile/domain/entities/course.dart' as entity;
import 'package:bourgo_arena_mobile/domain/usecases/course/get_courses_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/service/get_services_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/event/event_use_cases.dart';
import 'package:bourgo_arena_mobile/presentation/home/home_view_model.dart';
import 'package:bourgo_arena_mobile/presentation/home/models/unified_offering.dart';
import 'package:checks/checks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:bourgo_arena_mobile/domain/core/app_error_code.dart';

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
  ];

  setUp(() {
    mockGetActivities = _MockGetActivitiesUseCase();
    mockGetCourses = _MockGetCoursesUseCase();
    mockGetServices = _MockGetServicesUseCase();
    mockGetEvents = _MockGetEventsUseCase();

    viewModel = HomeViewModel(
      getActivitiesUseCase: mockGetActivities,
      getCoursesUseCase: mockGetCourses,
      getServicesUseCase: mockGetServices,
      getEventsUseCase: mockGetEvents,
    );
  });

  group('HomeViewModel', () {
    test('initial state is correct', () {
      check(viewModel.isLoading).isFalse();
      check(viewModel.filteredOfferings).isEmpty();
      check(viewModel.selectedFilterType).isNull();
      check(viewModel.searchQuery).isEmpty();
    });

    test('setFilterType updates type and filters correctly', () async {
      when(
        () => mockGetActivities(),
      ).thenAnswer((_) async => Result.success(testActivities));
      when(
        () => mockGetCourses(),
      ).thenAnswer((_) async => Result.success(testCourses));
      when(() => mockGetServices()).thenAnswer((_) async => Result.success([]));
      when(() => mockGetEvents()).thenAnswer((_) async => Result.success([]));

      await viewModel.loadHomeData();

      check(viewModel.filteredOfferings.length).equals(2);

      viewModel.setFilterType(OfferingType.activity);
      check(viewModel.filteredOfferings.length).equals(1);
      check(
        viewModel.filteredOfferings.first.type,
      ).equals(OfferingType.activity);
    });

    test('setSearchQuery filters correctly', () async {
      when(
        () => mockGetActivities(),
      ).thenAnswer((_) async => Result.success(testActivities));
      when(
        () => mockGetCourses(),
      ).thenAnswer((_) async => Result.success(testCourses));
      when(() => mockGetServices()).thenAnswer((_) async => Result.success([]));
      when(() => mockGetEvents()).thenAnswer((_) async => Result.success([]));

      await viewModel.loadHomeData();

      viewModel.setSearchQuery('soccer');
      check(viewModel.filteredOfferings.length).equals(1);
      check(viewModel.filteredOfferings.first.title).equals('Soccer');
    });

    test('loadHomeData failure handles errors gracefully', () async {
      when(() => mockGetActivities()).thenAnswer(
        (_) async => Result.failure(
          const ServerFailure(AppErrorCode.serverError, 'Error'),
        ),
      );
      when(() => mockGetCourses()).thenAnswer(
        (_) async => Result.failure(
          const ServerFailure(AppErrorCode.serverError, 'Error'),
        ),
      );
      when(() => mockGetServices()).thenAnswer(
        (_) async => Result.failure(
          const ServerFailure(AppErrorCode.serverError, 'Error'),
        ),
      );
      when(() => mockGetEvents()).thenAnswer(
        (_) async => Result.failure(
          const ServerFailure(AppErrorCode.serverError, 'Error'),
        ),
      );

      await viewModel.loadHomeData();

      check(viewModel.isLoading).isFalse();
      check(viewModel.filteredOfferings).isEmpty();
    });
  });
}
