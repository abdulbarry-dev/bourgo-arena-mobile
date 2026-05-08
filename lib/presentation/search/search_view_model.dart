import 'package:bourgo_arena_mobile/domain/usecases/activity/get_activities_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/course/get_courses_use_case.dart';
import 'package:bourgo_arena_mobile/domain/entities/search_result.dart';
import 'package:bourgo_arena_mobile/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

/// ViewModel for the Global Search screen.
class SearchViewModel extends ChangeNotifier {
  final GetActivitiesUseCase _getActivitiesUseCase;
  final GetCoursesUseCase _getCoursesUseCase;
  final AppLocalizations _l10n;

  SearchViewModel({
    required GetActivitiesUseCase getActivitiesUseCase,
    required GetCoursesUseCase getCoursesUseCase,
    required AppLocalizations l10n,
  }) : _getActivitiesUseCase = getActivitiesUseCase,
       _getCoursesUseCase = getCoursesUseCase,
       _l10n = l10n;

  String _query = '';
  String get query => _query;

  bool _isSearching = false;
  bool get isSearching => _isSearching;

  List<SearchResult> _results = [];
  List<SearchResult> get results => _results;

  /// Performs a global search across all available data sources.
  Future<void> search(String query) async {
    _query = query;
    if (query.length < 2) {
      _results = [];
      notifyListeners();
      return;
    }

    _isSearching = true;
    notifyListeners();

    try {
      final List<SearchResult> allResults = [];

      // 1. Search Activities
      final activitiesResult = await _getActivitiesUseCase();
      activitiesResult.when(
        success: (activities) {
          final activityMatches = activities.where(
            (a) =>
                a.title.toLowerCase().contains(query.toLowerCase()) ||
                a.category.toLowerCase().contains(query.toLowerCase()),
          );

          allResults.addAll(
            activityMatches.map(
              (a) => SearchResult(
                title: a.title,
                subtitle: a.category,
                type: SearchResultType.activity,
                icon: Symbols.sports_soccer,
                route: '/booking',
                extra: a,
              ),
            ),
          );
        },
        failure: (failure) => null,
      );

      // 2. Search Courses
      final coursesResult = await _getCoursesUseCase();
      coursesResult.when(
        success: (courses) {
          final courseMatches = courses.where(
            (c) =>
                c.title.toLowerCase().contains(query.toLowerCase()) ||
                c.instructor.toLowerCase().contains(query.toLowerCase()),
          );

          allResults.addAll(
            courseMatches.map(
              (c) => SearchResult(
                title: c.title,
                subtitle: '${c.instructor} • ${c.startTime}',
                type: SearchResultType.course,
                icon: Symbols.calendar_month,
                route: '/planning',
              ),
            ),
          );
        },
        failure: (failure) => null,
      );

      // 3. Search Settings & Navigation
      final settingsResults = _searchSettings(query);
      allResults.addAll(settingsResults);

      _results = allResults;
    } catch (e) {
      _results = [];
    } finally {
      _isSearching = false;
      notifyListeners();
    }
  }

  List<SearchResult> _searchSettings(String query) {
    final List<SearchResult> settings = [
      SearchResult(
        title: _l10n.settingsEditProfile,
        subtitle: _l10n.settingsSectionAccount,
        type: SearchResultType.setting,
        icon: Symbols.person,
        route: '/edit-profile',
      ),
      SearchResult(
        title: _l10n.settingsChangePassword,
        subtitle: _l10n.settingsSectionAccount,
        type: SearchResultType.setting,
        icon: Symbols.lock,
        route: '/change-password',
      ),
      SearchResult(
        title: _l10n.profileHistory,
        subtitle: _l10n.settingsSectionAccount,
        type: SearchResultType.setting,
        icon: Symbols.history,
        route: '/history',
      ),
      SearchResult(
        title: _l10n.settingsLanguage,
        subtitle: _l10n.settingsSectionPreferences,
        type: SearchResultType.setting,
        icon: Symbols.language,
        route: '/settings',
      ),
      SearchResult(
        title: _l10n.settingsPrivacy,
        subtitle: _l10n.settingsSectionLegal,
        type: SearchResultType.setting,
        icon: Symbols.gavel,
        route: '/privacy',
      ),
      SearchResult(
        title: _l10n.settingsTerms,
        subtitle: _l10n.settingsSectionLegal,
        type: SearchResultType.setting,
        icon: Symbols.description,
        route: '/terms',
      ),
    ];

    return settings
        .where(
          (s) =>
              s.title.toLowerCase().contains(query.toLowerCase()) ||
              s.subtitle.toLowerCase().contains(query.toLowerCase()),
        )
        .toList();
  }

  void clearSearch() {
    _query = '';
    _results = [];
    notifyListeners();
  }
}
