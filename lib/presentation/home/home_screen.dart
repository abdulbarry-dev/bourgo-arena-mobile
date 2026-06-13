import 'package:bourgo_arena_mobile/core/constants/app_constants.dart';
import 'package:bourgo_arena_mobile/core/di/locator.dart';
import 'package:bourgo_arena_mobile/core/utils/auth_utils.dart';
import 'package:bourgo_arena_mobile/domain/entities/activity.dart';
import 'package:bourgo_arena_mobile/domain/entities/course.dart';
import 'package:bourgo_arena_mobile/domain/entities/event.dart';
import 'package:bourgo_arena_mobile/domain/entities/service.dart';
import 'package:bourgo_arena_mobile/presentation/common/widgets/brand_logo.dart';
import 'package:bourgo_arena_mobile/presentation/common/empty_state.dart';
import 'package:bourgo_arena_mobile/presentation/common/widgets/premium_network_image.dart';
import 'package:bourgo_arena_mobile/presentation/home/home_view_model.dart';
import 'package:bourgo_arena_mobile/presentation/home/widgets/ticker_strip.dart';
import 'package:bourgo_arena_mobile/core/theme/bourgo_theme.dart';
import 'dart:async';

import 'package:bourgo_arena_mobile/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:shimmer/shimmer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final HomeViewModel _viewModel;

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
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return ListenableBuilder(
      listenable: _viewModel,
      builder: (context, _) {
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
                onPressed: () => context.push('/search'),
                icon: const Icon(Symbols.search),
                tooltip: AppLocalizations.of(context)!.homeGlobalSearchTooltip,
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
                const SliverToBoxAdapter(child: _StaticHeroSection()),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: TickerStrip(
                      text: l10n.homeTicker,
                      backgroundColor: theme.colorScheme.primary,
                      textColor: Colors.black,
                    ),
                  ),
                ),
                _ServicesHeroSection(
                  services: _viewModel.services,
                  isLoading: _viewModel.servicesLoading,
                  error: _viewModel.servicesError,
                  onRetry: () => _viewModel.loadHomeData(),
                  onServiceTap: (service) =>
                      context.push('/services/${service.id}', extra: service),
                ),
                if (_viewModel.servicesLoading)
                  _RotatingServiceHeroSkeleton()
                else if (_viewModel.services.isNotEmpty)
                  _RotatingServiceHero(
                    services: _viewModel.services,
                    onServiceTap: (service) =>
                        context.push('/services/${service.id}', extra: service),
                  ),
                const SliverToBoxAdapter(child: SizedBox(height: 12)),

                _DashboardSection(
                  title: AppLocalizations.of(context)!.homeEventsTitle,
                  icon: Symbols.emoji_events,
                  accentColor: Colors.purple.shade400,
                  isLoading: _viewModel.eventsLoading,
                  error: _viewModel.eventsError,
                  isEmpty: _viewModel.events.isEmpty,
                  itemCount: _viewModel.events.length,
                  cardWidth: 200,
                  onSeeAll: () => context.push('/events'),
                  onRetry: () => _viewModel.loadHomeData(),
                  itemBuilder: (context, index) => _EventCard(
                    event: _viewModel.events[index],
                    onTap: () => context.push(
                      '/events/${_viewModel.events[index].id}',
                      extra: _viewModel.events[index],
                    ),
                  ),
                ),

                _DashboardSection(
                  title: AppLocalizations.of(context)!.homeCoursesTitle,
                  icon: Symbols.school,
                  accentColor: Colors.orange.shade400,
                  isLoading: _viewModel.coursesLoading,
                  error: _viewModel.coursesError,
                  isEmpty: _viewModel.courses.isEmpty,
                  itemCount: _viewModel.courses.length,
                  cardWidth: 200,
                  onSeeAll: () => context.push('/courses'),
                  onRetry: () => _viewModel.loadHomeData(),
                  itemBuilder: (context, index) => _CourseCard(
                    course: _viewModel.courses[index],
                    onTap: () => context.push(
                      '/courses/${_viewModel.courses[index].id}',
                      extra: _viewModel.courses[index],
                    ),
                  ),
                ),

                _DashboardSection(
                  title: AppLocalizations.of(context)!.homeActivitiesTitle,
                  icon: Symbols.sports_soccer,
                  accentColor: Colors.teal.shade400,
                  isLoading: _viewModel.activitiesLoading,
                  error: _viewModel.activitiesError,
                  isEmpty: _viewModel.activities.isEmpty,
                  itemCount: _viewModel.activities.length,
                  cardWidth: 200,
                  onSeeAll: () => context.push('/activities'),
                  onRetry: () => _viewModel.loadHomeData(),
                  itemBuilder: (context, index) => _ActivityCard(
                    activity: _viewModel.activities[index],
                    onTap: () => context.push(
                      '/activities/${_viewModel.activities[index].id}',
                      extra: _viewModel.activities[index],
                    ),
                  ),
                ),

                const SliverToBoxAdapter(child: SizedBox(height: 100)),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _ServicesHeroSection extends SliverToBoxAdapter {
  _ServicesHeroSection({
    required List<Service> services,
    required bool isLoading,
    required String? error,
    required VoidCallback onRetry,
    required void Function(Service service) onServiceTap,
  }) : super(
         child: _ServicesHeroContent(
           services: services,
           isLoading: isLoading,
           error: error,
           onRetry: onRetry,
           onServiceTap: onServiceTap,
         ),
       );
}

