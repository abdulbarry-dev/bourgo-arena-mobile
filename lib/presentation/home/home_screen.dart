import 'package:bourgo_arena_mobile/core/constants/app_constants.dart';
import 'package:bourgo_arena_mobile/core/di/locator.dart';
import 'package:bourgo_arena_mobile/data/services/activity_service.dart';
import 'package:bourgo_arena_mobile/data/services/data_service.dart';
import 'package:bourgo_arena_mobile/l10n/app_localizations.dart';
import 'package:bourgo_arena_mobile/presentation/common/widgets/brand_logo.dart';
import 'package:bourgo_arena_mobile/presentation/home/home_view_model.dart';
import 'package:bourgo_arena_mobile/presentation/home/widgets/activity_card.dart';
import 'package:bourgo_arena_mobile/presentation/home/widgets/ticker_strip.dart';
import 'package:bourgo_arena_mobile/presentation/home/widgets/today_course_card.dart';
import 'package:bourgo_arena_mobile/presentation/common/empty_state.dart';
import 'package:bourgo_arena_mobile/presentation/main_layout.dart';
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

  @override
  void initState() {
    super.initState();
    _viewModel = HomeViewModel(
      activityService: locator<ActivityService>(),
      dataService: locator<DataService>(),
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

    return ListenableBuilder(
      listenable: _viewModel,
      builder: (context, _) {
        if (_viewModel.isLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        return Scaffold(
          backgroundColor: theme.colorScheme.surface,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            title: Row(
              children: [
                const BrandLogo(size: 28),
                const SizedBox(width: 12),
                Text(
                  AppLocalizations.of(context)!.appName.toUpperCase(),
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontFamily: AppConstants.displayFontFamily,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 2.0,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
            actions: [
              IconButton(
                onPressed: () => context.push('/search'),
                icon: const Icon(Symbols.search),
              ),
              IconButton(
                onPressed: () => context.push('/notifications'),
                icon: const Icon(Symbols.notifications),
              ),
            ],
          ),
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Hero Section
                Container(
                  height: 220,
                  margin: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        theme.colorScheme.primaryContainer.withValues(
                          alpha: 0.3,
                        ),
                        theme.colorScheme.surface,
                      ],
                    ),
                    border: Border.all(
                      color: theme.colorScheme.primary.withValues(alpha: 0.1),
                      width: 1,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.homeHeroPart1,
                        style: theme.textTheme.displayMedium?.copyWith(
                          color: theme.colorScheme.onSurface,
                          fontFamily: AppConstants.displayFontFamily,
                          height: 0.9,
                        ),
                      ),
                      Text(
                        AppLocalizations.of(context)!.homeHeroPart2,
                        style: theme.textTheme.displayMedium?.copyWith(
                          color: theme.colorScheme.primary,
                          fontFamily: AppConstants.displayFontFamily,
                          height: 0.9,
                        ),
                      ),
                    ],
                  ),
                ),

                // Ticker Strip
                TickerStrip(
                  text: AppLocalizations.of(context)!.homeTicker,
                  backgroundColor: theme.colorScheme.primary,
                  textColor: theme.colorScheme.onPrimary,
                ),

                const SizedBox(height: 32),

                // Nos Activités
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.homeActivitiesTitle,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontFamily: AppConstants.displayFontFamily,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 1.2,
                        ),
                      ),
                      TextButton(
                        onPressed: () => MainLayout.tabController.value = 1,
                        child: Text(
                          AppLocalizations.of(context)!.homeSeeAll,
                          style: TextStyle(
                            color: theme.colorScheme.primary,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                SizedBox(
                  height: 220,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    itemCount: _viewModel.activities.length,
                    itemBuilder: (context, index) {
                      final activity = _viewModel.activities[index];
                      return ActivityCard(
                        title: activity.title,
                        imageUrl: activity.imageUrl,
                        onTap: () => context.push('/booking', extra: activity),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 32),

                // Aujourd'hui Section
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.homeTodayTitle,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontFamily: AppConstants.displayFontFamily,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 1.2,
                        ),
                      ),
                      TextButton(
                        onPressed: () => MainLayout.tabController.value = 2,
                        child: Text(
                          AppLocalizations.of(context)!.homeSeeAll,
                          style: TextStyle(
                            color: theme.colorScheme.primary,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 8),

                if (_viewModel.todayCourses.isEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: EmptyState(
                      title: AppLocalizations.of(context)!.homeNoCourses,
                      message: AppLocalizations.of(
                        context,
                      )!.planningNoCoursesSubtitle,
                      icon: Symbols.calendar_today,
                    ),
                  )
                else
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    itemCount: _viewModel.todayCourses.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      return TodayCourseCard(
                        course: _viewModel.todayCourses[index],
                        onTap: () => MainLayout.tabController.value = 2,
                      );
                    },
                  ),
                const SizedBox(height: 100), // Space for bottom nav
              ],
            ),
          ),
        );
      },
    );
  }
}
