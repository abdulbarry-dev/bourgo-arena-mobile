import 'package:bourgo_arena_mobile/domain/usecases/search/search_use_case.dart';
import 'package:bourgo_arena_mobile/domain/entities/search_result.dart';
import 'package:bourgo_arena_mobile/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

/// ViewModel for the Global Search screen.
class SearchViewModel extends ChangeNotifier {
  final SearchUseCase _searchUseCase;
  final AppLocalizations _l10n;

  SearchViewModel({
    required SearchUseCase searchUseCase,
    required AppLocalizations l10n,
  }) : _searchUseCase = searchUseCase,
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

      // 1. Remote Search (Activities, Courses, etc.)
      final searchResult = await _searchUseCase(query);
      searchResult.when(
        success: (results) => allResults.addAll(results),
        failure: (failure) => null, // Log or handle error if needed
      );

      // 2. Local Search (Settings & Navigation)
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
        iconKey: 'person',
        route: '/edit-profile',
      ),
      SearchResult(
        title: _l10n.settingsChangePassword,
        subtitle: _l10n.settingsSectionAccount,
        type: SearchResultType.setting,
        iconKey: 'lock',
        route: '/change-password',
      ),
      SearchResult(
        title: _l10n.profileHistory,
        subtitle: _l10n.settingsSectionAccount,
        type: SearchResultType.setting,
        iconKey: 'history',
        route: '/history',
      ),
      SearchResult(
        title: _l10n.settingsLanguage,
        subtitle: _l10n.settingsSectionPreferences,
        type: SearchResultType.setting,
        iconKey: 'language',
        route: '/settings',
      ),
      SearchResult(
        title: _l10n.settingsPrivacy,
        subtitle: _l10n.settingsSectionLegal,
        type: SearchResultType.setting,
        iconKey: 'gavel',
        route: '/privacy',
      ),
      SearchResult(
        title: _l10n.settingsTerms,
        subtitle: _l10n.settingsSectionLegal,
        type: SearchResultType.setting,
        iconKey: 'description',
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
