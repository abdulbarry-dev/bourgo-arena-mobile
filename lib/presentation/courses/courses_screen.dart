import 'package:bourgo_arena_mobile/core/constants/app_constants.dart';
import 'package:bourgo_arena_mobile/core/di/locator.dart';
import 'package:bourgo_arena_mobile/domain/entities/course.dart';
import 'package:bourgo_arena_mobile/domain/usecases/course/get_courses_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/subscription/get_active_subscriptions_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/service/get_services_use_case.dart';
import 'package:bourgo_arena_mobile/presentation/common/widgets/pressable_card.dart';
import 'package:bourgo_arena_mobile/presentation/common/widgets/skeleton_card.dart';
import 'package:bourgo_arena_mobile/presentation/planning/widgets/course_card.dart';
import 'package:bourgo_arena_mobile/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:bourgo_arena_mobile/core/theme/bourgo_theme.dart';

class CoursesScreen extends StatefulWidget {
  const CoursesScreen({super.key});

  @override
  State<CoursesScreen> createState() => _CoursesScreenState();
}

class _CoursesScreenState extends State<CoursesScreen> {
  List<Course> _courses = [];
  bool _isLoading = true;
  bool _hasSubscriptionGap = false;
  String? _error;
  String _selectedFilter = 'All';

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _isLoading = true;
      _error = null;
      _hasSubscriptionGap = false;
    });
    final result = await locator<GetCoursesUseCase>()();
    if (!mounted) return;
    result.when(
      success: (data) {
        _courses = data;
        _isLoading = false;
        _checkSubscriptionGap();
      },
      failure: (f) => setState(() {
        _error = f.message;
        _isLoading = false;
      }),
    );
  }

  Future<void> _checkSubscriptionGap() async {
    final servicesResult = await locator<GetServicesUseCase>()();
    if (!mounted) return;

    final Map<String, int> courseServiceMap = <String, int>{};
    servicesResult.when(
      success: (services) {
        for (final service in services) {
          for (final course in service.courses) {
            courseServiceMap[course.id] = service.id;
          }
        }
      },
      failure: (_) {},
    );

    final subsResult = await locator<GetActiveSubscriptionsUseCase>().execute();
    if (!mounted) return;

    final Set<int> subscribedServiceIds = {};
    subsResult.when(
      success: (subscriptions) {
        for (final sub in subscriptions) {
          final sid = sub.service?.id;
          if (sid != null) {
            final parsed = int.tryParse(sid);
            if (parsed != null) subscribedServiceIds.add(parsed);
          }
          final pid = sub.plan?.service?.id;
          if (pid != null) {
            final parsed = int.tryParse(pid);
            if (parsed != null) subscribedServiceIds.add(parsed);
          }
        }
      },
      failure: (_) {},
    );

    if (courseServiceMap.isEmpty || subscribedServiceIds.isEmpty) {
      setState(() => _hasSubscriptionGap = true);
      return;
    }

    final hasGap = _courses.any((c) {
      final serviceId = courseServiceMap[c.id];
      return serviceId == null || !subscribedServiceIds.contains(serviceId);
    });

    if (mounted) setState(() => _hasSubscriptionGap = hasGap);
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
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => context.pop(),
          color: theme.colorScheme.onSurface,
        ),
        title: Text(
          AppLocalizations.of(context)!.coursesTitle,
          style: theme.textTheme.titleMedium?.copyWith(
            fontFamily: AppConstants.displayFontFamily,
            fontWeight: FontWeight.w900,
            letterSpacing: 1.5,
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (_hasSubscriptionGap && !_isLoading && _error == null)
            _buildSubscriptionBanner(context),
          if (!_isLoading && _courses.isNotEmpty) _buildFilterBar(theme),
          Expanded(child: _buildBody()),
        ],
      ),
    );
  }

  Widget _buildFilterBar(ThemeData theme) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      child: Row(
        children: [
          _buildFilterChip(theme, 'All'),
          const SizedBox(width: 8),
          _buildFilterChip(theme, 'Football'),
          const SizedBox(width: 8),
          _buildFilterChip(theme, 'Padel'),
          const SizedBox(width: 8),
          _buildFilterChip(theme, 'Tennis'),
        ],
      ),
    );
  }

  Widget _buildFilterChip(ThemeData theme, String label) {
    final isSelected = _selectedFilter == label;
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (_) => setState(() => _selectedFilter = label),
      selectedColor: theme.colorScheme.primary,
      backgroundColor: theme.colorScheme.surfaceContainerHighest,
      labelStyle: TextStyle(
        color: isSelected ? Colors.black : theme.colorScheme.onSurfaceVariant,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
      side: BorderSide.none,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    );
  }

  Widget _buildSubscriptionBanner(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = theme.extension<AppColors>()!;

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: appColors.brandPrimaryGhost,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: theme.colorScheme.primary.withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        children: [
          Icon(Symbols.info, size: 22, color: theme.colorScheme.primary),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              AppLocalizations.of(context)!.coursesSubscriptionRequired,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurface,
                height: 1.3,
              ),
            ),
          ),
          const SizedBox(width: 8),
          TextButton(
            onPressed: () => context.push('/plans'),
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: Text(
              AppLocalizations.of(context)!.coursesViewOffers,
              style: theme.textTheme.labelSmall?.copyWith(
                fontWeight: FontWeight.w900,
                letterSpacing: 0.5,
                color: theme.colorScheme.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return RefreshIndicator(
        onRefresh: _load,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(24),
          children: List.generate(
            4,
            (_) => const SkeletonCard(type: SkeletonCardType.course),
          ),
        ),
      );
    }

    if (_error != null) {
      return RefreshIndicator(
        onRefresh: _load,
        child: LayoutBuilder(
          builder: (context, constraints) {
            return ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 24),
              children: [
                SizedBox(
                  height: constraints.maxHeight,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _error!,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.error,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _load,
                        child: Text(AppLocalizations.of(context)!.actionRetry),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      );
    }

    List<Course> filteredCourses = _courses;
    if (_selectedFilter != 'All') {
      final lowerFilter = _selectedFilter.toLowerCase();
      filteredCourses = _courses.where((c) {
        final text = '${c.name} ${c.description}'.toLowerCase();
        return text.contains(lowerFilter);
      }).toList();
    }

    if (filteredCourses.isEmpty) {
      return RefreshIndicator(
        onRefresh: _load,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          children: const [],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _load,
      child: ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
        itemCount: filteredCourses.length,
        itemBuilder: (context, index) {
          final course = filteredCourses[index];
          return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: PressableCard(
                  onTap: () =>
                      context.push('/courses/${course.id}', extra: course),
                  child: CourseCard(course: course),
                ),
              )
              .animate(delay: (index * 50).ms)
              .fade(duration: 400.ms)
              .slideY(begin: 0.1, end: 0, curve: Curves.easeOutQuad);
        },
      ),
    );
  }
}
