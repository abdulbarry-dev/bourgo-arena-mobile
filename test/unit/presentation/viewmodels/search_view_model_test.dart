import 'package:bourgo_arena_mobile/domain/entities/activity.dart';
import 'package:bourgo_arena_mobile/core/utils/result.dart';
import 'package:bourgo_arena_mobile/domain/core/failure.dart';
import 'package:bourgo_arena_mobile/domain/entities/course.dart';
import 'package:bourgo_arena_mobile/domain/entities/search_result.dart';
import 'package:bourgo_arena_mobile/domain/usecases/activity/get_activities_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/course/get_courses_use_case.dart';
import 'package:bourgo_arena_mobile/l10n/app_localizations_en.dart';
import 'package:bourgo_arena_mobile/presentation/search/search_view_model.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class MockGetActivities extends Mock implements GetActivitiesUseCase {}

class MockGetCourses extends Mock implements GetCoursesUseCase {}

void main() {
  late MockGetActivities mockActivities;
  late MockGetCourses mockCourses;
  final l10n = AppLocalizationsEn();

  final tActivities = [
    Activity(
      id: 'a1',
      title: 'Soccer',
      category: 'Outdoor',
      basePrice: 0,
      currency: 'EUR',
      imageUrl: '',
      description: '',
      icon: '',
      features: const [],
    ),
  ];

  final tCourses = [
    Course(
      id: 'c1',
      title: 'Yoga Class',
      instructor: 'Inst',
      startTime: '10:00',
      endTime: '11:00',
      dayOfWeek: 1,
      category: 'Wellness',
      capacity: 10,
      enrolled: 0,
      icon: '',
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

  test('empty query returns no results', () async {
    final vm = SearchViewModel(
      getActivitiesUseCase: mockActivities,
      getCoursesUseCase: mockCourses,
      l10n: l10n,
    );

    await vm.search('a');
    expect(vm.results, isEmpty);
  });

  test('valid query calls use cases and populates results', () async {
    final vm = SearchViewModel(
      getActivitiesUseCase: mockActivities,
      getCoursesUseCase: mockCourses,
      l10n: l10n,
    );

    await vm.search('soc');

    expect(vm.results.isNotEmpty, isTrue);
    // ensure at least one activity result present
    expect(vm.results.any((r) => r.type == SearchResultType.activity), isTrue);
  });

  test('error from use cases leaves results empty', () async {
    when(
      () => mockActivities(),
    ).thenAnswer((_) async => FailureResult(const ServerFailure('err')));

    final vm = SearchViewModel(
      getActivitiesUseCase: mockActivities,
      getCoursesUseCase: mockCourses,
      l10n: l10n,
    );

    await vm.search('soc');

    expect(vm.results, isEmpty);
  });

  test('subsequent short query clears stale results', () async {
    final vm = SearchViewModel(
      getActivitiesUseCase: mockActivities,
      getCoursesUseCase: mockCourses,
      l10n: l10n,
    );

    await vm.search('soc');
    expect(vm.results.isNotEmpty, isTrue);

    await vm.search('a');
    expect(vm.results, isEmpty);
  });
}
