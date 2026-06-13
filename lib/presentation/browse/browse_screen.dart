import 'package:bourgo_arena_mobile/core/constants/app_constants.dart';
import 'package:bourgo_arena_mobile/core/di/locator.dart';
import 'package:bourgo_arena_mobile/core/theme/bourgo_theme.dart';
import 'package:bourgo_arena_mobile/core/utils/auth_utils.dart';
import 'package:bourgo_arena_mobile/domain/entities/activity.dart';
import 'package:bourgo_arena_mobile/domain/entities/course.dart';
import 'package:bourgo_arena_mobile/domain/entities/event.dart';
import 'package:bourgo_arena_mobile/domain/usecases/activity/get_activities_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/course/get_courses_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/event/event_use_cases.dart';
import 'package:bourgo_arena_mobile/l10n/app_localizations.dart';
import 'package:bourgo_arena_mobile/presentation/common/widgets/filter_pill.dart';
import 'package:bourgo_arena_mobile/presentation/common/widgets/premium_error_state.dart';
import 'package:bourgo_arena_mobile/presentation/common/widgets/premium_network_image.dart';
import 'package:bourgo_arena_mobile/presentation/common/widgets/pressable_card.dart';
import 'package:bourgo_arena_mobile/presentation/common/widgets/skeleton_card.dart';
import 'package:bourgo_arena_mobile/presentation/home/widgets/activity_card.dart';
import 'package:bourgo_arena_mobile/presentation/planning/widgets/course_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:material_symbols_icons/symbols.dart';

class BrowseScreen extends StatefulWidget {
  const BrowseScreen({super.key});

  @override
  State<BrowseScreen> createState() => _BrowseScreenState();
}

class _BrowseScreenState extends State<BrowseScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  List<Activity> _activities = [];
  List<Course> _courses = [];
  List<Event> _events = [];
  bool _loadingActivities = true;
  bool _loadingCourses = true;
  bool _loadingEvents = true;
  String? _activitiesError;
  String? _coursesError;
  String? _eventsError;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadAll();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadAll() async {
    await Future.wait([_loadActivities(), _loadCourses(), _loadEvents()]);
  }

  Future<void> _loadActivities() async {
    setState(() {
      _loadingActivities = true;
      _activitiesError = null;
    });
    final result = await locator<GetActivitiesUseCase>()();
    if (!mounted) return;
    result.when(
      success: (data) => setState(() {
        _activities = data;
        _loadingActivities = false;
      }),
      failure: (f) => setState(() {
        _activitiesError = f.message;
        _loadingActivities = false;
      }),
    );
  }

  Future<void> _loadCourses() async {
    setState(() {
      _loadingCourses = true;
      _coursesError = null;
    });
    final result = await locator<GetCoursesUseCase>()();
    if (!mounted) return;
    result.when(
      success: (data) => setState(() {
        _courses = data;
        _loadingCourses = false;
      }),
      failure: (f) => setState(() {
        _coursesError = f.message;
        _loadingCourses = false;
      }),
    );
  }

  Future<void> _loadEvents() async {
    setState(() {
      _loadingEvents = true;
      _eventsError = null;
    });
    final result = await locator<GetEventsUseCase>()();
    if (!mounted) return;
    result.when(
      success: (data) => setState(() {
        _events = data;
        _loadingEvents = false;
      }),
      failure: (f) => setState(() {
        _eventsError = f.message;
        _loadingEvents = false;
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        backgroundColor: theme.scaffoldBackgroundColor,
        title: Text(
          AppLocalizations.of(context)!.navActivities.toUpperCase(),
          style: theme.textTheme.titleMedium?.copyWith(
            fontFamily: AppConstants.displayFontFamily,
            fontWeight: FontWeight.w900,
            letterSpacing: 1.5,
          ),
        ),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: theme.colorScheme.primary,
          indicatorSize: TabBarIndicatorSize.tab,
          labelColor: theme.colorScheme.primary,
          unselectedLabelColor: theme.colorScheme.onSurfaceVariant,
          labelStyle: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
          tabs: [
            Tab(text: AppLocalizations.of(context)!.browseTabCourses),
            Tab(text: AppLocalizations.of(context)!.browseTabActivities),
            Tab(text: AppLocalizations.of(context)!.browseTabEvents),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _CoursesTab(
            courses: _courses,
            isLoading: _loadingCourses,
            error: _coursesError,
            onRetry: _loadCourses,
          ),
          _ActivitiesTab(
            activities: _activities,
            isLoading: _loadingActivities,
            error: _activitiesError,
            onRetry: _loadActivities,
          ),
          _EventsTab(
            events: _events,
            isLoading: _loadingEvents,
            error: _eventsError,
            onRetry: _loadEvents,
          ),
        ],
      ),
    );
  }
}

