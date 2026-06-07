import 'package:bourgo_arena_mobile/core/constants/app_constants.dart';
import 'package:bourgo_arena_mobile/core/di/locator.dart';
import 'package:bourgo_arena_mobile/core/utils/auth_utils.dart';
import 'package:bourgo_arena_mobile/domain/entities/activity.dart';
import 'package:bourgo_arena_mobile/domain/usecases/activity/get_activities_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/booking/get_user_bookings_use_case.dart';
import 'package:bourgo_arena_mobile/presentation/auth/auth_state_notifier.dart';
import 'package:bourgo_arena_mobile/l10n/app_localizations.dart';
import 'package:bourgo_arena_mobile/presentation/activities/viewmodels/activities_view_model.dart';
import 'package:bourgo_arena_mobile/presentation/common/empty_state.dart';
import 'package:bourgo_arena_mobile/presentation/home/widgets/activity_card.dart';
import 'package:bourgo_arena_mobile/presentation/common/widgets/premium_error_state.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';

/// Screen displaying all activities and user reservations.
class ActivitiesScreen extends StatefulWidget {
  const ActivitiesScreen({super.key});

  @override
  State<ActivitiesScreen> createState() => _ActivitiesScreenState();
}

class _ActivitiesScreenState extends State<ActivitiesScreen>
    with SingleTickerProviderStateMixin {
  late final ActivitiesViewModel _viewModel;
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _viewModel = ActivitiesViewModel(
      getActivitiesUseCase: locator<GetActivitiesUseCase>(),
      getUserBookingsUseCase: locator<GetUserBookingsUseCase>(),
      authStateNotifier: locator<AuthStateNotifier>(),
    );
    _tabController = TabController(length: 2, vsync: this);
    _viewModel.loadData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListenableBuilder(
      listenable: _viewModel,
      builder: (context, _) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: theme.colorScheme.surface,
            elevation: 0,
            scrolledUnderElevation: 0,
            centerTitle: false,
            title: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primaryContainer.withValues(
                      alpha: 0.5,
                    ),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(
                    Symbols.directions_run,
                    color: theme.colorScheme.primary,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 16),
                Text(
                  AppLocalizations.of(context)!.navActivities,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontFamily: AppConstants.displayFontFamily,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 0.5,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
              ],
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
                Tab(text: "SPORTS"),
                Tab(text: "ACTIVITÉS"),
              ],
            ),
          ),
          body: _viewModel.isLoading
              ? Center(
                  child: CircularProgressIndicator(
                    color: theme.colorScheme.primary,
                  ),
                )
              : _viewModel.errorMessage != null
              ? PremiumErrorState(
                  title: "ERREUR DE CHARGEMENT",
                  message:
                      "Une erreur est survenue lors de la récupération des données. Veuillez vérifier votre connexion et réessayer.",
                  actionLabel: AppLocalizations.of(context)!.activitiesRetry,
                  onRetry: _viewModel.loadData,
                )
              : TabBarView(
                  controller: _tabController,
                  children: [
                    RefreshIndicator(
                      onRefresh: _viewModel.loadData,
                      child: _ActivitiesList(
                        activities: _viewModel.sports,
                        emptyTitle: "AUCUN SPORT DISPONIBLE",
                      ),
                    ),
                    RefreshIndicator(
                      onRefresh: _viewModel.loadData,
                      child: _ActivitiesList(
                        activities: _viewModel.otherActivities,
                        emptyTitle: "AUCUNE ACTIVITÉ DISPONIBLE",
                      ),
                    ),
                  ],
                ),
        );
      },
    );
  }
}

class _ActivitiesList extends StatelessWidget {
  final List<Activity> activities;
  final String emptyTitle;

  const _ActivitiesList({required this.activities, required this.emptyTitle});

  @override
  Widget build(BuildContext context) {
    if (activities.isEmpty) {
      return SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.6,
          child: EmptyState(
            title: emptyTitle,
            message: AppLocalizations.of(
              context,
            )!.activitiesNoSportsFoundSubtitle,
            icon: Symbols.search_off,
          ),
        ),
      );
    }

    return ListView.builder(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      itemCount: activities.length,
      itemBuilder: (context, index) {
        final activity = activities[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: ActivityCard(
            title: activity.title,
            imageUrl: activity.imageUrl,
            icon: _getIcon(activity.icon),
            onTap: () {
              if (ensureAuthenticated(context)) {
                context.push('/booking', extra: activity);
              }
            },
          ),
        );
      },
    );
  }

  // Helper to map string icon name to Material Symbols
  IconData _getIcon(String name) {
    switch (name) {
      case 'sports_soccer':
        return Icons.sports_soccer;
      case 'sports_tennis':
        return Icons.sports_tennis;
      case 'sports_basketball':
        return Icons.sports_basketball;
      case 'fitness_center':
        return Icons.fitness_center;
      default:
        return Icons.sports;
    }
  }
}
