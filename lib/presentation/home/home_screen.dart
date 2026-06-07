import 'package:bourgo_arena_mobile/core/constants/app_constants.dart';
import 'package:bourgo_arena_mobile/core/di/locator.dart';
import 'package:bourgo_arena_mobile/core/utils/auth_utils.dart';
import 'package:bourgo_arena_mobile/l10n/app_localizations.dart';
import 'package:bourgo_arena_mobile/presentation/common/widgets/brand_logo.dart';
import 'package:bourgo_arena_mobile/presentation/home/home_view_model.dart';
import 'package:bourgo_arena_mobile/core/theme/bourgo_theme.dart';
import 'package:bourgo_arena_mobile/presentation/home/widgets/ticker_strip.dart';
import 'package:bourgo_arena_mobile/presentation/home/widgets/unified_offering_card.dart';
import 'package:bourgo_arena_mobile/presentation/home/models/unified_offering.dart';
import 'package:bourgo_arena_mobile/presentation/common/empty_state.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';

/// The home screen of Bourgo Arena.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final HomeViewModel _viewModel;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _viewModel = HomeViewModel(
      getActivitiesUseCase: locator(),
      getCoursesUseCase: locator(),
      getServicesUseCase: locator(),
      getEventsUseCase: locator(),
    );
    _viewModel.loadHomeData();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _viewModel.dispose();
    super.dispose();
  }

  void _onOfferingTapped(UnifiedOffering offering) {
    switch (offering.type) {
      case OfferingType.service:
        context.push('/services/${offering.id}', extra: offering.sourceEntity);
        break;
      case OfferingType.course:
        context.push('/courses/${offering.id}', extra: offering.sourceEntity);
        break;
      case OfferingType.event:
        context.push('/events/${offering.id}', extra: offering.sourceEntity);
        break;
      case OfferingType.activity:
        context.push(
          '/activities/${offering.id}',
          extra: offering.sourceEntity,
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = theme.extension<AppColors>()!;
    final l10n = AppLocalizations.of(context)!;

    return ListenableBuilder(
      listenable: _viewModel,
      builder: (context, _) {
        if (_viewModel.isLoading && _viewModel.filteredOfferings.isEmpty) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final timeOfDay = DateTime.now().hour;
        final greeting = timeOfDay < 12
            ? 'GOOD MORNING'
            : timeOfDay < 18
            ? 'GOOD AFTERNOON'
            : 'GOOD EVENING';

        return Scaffold(
          backgroundColor: theme.colorScheme.surface,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            title: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const BrandLogo(size: 32, isPremium: true),
                const SizedBox(width: 12),
                Flexible(
                  child: Text(
                    l10n.appName.toUpperCase(),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontFamily: AppConstants.displayFontFamily,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 2.0,
                      fontSize: 16,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                ),
              ],
            ),
            actions: [
              IconButton(
                onPressed: () {
                  context.push('/search');
                },
                icon: const Icon(Symbols.search),
                tooltip: 'Global Search',
              ),
              IconButton(
                onPressed: () {
                  if (ensureAuthenticated(context)) {
                    context.push('/notifications');
                  }
                },
                icon: const Icon(Symbols.notifications),
              ),
            ],
          ),
          body: RefreshIndicator(
            onRefresh: _viewModel.loadHomeData,
            child: CustomScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: [
                // Hero Section
                SliverToBoxAdapter(
                  child: Container(
                    height: 220,
                    margin: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(24),
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          Image.asset(
                            'assets/images/background.jpg',
                            fit: BoxFit.cover,
                            alignment: Alignment.centerRight,
                          ),
                          DecoratedBox(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.black.withValues(alpha: 0.18),
                                  Colors.black.withValues(alpha: 0.52),
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(24),
                            child: Align(
                              alignment: Alignment.bottomLeft,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    greeting,
                                    style: theme.textTheme.labelMedium
                                        ?.copyWith(
                                          color: theme.colorScheme.primary,
                                          fontWeight: FontWeight.w900,
                                          letterSpacing: 1.5,
                                        ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Discover Your\nNext Challenge',
                                    style: theme.textTheme.displaySmall
                                        ?.copyWith(
                                          color: Colors.white,
                                          fontFamily:
                                              AppConstants.displayFontFamily,
                                          fontWeight: FontWeight.bold,
                                          height: 1.1,
                                        ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // Ticker Strip
                SliverToBoxAdapter(
                  child: TickerStrip(
                    text: l10n.homeTicker,
                    backgroundColor: theme.colorScheme.primary,
                    textColor: theme.colorScheme.onPrimary,
                  ),
                ),

                const SliverToBoxAdapter(child: SizedBox(height: 32)),

                // Search Bar
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Container(
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surface,
                        borderRadius: BorderRadius.circular(32),
                        boxShadow: [
                          BoxShadow(
                            color: theme.shadowColor.withValues(alpha: 0.08),
                            blurRadius: 24,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: TextField(
                        controller: _searchController,
                        onChanged: _viewModel.setSearchQuery,
                        style: TextStyle(
                          color: theme.colorScheme.onSurface,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                        decoration: InputDecoration(
                          hintText: 'Search courses, events...',
                          hintStyle: TextStyle(
                            color: theme.colorScheme.onSurfaceVariant,
                            fontWeight: FontWeight.normal,
                          ),
                          prefixIcon: Padding(
                            padding: const EdgeInsets.only(left: 20, right: 12),
                            child: Icon(
                              Symbols.search,
                              color: theme.colorScheme.primary,
                              size: 24,
                            ),
                          ),
                          prefixIconConstraints: const BoxConstraints(
                            minWidth: 56,
                            minHeight: 56,
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
                                  color: theme.colorScheme.onSurfaceVariant,
                                  size: 20,
                                ),
                                onPressed: () {
                                  _searchController.clear();
                                  _viewModel.setSearchQuery('');
                                },
                              );
                            },
                          ),
                          filled: true,
                          fillColor: Colors.transparent,
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 18,
                            horizontal: 20,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(32),
                            borderSide: BorderSide.none,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(32),
                            borderSide: BorderSide.none,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(32),
                            borderSide: BorderSide(
                              color: theme.colorScheme.primary.withValues(
                                alpha: 0.3,
                              ),
                              width: 1.5,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                const SliverToBoxAdapter(child: SizedBox(height: 16)),

                // Filter Chips
                SliverPersistentHeader(
                  pinned: true,
                  delegate: _SliverFilterDelegate(
                    child: Container(
                      color: appColors.bgSurface.withValues(alpha: 0.95),
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 16,
                        ),
                        children: [
                          _buildFilterChip('ALL', null, theme, appColors),
                          _buildFilterChip(
                            'SERVICES',
                            OfferingType.service,
                            theme,
                            appColors,
                          ),
                          _buildFilterChip(
                            'COURSES',
                            OfferingType.course,
                            theme,
                            appColors,
                          ),
                          _buildFilterChip(
                            'EVENTS',
                            OfferingType.event,
                            theme,
                            appColors,
                          ),
                          _buildFilterChip(
                            'ACTIVITIES',
                            OfferingType.activity,
                            theme,
                            appColors,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // Unified Feed
                SliverPadding(
                  padding: const EdgeInsets.all(24),
                  sliver: _viewModel.filteredOfferings.isEmpty
                      ? SliverToBoxAdapter(
                          child: EmptyState(
                            title: 'No results found',
                            message:
                                'Try adjusting your search or filter criteria.',
                            icon: Symbols.search_off,
                          ),
                        )
                      : SliverList(
                          delegate: SliverChildBuilderDelegate((
                            context,
                            index,
                          ) {
                            final offering =
                                _viewModel.filteredOfferings[index];
                            return UnifiedOfferingCard(
                              offering: offering,
                              onTap: () => _onOfferingTapped(offering),
                            );
                          }, childCount: _viewModel.filteredOfferings.length),
                        ),
                ),

                const SliverToBoxAdapter(
                  child: SizedBox(height: 100),
                ), // Bottom nav spacing
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildFilterChip(
    String label,
    OfferingType? type,
    ThemeData theme,
    AppColors appColors,
  ) {
    final isSelected = _viewModel.selectedFilterType == type;
    final isDark = theme.brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.only(right: 12),
      child: GestureDetector(
        onTap: () {
          _viewModel.setFilterType(type);
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOutCubic,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          decoration: BoxDecoration(
            color: isSelected
                ? theme.colorScheme.primary
                : appColors.bgElevated,
            borderRadius: BorderRadius.circular(30),
            border: Border.all(
              color: isSelected
                  ? theme.colorScheme.primary
                  : appColors.bgBorder,
              width: 1.5,
            ),
            boxShadow: isSelected && isDark
                ? [
                    BoxShadow(
                      color: appColors.brandPrimaryGlow,
                      blurRadius: 12,
                      spreadRadius: 2,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : [],
          ),
          child: Center(
            child: AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 300),
              style: TextStyle(
                fontFamily: theme.textTheme.labelLarge?.fontFamily,
                fontSize: 14,
                fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                letterSpacing: 0.5,
                color: isSelected
                    ? theme.colorScheme.onPrimary
                    : theme.colorScheme.onSurfaceVariant,
              ),
              child: Text(label),
            ),
          ),
        ),
      ),
    );
  }
}

class _SliverFilterDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;
  _SliverFilterDelegate({required this.child});

  @override
  double get minExtent => 72.0;
  @override
  double get maxExtent => 72.0;
  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) => child;
  @override
  bool shouldRebuild(covariant _SliverFilterDelegate oldDelegate) => true;
}
