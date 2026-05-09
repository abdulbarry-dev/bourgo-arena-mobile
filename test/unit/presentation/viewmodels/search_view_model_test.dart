import 'package:bourgo_arena_mobile/core/utils/result.dart';
import 'package:bourgo_arena_mobile/domain/entities/activity.dart';
import 'package:bourgo_arena_mobile/domain/entities/course.dart';
import 'package:bourgo_arena_mobile/domain/entities/search_result.dart';
import 'package:bourgo_arena_mobile/domain/usecases/activity/get_activities_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/course/get_courses_use_case.dart';
import 'package:bourgo_arena_mobile/l10n/app_localizations.dart';
import 'package:bourgo_arena_mobile/presentation/search/search_view_model.dart';
import 'package:checks/checks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockGetActivitiesUseCase extends Mock implements GetActivitiesUseCase {}
class MockGetCoursesUseCase extends Mock implements GetCoursesUseCase {}
class MockAppLocalizations extends Mock implements AppLocalizations {}

void main() {
  late SearchViewModel viewModel;
  late MockGetActivitiesUseCase mockGetActivities;
  late MockGetCoursesUseCase mockGetCourses;
  late MockAppLocalizations mockL10n;

  final List<Activity> testActivities = [
    const Activity(
      id: '1',
      title: 'Football',
      category: 'Sports',
      description: '',
      icon: '',
      basePrice: 10,
      currency: 'EUR',
      imageUrl: '',
      features: [],
    ),
    const Activity(
      id: '2',
      title: 'Tennis',
      category: 'Sports',
      description: '',
      icon: '',
      basePrice: 15,
      currency: 'EUR',
      imageUrl: '',
      features: [],
    ),
  ];

  final List<Course> testCourses = [
    const Course(
      id: '1',
      title: 'Yoga',
      instructor: 'Alice',
      startTime: '08:00',
      endTime: '09:00',
      dayOfWeek: 1,
      category: 'Wellness',
      capacity: 20,
      enrolled: 5,
      icon: 'yoga',
    ),
  ];

  setUp(() {
    mockGetActivities = MockGetActivitiesUseCase();
    mockGetCourses = MockGetCoursesUseCase();
    mockL10n = MockAppLocalizations();

    when(() => mockGetActivities()).thenAnswer((_) async => Result.success(testActivities));
    when(() => mockGetCourses()).thenAnswer((_) async => Result.success(testCourses));
    
    // Mock some localization strings
    when(() => mockL10n.settingsEditProfile).thenReturn('Edit Profile');
    when(() => mockL10n.settingsSectionAccount).thenReturn('Account');
    when(() => mockL10n.settingsChangePassword).thenReturn('Change Password');
    when(() => mockL10n.profileHistory).thenReturn('History');
    when(() => mockL10n.settingsLanguage).thenReturn('Language');
    when(() => mockL10n.settingsSectionPreferences).thenReturn('Preferences');
    when(() => mockL10n.settingsPrivacy).thenReturn('Privacy');
    when(() => mockL10n.settingsTerms).thenReturn('Terms');
    when(() => mockL10n.settingsSectionLegal).thenReturn('Legal');

    viewModel = SearchViewModel(
      getActivitiesUseCase: mockGetActivities,
      getCoursesUseCase: mockGetCourses,
      l10n: mockL10n,
    );
  });

  group('SearchViewModel', () {
    test('search filters results across all categories', () async {
      await viewModel.search('Foot');

      check(viewModel.results).has((l) => l.length, 'length').equals(1);
      check(viewModel.results.first.title).equals('Football');
      check(viewModel.results.first.type).equals(SearchResultType.activity);
    });

    test('search finds courses', () async {
      await viewModel.search('Yoga');

      check(viewModel.results).has((l) => l.length, 'length').equals(1);
      check(viewModel.results.first.title).equals('Yoga');
      check(viewModel.results.first.type).equals(SearchResultType.course);
    });

    test('search finds settings', () async {
      await viewModel.search('Profile');

      check(viewModel.results).has((l) => l.length, 'length').equals(1);
      check(viewModel.results.first.title).equals('Edit Profile');
      check(viewModel.results.first.type).equals(SearchResultType.setting);
    });

    test('search with short query returns empty list', () async {
      await viewModel.search('a');

      check(viewModel.results).isEmpty();
      check(viewModel.query).equals('a');
    });

    test('clearSearch resets state', () async {
      await viewModel.search('Football');
      viewModel.clearSearch();

      check(viewModel.query).isEmpty();
      check(viewModel.results).isEmpty();
    });
  });
}
