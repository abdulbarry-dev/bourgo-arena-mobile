import 'package:bourgo_arena_mobile/core/constants/app_constants.dart';
import 'package:bourgo_arena_mobile/core/di/locator.dart';
import 'package:bourgo_arena_mobile/core/utils/auth_utils.dart';
import 'package:bourgo_arena_mobile/domain/entities/activity.dart';
import 'package:bourgo_arena_mobile/domain/entities/course.dart';
import 'package:bourgo_arena_mobile/domain/entities/event.dart';
import 'package:bourgo_arena_mobile/domain/entities/service.dart';
import 'package:bourgo_arena_mobile/presentation/common/widgets/brand_logo.dart';
import 'package:bourgo_arena_mobile/presentation/common/widgets/premium_network_image.dart';
import 'package:bourgo_arena_mobile/presentation/home/home_view_model.dart';
import 'package:bourgo_arena_mobile/core/theme/bourgo_theme.dart';

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
                _ServicesHeroSection(
                  services: _viewModel.services,
                  isLoading: _viewModel.servicesLoading,
                  error: _viewModel.servicesError,
                  onRetry: () => _viewModel.loadHomeData(),
                  onServiceTap: (service) =>
                      context.push('/services/${service.id}', extra: service),
                ),
                if (_viewModel.services.isNotEmpty && !_viewModel.servicesLoading)
                  _FeaturedServiceCard(
                    service: _viewModel.services.first,
                    theme: theme,
                  ),
                const SliverToBoxAdapter(child: SizedBox(height: 12)),

                _DashboardSection(
                  title: 'TOURNAMENTS & EVENTS',
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
                  title: 'COURSES',
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
                  title: 'ACTIVITIES',
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
                    onTap: () {
                      if (ensureAuthenticated(context)) {
                        context.push(
                          '/booking',
                          extra: _viewModel.activities[index],
                        );
                      }
                    },
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
      return const SizedBox(
        height: 180,
        child: Center(child: CircularProgressIndicator()),
      );
    }
    if (error != null) {
      return SizedBox(
        height: 180,
        child: Center(
          child: TextButton.icon(
            onPressed: onRetry,
            icon: const Icon(Symbols.refresh, size: 16),
            label: const Text('RETRY'),
          ),
        ),
      );
    }
    if (services.isEmpty) {
      return const SizedBox(height: 180);
    }

    return Container(
      height: 180,
      margin: const EdgeInsets.fromLTRB(24, 24, 24, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Symbols.build, size: 20, color: theme.colorScheme.primary),
              const SizedBox(width: 8),
              Text(
                'OUR SERVICES',
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
                      'SEE ALL',
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
              separatorBuilder: (_, __) => const SizedBox(width: 12),
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
                                    Symbols.build,
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

class _FeaturedServiceCard extends SliverToBoxAdapter {
  _FeaturedServiceCard({
    required Service service,
    required ThemeData theme,
  }) : super(
          child: _FeaturedServiceContent(service: service, theme: theme),
        );
}

class _FeaturedServiceContent extends StatelessWidget {
  final Service service;
  final ThemeData theme;

  const _FeaturedServiceContent({
    required this.service,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
      child: GestureDetector(
        onTap: () => context.push('/services/${service.id}', extra: service),
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
              if (service.imageUrl != null)
                PremiumNetworkImage(
                  imageUrl: service.imageUrl!,
                  fit: BoxFit.cover,
                )
              else
                Container(
                  color: theme.colorScheme.primary.withValues(alpha: 0.08),
                  child: Icon(
                    Symbols.build,
                    size: 64,
                    color: theme.colorScheme.primary.withValues(alpha: 0.2),
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
                    Row(
                      children: [
                        if (service.plansCount > 0)
                          _ServiceStatCompact(
                            count: service.plansCount,
                            label: 'plans',
                          ),
                        if (service.plansCount > 0 &&
                            service.coursesCount > 0)
                          const SizedBox(width: 8),
                        if (service.coursesCount > 0)
                          _ServiceStatCompact(
                            count: service.coursesCount,
                            label: 'courses',
                          ),
                        if (service.coursesCount > 0 &&
                            service.eventsCount > 0)
                          const SizedBox(width: 8),
                        if (service.eventsCount > 0)
                          _ServiceStatCompact(
                            count: service.eventsCount,
                            label: 'events',
                          ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      width: 120,
                      height: 36,
                      child: ElevatedButton(
                        onPressed: () => context.push(
                          '/services/${service.id}',
                          extra: service,
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: theme.colorScheme.primary,
                          foregroundColor: theme.colorScheme.onPrimary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'EXPLORE',
                          style: TextStyle(
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
            ],
          ),
        ),
      ),
    );
  }
}

class _ServiceStatCompact extends StatelessWidget {
  final int count;
  final String label;

  const _ServiceStatCompact({
    required this.count,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        '$count ${label.toUpperCase()}',
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
                    'SEE ALL',
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
               _EmptyRow(
                 message: 'No $title available',
                 accentColor: accentColor,
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
    final baseColor = theme.colorScheme.onSurface.withValues(alpha: 0.05);
    final highlightColor = theme.colorScheme.onSurface.withValues(alpha: 0.1);

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
            child: Container(
              width: cardWidth,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
        ),
      ),
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
                label: const Text('RETRY'),
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

  const _EmptyRow({required this.message, required this.accentColor});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        height: 200,
        decoration: BoxDecoration(
          color: accentColor.withValues(alpha: 0.03),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: accentColor.withValues(alpha: 0.08)),
        ),
        child: Center(
          child: Text(
            message,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
            ),
          ),
        ),
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
                  color: hasImage ? null : theme.colorScheme.surfaceContainerHighest,
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
                          color: theme.colorScheme.primary.withValues(alpha: 0.3),
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


