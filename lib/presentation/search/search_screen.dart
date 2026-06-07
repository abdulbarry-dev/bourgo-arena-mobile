import 'package:bourgo_arena_mobile/core/di/locator.dart';
import 'package:bourgo_arena_mobile/domain/usecases/search/search_use_case.dart';
import 'package:bourgo_arena_mobile/domain/entities/search_result.dart';
import 'package:bourgo_arena_mobile/l10n/app_localizations.dart';
import 'package:bourgo_arena_mobile/presentation/common/empty_state.dart';
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
          searchUseCase: locator<SearchUseCase>(),
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
    final l10n = AppLocalizations.of(context)!;

    if (_viewModel == null) return const SizedBox.shrink();

    return ListenableBuilder(
      listenable: _viewModel!,
      builder: (context, _) {
        return Scaffold(
          appBar: AppBar(
            titleSpacing: 0,
            elevation: 0,
            scrolledUnderElevation: 0,
            title: Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Container(
                height: 48,
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainerHighest.withValues(
                    alpha: 0.4,
                  ),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: TextField(
                  controller: _searchController,
                  focusNode: _focusNode,
                  onChanged: _viewModel!.search,
                  textInputAction: TextInputAction.search,
                  decoration: InputDecoration(
                    hintText: l10n.searchHint,
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                    hintStyle: theme.textTheme.bodyLarge?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant.withValues(
                        alpha: 0.8,
                      ),
                    ),
                    suffixIcon: ValueListenableBuilder<TextEditingValue>(
                      valueListenable: _searchController,
                      builder: (context, value, _) {
                        if (value.text.isEmpty) {
                          return const SizedBox.shrink();
                        }
                        return IconButton(
                          icon: Icon(
                            Symbols.close,
                            size: 20,
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                          onPressed: () {
                            _searchController.clear();
                            _viewModel!.clearSearch();
                          },
                        );
                      },
                    ),
                  ),
                  style: theme.textTheme.bodyLarge,
                ),
              ),
            ),
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

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5),
        ),
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 8,
          ),
          leading: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: theme.colorScheme.primaryContainer.withValues(alpha: 0.6),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(
              _iconForKey(result.iconKey),
              size: 24,
              color: theme.colorScheme.primary,
            ),
          ),
          title: Text(
            result.title,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              letterSpacing: 0.2,
            ),
          ),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 4.0),
            child: Text(
              result.subtitle,
              style: theme.textTheme.labelMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          trailing: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest.withValues(
                alpha: 0.4,
              ),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Symbols.arrow_forward_ios,
              size: 14,
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          onTap: () {
            if (result.extra != null) {
              context.push(result.route, extra: result.extra);
            }
          },
        ),
      ),
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
    return EmptyState(
      title: AppLocalizations.of(context)!.searchRecentTitle,
      message: AppLocalizations.of(context)!.searchRecentSubtitle,
      icon: Symbols.search,
    );
  }
}

class _NoResultsPlaceholder extends StatelessWidget {
  final String query;

  const _NoResultsPlaceholder({required this.query});

  @override
  Widget build(BuildContext context) {
    return EmptyState(
      title: AppLocalizations.of(context)!.searchNoResultsTitle(query),
      message: AppLocalizations.of(context)!.searchNoResultsSubtitle,
      icon: Symbols.search_off,
    );
  }
}
