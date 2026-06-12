import 'package:bourgo_arena_mobile/core/constants/app_constants.dart';
import 'package:bourgo_arena_mobile/core/di/locator.dart';
import 'package:bourgo_arena_mobile/domain/entities/course.dart';
import 'package:bourgo_arena_mobile/domain/usecases/course/get_courses_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/subscription/get_active_subscriptions_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/service/get_services_use_case.dart';
import 'package:bourgo_arena_mobile/presentation/common/widgets/pressable_card.dart';
import 'package:bourgo_arena_mobile/presentation/common/widgets/skeleton_card.dart';
import 'package:bourgo_arena_mobile/presentation/planning/widgets/course_card.dart';
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
          'COURSES',
          style: theme.textTheme.titleMedium?.copyWith(
            fontFamily: AppConstants.displayFontFamily,
            fontWeight: FontWeight.w900,
            letterSpacing: 1.5,
          ),
        ),
      ),
      body: Column(
        children: [
          if (_hasSubscriptionGap && !_isLoading && _error == null)
            _buildSubscriptionBanner(context),
          Expanded(child: _buildBody()),
        ],
      ),
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
              'Certains cours nécessitent un abonnement pour réserver des séances.',
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
              'VOIR LES OFFRES',
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
      return ListView(
        padding: const EdgeInsets.all(24),
        children: List.generate(
          4,
          (_) => const SkeletonCard(type: SkeletonCardType.course),
        ),
      );
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _error!,
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
            const SizedBox(height: 16),
            ElevatedButton(onPressed: _load, child: const Text('RETRY')),
          ],
        ),
      );
    }

    if (_courses.isEmpty) {
      return RefreshIndicator(
        onRefresh: _load,
        child: ListView(children: const []),
      );
    }

    return RefreshIndicator(
      onRefresh: _load,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        itemCount: _courses.length,
        itemBuilder: (context, index) {
          final course = _courses[index];
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
