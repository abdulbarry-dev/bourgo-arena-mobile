import 'package:bourgo_arena_mobile/data/services/activity_service.dart';
import 'package:bourgo_arena_mobile/data/services/data_service.dart';
import 'package:bourgo_arena_mobile/domain/entities/search_result.dart';
import 'package:bourgo_arena_mobile/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

/// ViewModel for the Global Search screen.
class SearchViewModel extends ChangeNotifier {
  final ActivityService _activityService;
  final DataService _dataService;
  final AppLocalizations _l10n;

  SearchViewModel({
    required ActivityService activityService,
    required DataService dataService,
    required AppLocalizations l10n,
  }) : _activityService = activityService,
       _dataService = dataService,
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
      final activities = _activityService.activities;
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

      // 2. Search Courses
      final courses = await _dataService.getCourses();
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