class _CoursesTab extends StatefulWidget {
  final List<Course> courses;
  final bool isLoading;
  final String? error;
  final VoidCallback onRetry;

  const _CoursesTab({
    required this.courses,
    required this.isLoading,
    this.error,
    required this.onRetry,
  });

  @override
  State<_CoursesTab> createState() => _CoursesTabState();
}

class _CoursesTabState extends State<_CoursesTab> {
  String _selectedFilter = '';
  late List<String> _filterOptions;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _initFilters();
  }

  @override
  void didUpdateWidget(_CoursesTab oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.courses != widget.courses) {
      _initFilters();
    }
  }

  void _initFilters() {
    final allLabel = AppLocalizations.of(context)!.browseFilterAll;
    final statuses = widget.courses
        .map((c) => c.status)
        .whereType<String>()
        .where((s) => s.isNotEmpty)
        .toSet()
        .toList();
    _filterOptions = [allLabel, ...statuses];
    if (!_filterOptions.contains(_selectedFilter)) {
      _selectedFilter = allLabel;
    }
  }

  List<Course> _getFiltered() {
    final allLabel = AppLocalizations.of(context)!.browseFilterAll;
    if (_selectedFilter == allLabel) return widget.courses;
    return widget.courses.where((c) => c.status == _selectedFilter).toList();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isLoading) {
      return ListView(
        padding: const EdgeInsets.all(24),
        children: List.generate(
          4,
          (_) => const SkeletonCard(type: SkeletonCardType.course),
        ),
      );
    }
    if (widget.error != null) {
      return PremiumErrorState(
        title: AppLocalizations.of(context)!.browseErrorTitle,
        message: widget.error!,
        actionLabel: AppLocalizations.of(context)!.browseErrorRetry,
        onRetry: widget.onRetry,
      );
    }
    if (widget.courses.isEmpty) {
      return RefreshIndicator(
        onRefresh: () async => widget.onRetry(),
        child: ListView(children: const []),
      );
    }

    final filtered = _getFiltered();
    final hasFilter = _filterOptions.length > 1;

    if (filtered.isEmpty) {
      return RefreshIndicator(
        onRefresh: () async => widget.onRetry(),
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            if (hasFilter) SliverToBoxAdapter(child: _buildFilterBar()),
            SliverFillRemaining(child: _buildFilterEmpty(context, 'courses')),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () async => widget.onRetry(),
      child: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          if (hasFilter) SliverToBoxAdapter(child: _buildFilterBar()),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
                final course = filtered[index];
                return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: PressableCard(
                        onTap: () => context.push(
                          '/courses/${course.id}',
                          extra: course,
                        ),
                        child: CourseCard(course: course),
                      ),
                    )
                    .animate(delay: (index * 50).ms)
                    .fade(duration: 400.ms)
                    .slideY(begin: 0.1, end: 0, curve: Curves.easeOutQuad);
              }, childCount: filtered.length),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterBar() {
    return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 4),
          child: Row(
            children: _filterOptions.map((option) {
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: FilterPill(
                  label: option,
                  isSelected: _selectedFilter == option,
                  onTap: () => setState(() => _selectedFilter = option),
                  hapticFeedback: true,
                ),
              );
            }).toList(),
          ),
        )
        .animate()
        .fadeIn(duration: 400.ms)
        .slideY(begin: 0.1, end: 0, curve: Curves.easeOutQuad);
  }
}

class _ActivitiesTab extends StatefulWidget {
  final List<Activity> activities;
  final bool isLoading;
  final String? error;
  final VoidCallback onRetry;

  const _ActivitiesTab({
    required this.activities,
    required this.isLoading,
    this.error,
    required this.onRetry,
  });

  @override
  State<_ActivitiesTab> createState() => _ActivitiesTabState();
}

