import 'package:bourgo_arena_mobile/core/constants/app_constants.dart';
import 'package:bourgo_arena_mobile/core/di/locator.dart';
import 'package:bourgo_arena_mobile/core/theme/bourgo_theme.dart';
import 'package:bourgo_arena_mobile/domain/entities/activity.dart';
import 'package:bourgo_arena_mobile/domain/entities/course.dart';
import 'package:bourgo_arena_mobile/domain/entities/event.dart';
import 'package:bourgo_arena_mobile/domain/entities/plan.dart';
import 'package:bourgo_arena_mobile/domain/entities/service.dart';
import 'package:bourgo_arena_mobile/presentation/common/widgets/premium_network_image.dart';
import 'package:bourgo_arena_mobile/presentation/service/service_detail_view_model.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:shimmer/shimmer.dart';

class ServiceDetailScreen extends StatefulWidget {
  final Service? service;
  final String serviceId;

  const ServiceDetailScreen({super.key, this.service, required this.serviceId});

  @override
  State<ServiceDetailScreen> createState() => _ServiceDetailScreenState();
}

class _ServiceDetailScreenState extends State<ServiceDetailScreen> {
  late final ServiceDetailViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = ServiceDetailViewModel(getServiceDetailsUseCase: locator());
    if (widget.service != null) {
      _viewModel.setService(widget.service!);
    } else {
      _viewModel.loadService(int.parse(widget.serviceId));
    }
    _viewModel.addListener(_onViewModelChanged);
  }

  void _onViewModelChanged() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _viewModel.removeListener(_onViewModelChanged);
    _viewModel.dispose();
    super.dispose();
  }

  Service? get _service => _viewModel.service;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (_viewModel.isLoading && _service == null) {
      return _buildLoading(theme);
    }

    if (_viewModel.errorMessage != null && _service == null) {
      return _buildError(theme);
    }

    final service = _service!;
    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: theme.colorScheme.surface,
        leading: IconButton(
          icon: const Icon(Symbols.chevron_left),
          onPressed: () => context.pop(),
        ),
      ),
      body: CustomScrollView(
        slivers: [
          _buildHeroSliver(theme, service),
          _buildDescriptionSection(theme, service),
          if (service.plans.isNotEmpty)
            _buildHorizSection(
              theme: theme,
              title: 'PLANS',
              icon: Symbols.workspace_premium,
              accentColor: theme.colorScheme.primary,
              itemCount: service.plans.length,
              itemWidth: 180,
              itemBuilder: (context, index) =>
                  _PlanCard(plan: service.plans[index], theme: theme),
            ),
          if (service.courses.isNotEmpty)
            _buildHorizSection(
              theme: theme,
              title: 'COURSES',
              icon: Symbols.school,
              accentColor: Colors.orange.shade400,
              itemCount: service.courses.length,
              itemWidth: 220,
              itemBuilder: (context, index) =>
                  _CourseCard(course: service.courses[index], theme: theme),
            ),
          if (service.events.isNotEmpty)
            _buildHorizSection(
              theme: theme,
              title: 'EVENTS',
              icon: Symbols.emoji_events,
              accentColor: Colors.purple.shade400,
              itemCount: service.events.length,
              itemWidth: 220,
              itemBuilder: (context, index) =>
                  _EventCard(event: service.events[index], theme: theme),
            ),
          if (service.activities.isNotEmpty)
            _buildHorizSection(
              theme: theme,
              title: 'ACTIVITIES',
              icon: Symbols.sports_soccer,
              accentColor: Colors.teal.shade400,
              itemCount: service.activities.length,
              itemWidth: 220,
              itemBuilder: (context, index) => _ActivityCard(
                activity: service.activities[index],
                theme: theme,
              ),
            ),
          const SliverToBoxAdapter(child: SizedBox(height: 80)),
        ],
      ),
    );
  }

  Widget _buildLoading(ThemeData theme) {
    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: Shimmer.fromColors(
        baseColor: theme.colorScheme.onSurface.withValues(alpha: 0.05),
        highlightColor: theme.colorScheme.onSurface.withValues(alpha: 0.1),
        child: Column(
          children: [
            Container(height: 320, color: Colors.white),
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: List.generate(3, (_) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Container(
                      height: 14,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildError(ThemeData theme) {
    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        backgroundColor: theme.colorScheme.surface,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Symbols.chevron_left),
          onPressed: () => context.pop(),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Symbols.error,
              size: 48,
              color: theme.colorScheme.error.withValues(alpha: 0.6),
            ),
            const SizedBox(height: 16),
            Text(
              _viewModel.errorMessage ?? 'Something went wrong',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () =>
                  _viewModel.loadService(int.parse(widget.serviceId)),
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.colorScheme.primary,
                foregroundColor: theme.colorScheme.onPrimary,
                minimumSize: const Size(180, 48),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: const Text('RETRY'),
            ),
          ],
        ),
      ),
    );
  }

  SliverAppBar _buildHeroSliver(ThemeData theme, Service service) {
    final appColors = theme.extension<AppColors>()!;
    final hasImage = service.imageUrl != null;

    return SliverAppBar(
      expandedHeight: 220,
      pinned: true,
      automaticallyImplyLeading: false,
      backgroundColor: theme.colorScheme.surface,
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            if (hasImage)
              PremiumNetworkImage(
                imageUrl: service.imageUrl!,
                fit: BoxFit.cover,
              )
            else
              Container(
                color: appColors.bgElevated,
                child: Icon(
                  Symbols.grid_view,
                  size: 80,
                  color: theme.colorScheme.primary.withValues(alpha: 0.3),
                ),
              ),
            DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.1),
                    Colors.black.withValues(alpha: 0.3),
                    theme.colorScheme.surface,
                  ],
                  stops: const [0.0, 0.6, 1.0],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  SliverToBoxAdapter _buildDescriptionSection(
    ThemeData theme,
    Service service,
  ) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              service.name.toUpperCase(),
              style: theme.textTheme.headlineSmall?.copyWith(
                fontFamily: AppConstants.displayFontFamily,
                fontWeight: FontWeight.w900,
                letterSpacing: 1.5,
                color: theme.colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withValues(alpha: 0.9),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                'ACTIVE',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1,
                  color: theme.colorScheme.onPrimary,
                ),
              ),
            ),
            if (service.description != null &&
                service.description!.isNotEmpty) ...[
              const SizedBox(height: 16),
              Text(
                service.description!,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                  height: 1.6,
                ),
              ),
            ],
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 6,
              children: [
                _miniStat(
                  theme,
                  '${service.plansCount} plans',
                  theme.colorScheme.primary,
                ),
                _miniStat(
                  theme,
                  '${service.coursesCount} courses',
                  Colors.orange.shade400,
                ),
                _miniStat(
                  theme,
                  '${service.eventsCount} events',
                  Colors.purple.shade400,
                ),
                _miniStat(
                  theme,
                  '${service.activitiesCount} activities',
                  Colors.teal.shade400,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _miniStat(ThemeData theme, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w700,
          color: color,
          letterSpacing: 0.3,
        ),
      ),
    );
  }

  SliverToBoxAdapter _buildHorizSection({
    required ThemeData theme,
    required String title,
    required IconData icon,
    required Color accentColor,
    required int itemCount,
    required double itemWidth,
    required Widget Function(BuildContext context, int index) itemBuilder,
  }) {
    return SliverToBoxAdapter(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 12),
            child: Row(
              children: [
                Icon(icon, size: 18, color: accentColor),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.5,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 200,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.only(left: 24, right: 8),
              itemCount: itemCount,
              itemBuilder: (context, index) => Padding(
                padding: const EdgeInsets.only(right: 12),
                child: SizedBox(
                  width: itemWidth,
                  child: itemBuilder(context, index),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PlanCard extends StatelessWidget {
  final Plan plan;
  final ThemeData theme;

  const _PlanCard({required this.plan, required this.theme});

  @override
  Widget build(BuildContext context) {
    final appColors = theme.extension<AppColors>()!;

    String durationText = '';
    if (plan.durationDays != null) {
      if (plan.durationDays! >= 365) {
        final years = plan.durationDays! ~/ 365;
        durationText = years == 1 ? 'Annual' : '$years Years';
      } else if (plan.durationDays! >= 30) {
        final months = plan.durationDays! ~/ 30;
        durationText = months == 1 ? 'Monthly' : '$months Months';
      } else {
        durationText = '${plan.durationDays} Days';
      }
    }

    return Container(
      decoration: BoxDecoration(
        color: appColors.bgElevated,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: appColors.bgBorder),
      ),
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              plan.name.toUpperCase(),
              style: theme.textTheme.titleSmall?.copyWith(
                fontFamily: AppConstants.displayFontFamily,
                fontWeight: FontWeight.w900,
                letterSpacing: 0.5,
                color: theme.colorScheme.onSurface,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const Spacer(),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  plan.price.toStringAsFixed(0),
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontFamily: AppConstants.displayFontFamily,
                    fontWeight: FontWeight.w900,
                    color: theme.colorScheme.primary,
                    height: 1,
                  ),
                ),
                const SizedBox(width: 4),
                Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Text(
                    'TND',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            if (durationText.isNotEmpty)
              Text(
                durationText.toUpperCase(),
                style: theme.textTheme.labelSmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5,
                ),
              ),
            const SizedBox(height: 8),
            if (plan.hasAllCourses)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: appColors.accentCourse.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  'ALL COURSES',
                  style: TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.w800,
                    color: appColors.accentCourse,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _CourseCard extends StatelessWidget {
  final Course course;
  final ThemeData theme;

  const _CourseCard({required this.course, required this.theme});

  @override
  Widget build(BuildContext context) {
    final appColors = theme.extension<AppColors>()!;
    final hasImage = course.images.isNotEmpty;
    final isActive = course.status == 'active';

    return GestureDetector(
      onTap: () => context.push('/courses/${course.id}', extra: course),
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

class _EventCard extends StatelessWidget {
  final Event event;
  final ThemeData theme;

  const _EventCard({required this.event, required this.theme});

  @override
  Widget build(BuildContext context) {
    final appColors = theme.extension<AppColors>()!;
    final hasImage = event.images.isNotEmpty;

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
      onTap: () => context.push('/events/${event.id}', extra: event),
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
                  color: hasImage ? null : Colors.purple.withValues(alpha: 0.1),
                ),
                child: hasImage
                    ? PremiumNetworkImage(
                        imageUrl: event.images.first,
                        fit: BoxFit.cover,
                      )
                    : Center(
                        child: Icon(
                          Symbols.emoji_events,
                          size: 32,
                          color: Colors.purple.shade300.withValues(alpha: 0.5),
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
}

class _ActivityCard extends StatelessWidget {
  final Activity activity;
  final ThemeData theme;

  const _ActivityCard({required this.activity, required this.theme});

  @override
  Widget build(BuildContext context) {
    final appColors = theme.extension<AppColors>()!;
    final hasImage = activity.imageUrl.isNotEmpty;

    return GestureDetector(
      onTap: () => context.push('/booking', extra: activity),
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
