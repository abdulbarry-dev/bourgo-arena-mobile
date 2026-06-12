import 'package:bourgo_arena_mobile/core/constants/app_constants.dart';
import 'package:bourgo_arena_mobile/core/di/locator.dart';
import 'package:bourgo_arena_mobile/core/utils/auth_utils.dart';
import 'package:bourgo_arena_mobile/domain/entities/activity.dart';
import 'package:bourgo_arena_mobile/domain/usecases/activity/get_activities_use_case.dart';
import 'package:bourgo_arena_mobile/presentation/activities/viewmodels/activities_view_model.dart';
import 'package:bourgo_arena_mobile/domain/usecases/booking/get_user_bookings_use_case.dart';
import 'package:bourgo_arena_mobile/presentation/auth/auth_state_notifier.dart';
import 'package:bourgo_arena_mobile/presentation/common/widgets/pressable_card.dart';
import 'package:bourgo_arena_mobile/presentation/common/widgets/skeleton_card.dart';
import 'package:bourgo_arena_mobile/presentation/home/widgets/activity_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';

class ActivitiesListScreen extends StatefulWidget {
  const ActivitiesListScreen({super.key});

  @override
  State<ActivitiesListScreen> createState() => _ActivitiesListScreenState();
}

class _ActivitiesListScreenState extends State<ActivitiesListScreen> {
  late final ActivitiesViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = ActivitiesViewModel(
      getActivitiesUseCase: locator<GetActivitiesUseCase>(),
      getUserBookingsUseCase: locator<GetUserBookingsUseCase>(),
      authStateNotifier: locator<AuthStateNotifier>(),
    );
    _viewModel.loadData();
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
          'ACTIVITIES',
          style: theme.textTheme.titleMedium?.copyWith(
            fontFamily: AppConstants.displayFontFamily,
            fontWeight: FontWeight.w900,
            letterSpacing: 1.5,
          ),
        ),
      ),
      body: ListenableBuilder(
        listenable: _viewModel,
        builder: (context, _) => _buildBody(),
      ),
    );
  }

  Widget _buildBody() {
    if (_viewModel.isLoading) {
      return ListView(
        padding: const EdgeInsets.all(24),
        children: List.generate(
          3,
          (_) => const SkeletonCard(type: SkeletonCardType.activity),
        ),
      );
    }

    if (_viewModel.errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _viewModel.errorMessage!,
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _viewModel.loadData,
              child: const Text('RETRY'),
            ),
          ],
        ),
      );
    }

    if (_viewModel.activities.isEmpty) {
      return RefreshIndicator(
        onRefresh: _viewModel.loadData,
        child: ListView(children: const []),
      );
    }

    return RefreshIndicator(
      onRefresh: _viewModel.loadData,
      child: ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        itemCount: _viewModel.activities.length,
        itemBuilder: (context, index) {
          final activity = _viewModel.activities[index];
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
        },
      ),
    );
  }
}
