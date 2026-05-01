import 'package:bourgo_arena_mobile/core/constants.dart';
import 'package:bourgo_arena_mobile/data/services/data_service.dart';
import 'package:bourgo_arena_mobile/l10n/app_localizations.dart';
import 'package:bourgo_arena_mobile/presentation/home/home_view_model.dart';
import 'package:bourgo_arena_mobile/presentation/home/widgets/activity_card.dart';
import 'package:bourgo_arena_mobile/presentation/home/widgets/ticker_strip.dart';
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
    _viewModel = HomeViewModel(dataService: DataService());
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
            title: Text(
              AppLocalizations.of(context)!.appName.toUpperCase(),
              style: const TextStyle(
                fontFamily: AppConstants.displayFontFamily,
                fontSize: 20,
                letterSpacing: 1.5,
              ),
            ),
            actions: [
              IconButton(
                onPressed: () => MainLayout.tabController.value = 1,
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
                  height: 200,
                  padding: const EdgeInsets.all(24),
                  alignment: Alignment.bottomLeft,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.homeHeroPart1,
                        style: theme.textTheme.displayMedium?.copyWith(
                          color: Colors.white,
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
                  textColor: Colors.black,
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
                          letterSpacing: 1,
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
                  child: Text(
                    AppLocalizations.of(context)!.homeTodayTitle,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontFamily: AppConstants.displayFontFamily,
                      letterSpacing: 1,
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                if (_viewModel.todayCourses.isEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Text(
                      AppLocalizations.of(context)!.homeNoCourses,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: Colors.white54,
                      ),
                    ),
                  )
                else
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    itemCount: _viewModel.todayCourses.length,
                    itemBuilder: (context, index) {
                      final course = _viewModel.todayCourses[index];

                      return GestureDetector(
                        onTap: () => MainLayout.tabController.value = 2,
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 16),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.surfaceContainerHighest,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 4,
                                height: 40,
                                color: theme.colorScheme.primary,
                              ),
                              const SizedBox(width: 16),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    course.category.toUpperCase(),
                                    style: theme.textTheme.labelSmall?.copyWith(
                                      color: theme.colorScheme.primary,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    '${course.title} • ${course.startTime}',
                                    style: theme.textTheme.titleSmall?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              const Spacer(),
                              const Icon(Symbols.chevron_right, size: 20),
                            ],
                          ),
                        ),
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