class _ActivitiesTabState extends State<_ActivitiesTab> {
  String _selectedFilter = '';
  late List<String> _filterOptions;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _initFilters();
  }

  @override
  void didUpdateWidget(_ActivitiesTab oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.activities != widget.activities) {
      _initFilters();
    }
  }

  void _initFilters() {
    final allLabel = AppLocalizations.of(context)!.browseFilterAll;
    final categories = widget.activities.map((a) => a.category).toSet().toList()
      ..sort();
    _filterOptions = [allLabel, ...categories];
    if (!_filterOptions.contains(_selectedFilter)) {
      _selectedFilter = allLabel;
    }
  }

  List<Activity> _getFiltered() {
    final allLabel = AppLocalizations.of(context)!.browseFilterAll;
    if (_selectedFilter == allLabel) return widget.activities;
    return widget.activities
        .where((a) => a.category == _selectedFilter)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isLoading) {
      return ListView(
        padding: const EdgeInsets.all(24),
        children: List.generate(
          3,
          (_) => const SkeletonCard(type: SkeletonCardType.activity),
        ),
      );
    }
    if (widget.error != null) {
      return PremiumErrorState(
        title: AppLocalizations.of(context)!.browseErrorTitle,
        message: widget.error!,
        actionLabel: AppLocalizations.of(context)!.browseErrorRetry,
        onRetry: widget.onRetry,
      );
    }
    if (widget.activities.isEmpty) {
      return RefreshIndicator(
        onRefresh: () async => widget.onRetry(),
        child: ListView(children: const []),
      );
    }

    final filtered = _getFiltered();
    final hasFilter = _filterOptions.length > 1;

    if (filtered.isEmpty) {
      return RefreshIndicator(
        onRefresh: () async => widget.onRetry(),
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            if (hasFilter) SliverToBoxAdapter(child: _buildFilterBar()),
            SliverFillRemaining(
              child: _buildFilterEmpty(context, 'activities'),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () async => widget.onRetry(),
      child: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          if (hasFilter) SliverToBoxAdapter(child: _buildFilterBar()),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
                final activity = filtered[index];
                return Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: PressableCard(
                        onTap: () {
                          if (ensureAuthenticated(context)) {
                            context.push('/booking', extra: activity);
                          }
                        },
                        child: ActivityCard(activity: activity),
                      ),
                    )
                    .animate(delay: (index * 50).ms)
                    .fade(duration: 400.ms)
                    .slideY(begin: 0.1, end: 0, curve: Curves.easeOutQuad);
              }, childCount: filtered.length),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterBar() {
    return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.fromLTRB(24, 20, 24, 4),
          child: Row(
            children: _filterOptions.map((option) {
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: FilterPill(
                  label: option,
                  isSelected: _selectedFilter == option,
                  onTap: () => setState(() => _selectedFilter = option),
                  hapticFeedback: true,
                ),
              );
            }).toList(),
          ),
        )
        .animate()
        .fadeIn(duration: 400.ms)
        .slideY(begin: 0.1, end: 0, curve: Curves.easeOutQuad);
  }
}

class _EventsTab extends StatefulWidget {
  final List<Event> events;
  final bool isLoading;
  final String? error;
  final VoidCallback onRetry;

  const _EventsTab({
    required this.events,
    required this.isLoading,
    this.error,
    required this.onRetry,
  });

  @override
  State<_EventsTab> createState() => _EventsTabState();
}

class _EventsTabState extends State<_EventsTab> {
  String _selectedFilter = '';
  late List<String> _filterOptions;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _initFilters();
  }

  @override
  void didUpdateWidget(_EventsTab oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.events != widget.events) {
      _initFilters();
    }
  }

  void _initFilters() {
    final allLabel = AppLocalizations.of(context)!.browseFilterAll;
    final sportTypes = widget.events
        .map((e) => e.sportType)
        .whereType<String>()
        .where((s) => s.isNotEmpty)
        .toSet()
        .toList();
    _filterOptions = [allLabel, ...sportTypes];
    if (!_filterOptions.contains(_selectedFilter)) {
      _selectedFilter = allLabel;
    }
  }

  List<Event> _getFiltered() {
    final allLabel = AppLocalizations.of(context)!.browseFilterAll;
    if (_selectedFilter == allLabel) return widget.events;
    return widget.events.where((e) => e.sportType == _selectedFilter).toList();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isLoading) {
      return ListView(
        padding: const EdgeInsets.all(24),
        children: List.generate(
          3,
          (_) => const SkeletonCard(type: SkeletonCardType.event),
        ),
      );
    }
    if (widget.error != null) {
      return PremiumErrorState(
        title: AppLocalizations.of(context)!.browseErrorTitle,
        message: widget.error!,
        actionLabel: AppLocalizations.of(context)!.browseErrorRetry,
        onRetry: widget.onRetry,
      );
    }
    if (widget.events.isEmpty) {
      return RefreshIndicator(
        onRefresh: () async => widget.onRetry(),
        child: ListView(children: const []),
      );
    }

    final filtered = _getFiltered();
    final hasFilter = _filterOptions.length > 1;

    if (filtered.isEmpty) {
      return RefreshIndicator(
        onRefresh: () async => widget.onRetry(),
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            if (hasFilter) SliverToBoxAdapter(child: _buildFilterBar()),
            SliverFillRemaining(child: _buildFilterEmpty(context, 'events')),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () async => widget.onRetry(),
      child: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          if (hasFilter) SliverToBoxAdapter(child: _buildFilterBar()),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
                return _EventTile(event: filtered[index])
                    .animate(delay: (index * 50).ms)
                    .fade(duration: 400.ms)
                    .slideY(begin: 0.1, end: 0, curve: Curves.easeOutQuad);
              }, childCount: filtered.length),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterBar() {
    return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 4),
          child: Row(
            children: _filterOptions.map((option) {
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: FilterPill(
                  label: option,
                  isSelected: _selectedFilter == option,
                  onTap: () => setState(() => _selectedFilter = option),
                  hapticFeedback: true,
                ),
              );
            }).toList(),
          ),
        )
        .animate()
        .fadeIn(duration: 400.ms)
        .slideY(begin: 0.1, end: 0, curve: Curves.easeOutQuad);
  }
}

