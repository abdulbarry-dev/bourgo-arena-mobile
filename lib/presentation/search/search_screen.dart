import 'package:bourgo_arena_mobile/core/di/locator.dart';
import 'package:bourgo_arena_mobile/domain/usecases/activity/get_activities_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/course/get_courses_use_case.dart';
import 'package:bourgo_arena_mobile/domain/entities/search_result.dart';
import 'package:bourgo_arena_mobile/l10n/app_localizations.dart';
import 'package:bourgo_arena_mobile/presentation/search/search_view_model.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';

/// Screen for global application search.
class SearchScreen extends StatefulWidget {
  final SearchViewModel? viewModel;
  const SearchScreen({super.key, this.viewModel});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  SearchViewModel? _viewModel;
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _viewModel ??=
        widget.viewModel ??
        SearchViewModel(
          getActivitiesUseCase: locator<GetActivitiesUseCase>(),
          getCoursesUseCase: locator<GetCoursesUseCase>(),
          l10n: AppLocalizations.of(context)!,
        );
  }

  @override
  void initState() {
    super.initState();

    // Auto-focus the search bar
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _focusNode.dispose();
    _viewModel?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (_viewModel == null) return const SizedBox.shrink();

    return ListenableBuilder(
      listenable: _viewModel!,
      builder: (context, _) {
        return Scaffold(
          appBar: AppBar(
            titleSpacing: 0,
            title: Padding(
              padding: const EdgeInsets.only(right: 16),
              child: TextField(
                controller: _searchController,
                focusNode: _focusNode,
                onChanged: _viewModel!.search,
                decoration: InputDecoration(
                  hintText: 'Search activities, courses, settings...',
                  border: InputBorder.none,
                  hintStyle: theme.textTheme.bodyLarge?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant.withAlpha(150),
                  ),
                ),
                style: theme.textTheme.bodyLarge,
              ),
            ),
            actions: [
              if (_searchController.text.isNotEmpty)
                IconButton(
                  icon: const Icon(Symbols.close),
                  onPressed: () {
                    _searchController.clear();
                    _viewModel!.clearSearch();
                  },
                ),
            ],
          ),
          body: Column(
            children: [
              if (_viewModel!.isSearching)
                const LinearProgressIndicator()
              else
                const Divider(height: 1),

              Expanded(child: _buildContent(context)),
            ],
          ),
        );
      },
    );
  }

  Widget _buildContent(BuildContext context) {
    if (_viewModel == null || _viewModel!.query.isEmpty) {
      return _RecentSearchesPlaceholder();
    }

    if (!_viewModel!.isSearching && _viewModel!.results.isEmpty) {
      return _NoResultsPlaceholder(query: _viewModel!.query);
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: _viewModel!.results.length,
      itemBuilder: (context, index) {
        final result = _viewModel!.results[index];
        return _SearchResultTile(result: result);
      },
    );
  }
}

class _SearchResultTile extends StatelessWidget {
  final SearchResult result;

  const _SearchResultTile({required this.result});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainerHighest,
          shape: BoxShape.circle,
        ),
        child: Icon(
          _iconForKey(result.iconKey),
          size: 20,
          color: theme.colorScheme.primary,
        ),
      ),
      title: Text(
        result.title,
        style: theme.textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.bold,
        ),
      ),
      subtitle: Text(
        result.subtitle,
        style: theme.textTheme.labelMedium?.copyWith(
          color: theme.colorScheme.onSurfaceVariant,
        ),
      ),
      trailing: const Icon(Symbols.chevron_right, size: 20),
      onTap: () {
        if (result.extra != null) {
          context.push(result.route, extra: result.extra);
        } else {
          context.push(result.route);
        }
      },
    );
  }

  IconData _iconForKey(String key) {
    const Map<String, IconData> iconMap = {
      'sports_soccer': Symbols.sports_soccer,
      'calendar_month': Symbols.calendar_month,
      'person': Symbols.person,
      'lock': Symbols.lock,
      'history': Symbols.history,
      'language': Symbols.language,
      'gavel': Symbols.gavel,
      'description': Symbols.description,
      'search': Symbols.search,
      'search_off': Symbols.search_off,
    };

    return iconMap[key] ?? Symbols.help; // fallback icon
  }
}

class _RecentSearchesPlaceholder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Symbols.search,
            size: 64,
            color: theme.colorScheme.outline.withAlpha(50),
          ),
          const SizedBox(height: 16),
          Text(
            'Global Search',
            style: theme.textTheme.titleMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 48),
            child: Text(
              'Find activities, courses, or settings across the app.',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant.withAlpha(150),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _NoResultsPlaceholder extends StatelessWidget {
  final String query;

  const _NoResultsPlaceholder({required this.query});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Symbols.search_off,
            size: 64,
            color: theme.colorScheme.error.withAlpha(50),
          ),
          const SizedBox(height: 16),
          Text('No results for "$query"', style: theme.textTheme.titleMedium),
          const SizedBox(height: 8),
          Text(
            'Try different keywords or check spelling.',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
