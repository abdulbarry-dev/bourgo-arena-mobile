import 'package:bourgo_arena_mobile/core/utils/result.dart';
import 'package:bourgo_arena_mobile/domain/entities/search_result.dart';
import 'package:bourgo_arena_mobile/domain/usecases/search/search_use_case.dart';
import 'package:bourgo_arena_mobile/l10n/app_localizations.dart';
import 'package:bourgo_arena_mobile/presentation/search/search_view_model.dart';
import 'package:checks/checks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockSearchUseCase extends Mock implements SearchUseCase {}

class MockAppLocalizations extends Mock implements AppLocalizations {}

void main() {
  late SearchViewModel viewModel;
  late MockSearchUseCase mockSearchUseCase;
  late MockAppLocalizations mockL10n;

  final List<SearchResult> testResults = [
    const SearchResult(
      title: 'Football',
      subtitle: 'Sports',
      type: SearchResultType.activity,
      iconKey: 'sports_soccer',
      route: '/activity/1',
    ),
    const SearchResult(
      title: 'Yoga',
      subtitle: 'Wellness',
      type: SearchResultType.course,
      iconKey: 'self_improvement',
      route: '/course/1',
    ),
  ];

  setUp(() {
    mockSearchUseCase = MockSearchUseCase();
    mockL10n = MockAppLocalizations();

    // Mock localization strings used in SearchViewModel._searchSettings
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
      searchUseCase: mockSearchUseCase,
      l10n: mockL10n,
    );
  });

  group('SearchViewModel', () {
    test('search filters results across all categories', () async {
      when(
        () => mockSearchUseCase(any()),
      ).thenAnswer((_) async => Result.success([testResults[0]]));

      await viewModel.search('Foot');

      check(viewModel.results).has((l) => l.length, 'length').equals(1);
      check(viewModel.results.first.title).equals('Football');
      check(viewModel.results.first.type).equals(SearchResultType.activity);
    });

    test('search finds courses', () async {
      when(
        () => mockSearchUseCase(any()),
      ).thenAnswer((_) async => Result.success([testResults[1]]));

      await viewModel.search('Yoga');

      check(viewModel.results).has((l) => l.length, 'length').equals(1);
      check(viewModel.results.first.title).equals('Yoga');
      check(viewModel.results.first.type).equals(SearchResultType.course);
    });

    test('search finds settings', () async {
      when(
        () => mockSearchUseCase(any()),
      ).thenAnswer((_) async => Result.success([]));

      await viewModel.search('Profile');

      // Should find "Edit Profile" from local settings search
      check(viewModel.results).has((l) => l.length, 'length').equals(1);
      check(viewModel.results.first.title).equals('Edit Profile');
      check(viewModel.results.first.type).equals(SearchResultType.setting);
    });

    test('search with short query returns empty list', () async {
      await viewModel.search('a');

      check(viewModel.results).isEmpty();
      check(viewModel.query).equals('a');
    });
  });
}