Widget _buildFilterEmpty(BuildContext context, String entityLabel) {
  final theme = Theme.of(context);
  return Center(
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Symbols.filter_alt_off,
            size: 48,
            color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.4),
          ),
          const SizedBox(height: 16),
          Text(
            AppLocalizations.of(context)!.commonNoResults,
            style: theme.textTheme.titleMedium?.copyWith(
              fontFamily: AppConstants.displayFontFamily,
              fontWeight: FontWeight.w900,
              color: theme.colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            AppLocalizations.of(context)!.commonNoResultsSubtitle,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    ),
  );
}

class _EventTile extends StatelessWidget {
  final Event event;
  const _EventTile({required this.event});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = theme.extension<AppColors>()!;

    String? formattedDate;
    if (event.startDate != null) {
      try {
        formattedDate = DateFormat(
          'MMM d, yyyy',
        ).format(DateTime.parse(event.startDate!));
      } catch (_) {
        formattedDate = event.startDate;
      }
    }

    final count = event.participantsCount ?? 0;
    final max = event.maxParticipants ?? 0;
    final ratio = max > 0 ? count / max : 0.0;
    final hasImage = event.imageUrl != null || event.images.isNotEmpty;
    final imageSrc =
        event.imageUrl ?? (event.images.isNotEmpty ? event.images.first : null);

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: PressableCard(
        onTap: () => context.push('/events/${event.id}', extra: event),
        child: Container(
          decoration: BoxDecoration(
            color: appColors.bgElevated,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: appColors.bgBorder),
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                height: 140,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    if (hasImage)
                      PremiumNetworkImage(
                        imageUrl: imageSrc!,
                        fit: BoxFit.cover,
                      )
                    else
                      Container(
                        color: theme.colorScheme.surfaceContainerHighest,
                        child: Icon(
                          Symbols.emoji_events,
                          size: 48,
                          color: theme.colorScheme.primary.withValues(
                            alpha: 0.3,
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
                              Colors.black.withValues(alpha: 0.5),
                            ],
                            stops: const [0.5, 1.0],
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      left: 12,
                      bottom: 12,
                      child: Row(
                        children: [
                          if (event.format != null)
                            _miniChip(
                              theme,
                              event.format!,
                              theme.colorScheme.primary,
                            ),
                          const SizedBox(width: 6),
                          _miniChip(
                            theme,
                            (event.status ??
                                    AppLocalizations.of(
                                      context,
                                    )!.browseUnknownStatus)
                                .toUpperCase(),
                            _chipColor(theme, event.status),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      event.name?.toUpperCase() ??
                          AppLocalizations.of(
                            context,
                          )!.browseEventFallback.toUpperCase(),
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontFamily: AppConstants.displayFontFamily,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 0.5,
                        color: theme.colorScheme.onSurface,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (event.description != null &&
                        event.description!.isNotEmpty) ...[
                      const SizedBox(height: 6),
                      Text(
                        event.description!,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        if (formattedDate != null) ...[
                          Icon(
                            Symbols.calendar_month,
                            size: 14,
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                          const SizedBox(width: 4),
                          Flexible(
                            child: Text(
                              formattedDate,
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                        ],
                        Icon(
                          Symbols.group,
                          size: 14,
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '$count/$max',
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(3),
                      child: LinearProgressIndicator(
                        value: ratio,
                        minHeight: 4,
                        backgroundColor:
                            theme.colorScheme.surfaceContainerHighest,
                        valueColor: AlwaysStoppedAnimation(
                          ratio >= 1
                              ? theme.colorScheme.error
                              : theme.colorScheme.primary,
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

  Widget _miniChip(ThemeData theme, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withValues(alpha: 0.5)),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          color: color,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Color _chipColor(ThemeData theme, String? status) {
    switch (status) {
      case 'open':
        return theme.colorScheme.primary;
      case 'in_progress':
        return Colors.orange;
      case 'completed':
        return theme.colorScheme.onSurfaceVariant;
      case 'canceled':
        return theme.colorScheme.error;
      default:
        return theme.colorScheme.onSurfaceVariant;
    }
  }
}