class _ServicesHeroContent extends StatelessWidget {
  final List<Service> services;
  final bool isLoading;
  final String? error;
  final VoidCallback onRetry;
  final void Function(Service service) onServiceTap;

  const _ServicesHeroContent({
    required this.services,
    required this.isLoading,
    this.error,
    required this.onRetry,
    required this.onServiceTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (isLoading) {
      return _ServicesSkeletonRow();
    }
    if (error != null) {
      return SizedBox(
        height: 180,
        child: Center(
          child: TextButton.icon(
            onPressed: onRetry,
            icon: const Icon(Symbols.refresh, size: 16),
            label: Text(AppLocalizations.of(context)!.homeRetryButton),
          ),
        ),
      );
    }
    if (services.isEmpty) {
      return Padding(
        padding: const EdgeInsets.only(top: 24),
        child: _EmptyRow(
          message: AppLocalizations.of(context)!.homeServicesEmpty,
          accentColor: Colors.blueGrey,
          icon: Symbols.grid_view,
          iconSize: 32,
        ),
      );
    }

    return Container(
      height: 180,
      margin: const EdgeInsets.fromLTRB(24, 24, 24, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Symbols.grid_view,
                size: 20,
                color: theme.colorScheme.primary,
              ),
              const SizedBox(width: 8),
              Text(
                AppLocalizations.of(context)!.homeServicesTitle,
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.5,
                  color: theme.colorScheme.onSurface,
                ),
              ),
              const Spacer(),
              GestureDetector(
                onTap: () => context.push('/services'),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.homeSeeAllButton,
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1.5,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Icon(
                      Symbols.chevron_right,
                      size: 16,
                      color: theme.colorScheme.primary,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: services.length,
              separatorBuilder: (_, _) => const SizedBox(width: 12),
              itemBuilder: (context, index) {
                final service = services[index];
                final hasImage = service.imageUrl != null;
                return GestureDetector(
                  onTap: () => onServiceTap(service),
                  child: Container(
                    width: 100,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: Column(
                      children: [
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              color: hasImage
                                  ? null
                                  : theme.colorScheme.primary.withValues(
                                      alpha: 0.08,
                                    ),
                            ),
                            child: hasImage
                                ? PremiumNetworkImage(
                                    imageUrl: service.imageUrl!,
                                    fit: BoxFit.cover,
                                  )
                                : Icon(
                                    Symbols.grid_view,
                                    size: 28,
                                    color: theme.colorScheme.primary.withValues(
                                      alpha: 0.4,
                                    ),
                                  ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 8,
                          ),
                          child: Text(
                            service.name.toUpperCase(),
                            style: theme.textTheme.labelSmall?.copyWith(
                              fontWeight: FontWeight.w900,
                              fontSize: 10,
                              color: theme.colorScheme.onSurface,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _RotatingServiceHero extends SliverToBoxAdapter {
  _RotatingServiceHero({
    required List<Service> services,
    required void Function(Service service) onServiceTap,
  }) : super(
         child: _RotatingServiceHeroContent(
           services: services,
           onServiceTap: onServiceTap,
         ),
       );
}

class _RotatingServiceHeroContent extends StatefulWidget {
  final List<Service> services;
  final void Function(Service service) onServiceTap;

  const _RotatingServiceHeroContent({
    required this.services,
    required this.onServiceTap,
  });

  @override
  State<_RotatingServiceHeroContent> createState() =>
      _RotatingServiceHeroContentState();
}

class _RotatingServiceHeroContentState
    extends State<_RotatingServiceHeroContent> {
  int _rotationIndex = 0;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void didUpdateWidget(covariant _RotatingServiceHeroContent oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.services.length != widget.services.length) {
      _rotationIndex = 0;
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Timer? _timer;
  static const _interval = Duration(seconds: 5);

  void _startTimer() {
    if (widget.services.length <= 1) return;
    _timer?.cancel();
    _timer = Timer.periodic(_interval, (_) => _advance());
  }

  void _advance() {
    if (!mounted) return;
    setState(() {
      _rotationIndex = (_rotationIndex + 1) % widget.services.length;
    });
  }

  Service get _currentService =>
      widget.services[_rotationIndex % widget.services.length];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final service = _currentService;
    final hasImage = service.imageUrl != null;
    final stats = [
      if (service.plansCount > 0)
        '${service.plansCount} ${AppLocalizations.of(context)!.homeServicePlans}',
      if (service.coursesCount > 0)
        '${service.coursesCount} ${AppLocalizations.of(context)!.homeServiceCourses}',
      if (service.eventsCount > 0)
        '${service.eventsCount} ${AppLocalizations.of(context)!.homeServiceEvents}',
    ];

    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
      child: GestureDetector(
        onTap: () => widget.onServiceTap(service),
        child: Container(
          height: 220,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: theme.colorScheme.surfaceContainerHighest,
          ),
          clipBehavior: Clip.antiAlias,
          child: Stack(
            fit: StackFit.expand,
            children: [
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 600),
                transitionBuilder: (child, animation) =>
                    FadeTransition(opacity: animation, child: child),
                child: SizedBox(
                  key: ValueKey(service.id),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      if (hasImage)
                        PremiumNetworkImage(
                          imageUrl: service.imageUrl!,
                          fit: BoxFit.cover,
                        )
                      else
                        Container(
                          color: theme.colorScheme.primary.withValues(
                            alpha: 0.08,
                          ),
                          child: Icon(
                            Symbols.grid_view,
                            size: 64,
                            color: theme.colorScheme.primary.withValues(
                              alpha: 0.2,
                            ),
                          ),
                        ),
                      Positioned.fill(
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.transparent,
                                Colors.black.withValues(alpha: 0.7),
                              ],
                              stops: const [0.4, 1.0],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                left: 20,
                right: 20,
                bottom: 20,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      service.name.toUpperCase(),
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontFamily: AppConstants.displayFontFamily,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    if (stats.isNotEmpty)
                      Row(
                        children: stats.map((stat) {
                          final isLast = stats.last == stat;
                          return Padding(
                            padding: EdgeInsets.only(right: isLast ? 0 : 8),
                            child: _StatBadge(label: stat),
                          );
                        }).toList(),
                      ),
                    const SizedBox(height: 10),
                    SizedBox(
                      width: 120,
                      height: 36,
                      child: ElevatedButton(
                        onPressed: () => widget.onServiceTap(service),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: theme.colorScheme.primary,
                          foregroundColor: theme.colorScheme.onPrimary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          AppLocalizations.of(context)!.homeExploreButton,
                          style: const TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: 12,
                            letterSpacing: 1,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              if (widget.services.length > 1)
                Positioned(
                  right: 16,
                  bottom: 16,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: List.generate(widget.services.length, (i) {
                      final isActive = i == _rotationIndex;
                      return Container(
                        margin: const EdgeInsets.only(left: 5),
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isActive
                              ? Colors.white
                              : Colors.white.withValues(alpha: 0.4),
                        ),
                      );
                    }),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatBadge extends StatelessWidget {
  final String label;

  const _StatBadge({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label.toUpperCase(),
        style: const TextStyle(
          color: Colors.white,
          fontSize: 10,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback? onSeeAll;
  final Color accentColor;

  const _SectionHeader({
    required this.title,
    required this.icon,
    this.onSeeAll,
    required this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
      child: Row(
        children: [
          Icon(icon, size: 20, color: accentColor),
          const SizedBox(width: 8),
          Text(
            title,
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w900,
              letterSpacing: 1.5,
              color: theme.colorScheme.onSurface,
            ),
          ),
          const Spacer(),
          if (onSeeAll != null)
            GestureDetector(
              onTap: onSeeAll,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    AppLocalizations.of(context)!.homeSeeAllButton,
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: accentColor,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.5,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Icon(Symbols.chevron_right, size: 16, color: accentColor),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _DashboardSection extends SliverToBoxAdapter {
  _DashboardSection({
    required String title,
    required IconData icon,
    required Color accentColor,
    required bool isLoading,
    required String? error,
    required bool isEmpty,
    required int itemCount,
    required double cardWidth,
    required VoidCallback? onSeeAll,
    required VoidCallback onRetry,
    required Widget Function(BuildContext context, int index) itemBuilder,
  }) : super(
         child: Column(
           crossAxisAlignment: CrossAxisAlignment.start,
           children: [
             _SectionHeader(
               title: title,
               icon: icon,
               onSeeAll: onSeeAll,
               accentColor: accentColor,
             ),
             if (isLoading)
               _SkeletonRow(cardWidth: cardWidth)
             else if (error != null)
               _ErrorRow(
                 message: error,
                 accentColor: accentColor,
                 onRetry: onRetry,
               )
             else if (isEmpty)
               Builder(
                 builder: (context) => _EmptyRow(
                   message:
                       '${AppLocalizations.of(context)!.homeNo} $title ${AppLocalizations.of(context)!.homeAvailable}',
                   accentColor: accentColor,
                   icon: icon,
                 ),
               )
             else
               SizedBox(
                 height: 200,
                 child: ListView.builder(
                   scrollDirection: Axis.horizontal,
                   padding: const EdgeInsets.only(left: 24, right: 8),
                   itemCount: itemCount,
                   itemBuilder: (context, index) => Padding(
                     padding: const EdgeInsets.only(right: 12),
                     child: SizedBox(
                       width: cardWidth,
                       child: itemBuilder(context, index),
                     ),
                   ),
                 ),
               ),
           ],
         ),
       );
}

class _SkeletonRow extends StatelessWidget {
  final double cardWidth;

  const _SkeletonRow({required this.cardWidth});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final baseColor = theme.colorScheme.onSurface.withValues(alpha: 0.06);
    final highlightColor = theme.colorScheme.onSurface.withValues(alpha: 0.13);

    return SizedBox(
      height: 200,
      child: Shimmer.fromColors(
        baseColor: baseColor,
        highlightColor: highlightColor,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.only(left: 24, right: 8),
          itemCount: 3,
          itemBuilder: (context, index) => Padding(
            padding: const EdgeInsets.only(right: 12),
            child: SizedBox(
              width: cardWidth,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.08),
                  ),
                ),
                clipBehavior: Clip.antiAlias,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Image area — mirrors flex:3 of _CourseCard
                    const Expanded(
                      flex: 3,
                      child: ColoredBox(color: Colors.white),
                    ),
                    // Content area — mirrors flex:2 of _CourseCard
                    Expanded(
                      flex: 2,
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              height: 13,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(6),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Container(
                              height: 11,
                              width: 80,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(6),
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
        ),
      ),
    );
  }
}

/// Skeleton for the small service chip row.
/// Mirrors the real service tile: 100 px wide, square-ish image area,
/// then a centred single-line name bone at the bottom.
class _ServicesSkeletonRow extends StatelessWidget {
  const _ServicesSkeletonRow();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final baseColor = theme.colorScheme.onSurface.withValues(alpha: 0.06);
    final highlightColor = theme.colorScheme.onSurface.withValues(alpha: 0.13);

    return Container(
      height: 180,
      margin: const EdgeInsets.fromLTRB(24, 24, 24, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header row skeleton — title bone + SEE ALL bone
          Shimmer.fromColors(
            baseColor: baseColor,
            highlightColor: highlightColor,
            child: Row(
              children: [
                Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  width: 110,
                  height: 14,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                const Spacer(),
                Container(
                  width: 56,
                  height: 12,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // Service chip tiles
          Expanded(
            child: Shimmer.fromColors(
              baseColor: baseColor,
              highlightColor: highlightColor,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: 5,
                separatorBuilder: (_, __) => const SizedBox(width: 12),
                itemBuilder: (context, index) => Container(
                  width: 100,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Image area
                      const Expanded(
                        flex: 7,
                        child: ColoredBox(color: Colors.white),
                      ),
                      // Name label area
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 8,
                        ),
                        child: Center(
                          child: Container(
                            height: 10,
                            width: 64,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Skeleton for the rotating service hero card.
/// Mirrors the 220 px container: full-bleed shimmer image, gradient overlay
/// bone, service name bone, stat-badge bones, and explore button bone.
class _RotatingServiceHeroSkeleton extends SliverToBoxAdapter {
  _RotatingServiceHeroSkeleton()
    : super(child: const _RotatingServiceHeroSkeletonContent());
}

class _RotatingServiceHeroSkeletonContent extends StatelessWidget {
  const _RotatingServiceHeroSkeletonContent();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final baseColor = theme.colorScheme.onSurface.withValues(alpha: 0.06);
    final highlightColor = theme.colorScheme.onSurface.withValues(alpha: 0.13);

    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
      child: Shimmer.fromColors(
        baseColor: baseColor,
        highlightColor: highlightColor,
        child: Container(
          height: 220,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          clipBehavior: Clip.antiAlias,
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Full bleed image bone
              const ColoredBox(color: Colors.white),
              // Gradient-overlay area (bottom ~40%)
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: Container(
                  height: 110,
                  decoration: BoxDecoration(
                    // Slightly lighter so the bone lines below are visible
                    color: Colors.white.withValues(alpha: 0.6),
                  ),
                ),
              ),
              // Content bones at bottom-left
              const Positioned(
                left: 20,
                right: 20,
                bottom: 20,
                child: _HeroBones(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HeroBones extends StatelessWidget {
  const _HeroBones();

  Widget _bone({required double width, required double height}) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Service name bone
        _bone(width: 180, height: 22),
        const SizedBox(height: 8),
        // Stat badge bones
        Row(
          children: [
            _bone(width: 60, height: 18),
            const SizedBox(width: 8),
            _bone(width: 72, height: 18),
          ],
        ),
        const SizedBox(height: 12),
        // Explore button bone
        Container(
          width: 120,
          height: 36,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ],
    );
  }
}

class _ErrorRow extends StatelessWidget {
  final String message;
  final Color accentColor;
  final VoidCallback onRetry;

  const _ErrorRow({
    required this.message,
    required this.accentColor,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        height: 200,
        decoration: BoxDecoration(
          color: theme.colorScheme.error.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: theme.colorScheme.error.withValues(alpha: 0.15),
          ),
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Symbols.error,
                size: 28,
                color: theme.colorScheme.error.withValues(alpha: 0.5),
              ),
              const SizedBox(height: 8),
              Text(
                'Something went wrong',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 12),
              TextButton.icon(
                onPressed: onRetry,
                icon: const Icon(Symbols.refresh, size: 16),
                label: Text(AppLocalizations.of(context)!.commonRetry),
                style: TextButton.styleFrom(
                  foregroundColor: accentColor,
                  textStyle: const TextStyle(
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EmptyRow extends StatelessWidget {
  final String message;
  final Color accentColor;
  final IconData icon;
  final double iconSize;

  const _EmptyRow({
    required this.message,
    required this.accentColor,
    required this.icon,
    this.iconSize = 32,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: EmptyState(
        title: AppLocalizations.of(context)!.homeCarouselEmpty,
        message: message,
        icon: icon,
      ),
    );
  }
}

class _EventCard extends StatelessWidget {
  final Event event;
  final VoidCallback onTap;

  const _EventCard({required this.event, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = theme.extension<AppColors>()!;

    String? formattedDate;
    if (event.startDate != null) {
      try {
        formattedDate = DateFormat(
          'MMM d',
        ).format(DateTime.parse(event.startDate!));
      } catch (_) {
        formattedDate = event.startDate;
      }
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: appColors.bgElevated,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: appColors.bgBorder),
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(flex: 3, child: _buildImage(theme, appColors)),
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      event.name?.toUpperCase() ?? 'EVENT',
                      style: theme.textTheme.labelLarge?.copyWith(
                        fontFamily: AppConstants.displayFontFamily,
                        fontWeight: FontWeight.w900,
                        fontSize: 13,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const Spacer(),
                    if (formattedDate != null)
                      Row(
                        children: [
                          Icon(
                            Symbols.calendar_month,
                            size: 12,
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            formattedDate,
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImage(ThemeData theme, AppColors appColors) {
    final hasImage = event.images.isNotEmpty;

    return Container(
      decoration: BoxDecoration(
        color: hasImage ? null : Colors.purple.withValues(alpha: 0.1),
      ),
      child: hasImage
          ? PremiumNetworkImage(imageUrl: event.images.first, fit: BoxFit.cover)
          : Center(
              child: Icon(
                Symbols.emoji_events,
                size: 32,
                color: Colors.purple.shade300.withValues(alpha: 0.5),
              ),
            ),
    );
  }
}

class _CourseCard extends StatelessWidget {
  final Course course;
  final VoidCallback onTap;

  const _CourseCard({required this.course, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = theme.extension<AppColors>()!;
    final hasImage = course.images.isNotEmpty;
    final isActive = course.status == 'active';

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: appColors.bgElevated,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: appColors.bgBorder),
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              flex: 3,
              child: Container(
                decoration: BoxDecoration(
                  color: hasImage
                      ? null
                      : theme.colorScheme.surfaceContainerHighest,
                ),
                child: hasImage
                    ? PremiumNetworkImage(
                        imageUrl: course.images.first,
                        fit: BoxFit.cover,
                      )
                    : Center(
                        child: Icon(
                          Symbols.school,
                          size: 32,
                          color: theme.colorScheme.primary.withValues(
                            alpha: 0.3,
                          ),
                        ),
                      ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      course.name.toUpperCase(),
                      style: theme.textTheme.labelLarge?.copyWith(
                        fontFamily: AppConstants.displayFontFamily,
                        fontWeight: FontWeight.w900,
                        fontSize: 13,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const Spacer(),
                    if (course.status != null)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: isActive
                              ? theme.colorScheme.primary
                              : theme.colorScheme.onSurfaceVariant.withValues(
                                  alpha: 0.3,
                                ),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          course.status!.toUpperCase(),
                          style: TextStyle(
                            color: isActive
                                ? theme.colorScheme.onPrimary
                                : theme.colorScheme.onSurface,
                            fontSize: 9,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ActivityCard extends StatelessWidget {
  final Activity activity;
  final VoidCallback onTap;

  const _ActivityCard({required this.activity, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = theme.extension<AppColors>()!;
    final hasImage = activity.imageUrl.isNotEmpty;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: appColors.bgElevated,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: appColors.bgBorder),
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              flex: 3,
              child: Container(
                decoration: BoxDecoration(
                  color: hasImage ? null : Colors.teal.withValues(alpha: 0.1),
                ),
                child: hasImage
                    ? PremiumNetworkImage(
                        imageUrl: activity.imageUrl,
                        fit: BoxFit.cover,
                      )
                    : Center(
                        child: Icon(
                          Symbols.sports_soccer,
                          size: 32,
                          color: Colors.teal.shade300.withValues(alpha: 0.5),
                        ),
                      ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      activity.title.toUpperCase(),
                      style: theme.textTheme.labelLarge?.copyWith(
                        fontFamily: AppConstants.displayFontFamily,
                        fontWeight: FontWeight.w900,
                        fontSize: 13,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const Spacer(),
                    Row(
                      children: [
                        Text(
                          '${activity.basePrice.toStringAsFixed(0)} TND',
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: theme.colorScheme.primary,
                            fontWeight: FontWeight.w900,
                            fontSize: 11,
                          ),
                        ),
                        const Spacer(),
                        Icon(
                          Symbols.chevron_right,
                          size: 14,
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StaticHeroSection extends StatelessWidget {
  const _StaticHeroSection();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hour = DateTime.now().hour;
    final String greeting = (hour < 12)
        ? 'GOOD MORNING'
        : ((hour < 17) ? 'GOOD AFTERNOON' : 'GOOD EVENING');

    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 20),
      child: Container(
        height: 200,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          image: const DecorationImage(
            image: AssetImage('assets/images/background.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    Colors.black.withValues(alpha: 0.8),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
            Positioned(
              left: 20,
              bottom: 24,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    greeting,
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 2,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Discover Your\nNext Challenge',
                    style: theme.textTheme.headlineMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                      height: 1.1,
                      letterSpacing: -0.5,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
