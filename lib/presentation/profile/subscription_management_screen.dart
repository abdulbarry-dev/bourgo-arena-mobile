import 'package:bourgo_arena_mobile/core/constants/app_constants.dart';
import 'package:bourgo_arena_mobile/core/di/locator.dart';
import 'package:bourgo_arena_mobile/core/theme/bourgo_theme.dart';
import 'package:bourgo_arena_mobile/domain/entities/plan.dart';
import 'package:bourgo_arena_mobile/domain/entities/subscription.dart';
import 'package:bourgo_arena_mobile/domain/usecases/subscription/get_plans_use_case.dart';
import 'package:bourgo_arena_mobile/presentation/common/widgets/premium_network_image.dart';
import 'package:bourgo_arena_mobile/presentation/common/widgets/sub_screen_app_bar.dart';
import 'package:bourgo_arena_mobile/presentation/profile/viewmodels/plans_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:shimmer/shimmer.dart';

/// Screen for managing the user's active subscription,
/// including upgrades, cancellations, and renewal details.
class SubscriptionManagementScreen extends StatefulWidget {
  final Subscription? currentSubscription;
  final String? childId;

  const SubscriptionManagementScreen({
    super.key,
    this.currentSubscription,
    this.childId,
  });

  @override
  State<SubscriptionManagementScreen> createState() =>
      _SubscriptionManagementScreenState();
}

class _SubscriptionManagementScreenState
    extends State<SubscriptionManagementScreen> {
  late final PlansViewModel _viewModel;
  String _searchQuery = '';
  String _selectedServiceId = 'All';
  Map<String, String> _servicesMap = {'All': 'All Services'};

  @override
  void initState() {
    super.initState();
    _viewModel = PlansViewModel(getPlansUseCase: locator<GetPlansUseCase>());
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  void _updateServicesMap() {
    final map = <String, String>{'All': 'All Services'};
    for (final plan in _viewModel.plans) {
      if (plan.service != null) {
        map[plan.service!.id] = plan.service!.name ?? 'Unknown';
      }
    }
    _servicesMap = map;
  }

  List<Plan> _filteredPlans() {
    return _viewModel.plans.where((plan) {
      final matchesService =
          _selectedServiceId == 'All' || plan.service?.id == _selectedServiceId;
      final matchesSearch =
          _searchQuery.isEmpty ||
          plan.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          (plan.service?.name?.toLowerCase().contains(
                _searchQuery.toLowerCase(),
              ) ??
              false);
      return matchesService && matchesSearch;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListenableBuilder(
      listenable: _viewModel,
      builder: (context, _) {
        _updateServicesMap();
        final filteredPlans = _filteredPlans();

        return Scaffold(
          backgroundColor: theme.scaffoldBackgroundColor,
          appBar: SubScreenAppBar(title: 'EXPLORE PLANS'),
          body: _viewModel.isLoading
              ? _buildSkeletonLoading(theme)
              : _viewModel.errorMessage != null
              ? _buildErrorState(theme)
              : Column(
                  children: [
                    _buildSearchBar(theme),
                    _buildFilterPills(theme),
                    Expanded(child: _buildPlanList(theme, filteredPlans)),
                  ],
                ),
        );
      },
    );
  }

  Widget _buildSearchBar(ThemeData theme) {
    final appColors = theme.extension<AppColors>()!;

    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 12, 24, 8),
      child: TextField(
        onChanged: (val) => setState(() => _searchQuery = val),
        style: TextStyle(
          color: theme.colorScheme.onSurface,
          fontFamily: GoogleFonts.dmSans().fontFamily,
        ),
        decoration: InputDecoration(
          hintText: 'Search plans or services...',
          hintStyle: TextStyle(
            color: theme.colorScheme.onSurfaceVariant,
            fontFamily: GoogleFonts.dmSans().fontFamily,
          ),
          prefixIcon: Icon(
            Symbols.search,
            color: theme.colorScheme.onSurfaceVariant,
            size: 20,
          ),
          filled: true,
          fillColor: appColors.bgElevated,
          contentPadding: const EdgeInsets.symmetric(
            vertical: 16,
            horizontal: 20,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(
              color: theme.colorScheme.primary.withValues(alpha: 0.5),
              width: 1.5,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFilterPills(ThemeData theme) {
    final appColors = theme.extension<AppColors>()!;
    final keys = _servicesMap.keys.toList();

    return SizedBox(
      height: 48,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
        itemCount: keys.length,
        itemBuilder: (context, index) {
          final key = keys[index];
          final name = _servicesMap[key]!;
          final isSelected = _selectedServiceId == key;

          return Padding(
            padding: const EdgeInsets.only(right: 10),
            child: GestureDetector(
              onTap: () => setState(() => _selectedServiceId = key),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: isSelected
                      ? theme.colorScheme.primary
                      : appColors.bgElevated,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected
                        ? theme.colorScheme.primary
                        : appColors.bgBorder,
                  ),
                ),
                child: Text(
                  key == 'All' ? 'ALL' : name.toUpperCase(),
                  style: TextStyle(
                    fontFamily: GoogleFonts.lexend().fontFamily,
                    fontWeight: FontWeight.w700,
                    fontSize: 12,
                    letterSpacing: 0.5,
                    color: isSelected
                        ? theme.colorScheme.onPrimary
                        : theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildPlanList(ThemeData theme, List<Plan> filteredPlans) {
    final appColors = theme.extension<AppColors>()!;

    if (filteredPlans.isEmpty) {
      return Center(
        child: Text(
          'No plans found.',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _viewModel.loadPlans,
      displacement: 20,
      color: theme.colorScheme.primary,
      child: ListView.builder(
        padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
        itemCount: filteredPlans.length,
        itemBuilder: (context, index) {
          final plan = filteredPlans[index];
          final isCurrent = widget.currentSubscription?.plan?.name == plan.name;

          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child:
                _PlanCard(
                      plan: plan,
                      isCurrent: isCurrent,
                      theme: theme,
                      appColors: appColors,
                      onTap: () {
                        final childParam = widget.childId != null
                            ? '?childId=${widget.childId}'
                            : '';
                        context.push(
                          '/plans/${plan.id}$childParam',
                          extra: plan,
                        );
                      },
                    )
                    .animate(delay: (index * 50).ms)
                    .fade(duration: 400.ms)
                    .slideY(begin: 0.1, end: 0, curve: Curves.easeOutQuad),
          );
        },
      ),
    );
  }

  Widget _buildSkeletonLoading(ThemeData theme) {
    final appColors = theme.extension<AppColors>()!;

    return ListView(
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
      children: [
        _SkeletonPlanCard(theme: theme, appColors: appColors),
        const SizedBox(height: 16),
        _SkeletonPlanCard(theme: theme, appColors: appColors),
        const SizedBox(height: 16),
        _SkeletonPlanCard(theme: theme, appColors: appColors),
      ],
    );
  }

  Widget _buildErrorState(ThemeData theme) {
    return Center(
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
            _viewModel.errorMessage ?? 'Failed to load plans.',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: _viewModel.loadPlans,
            style: ElevatedButton.styleFrom(
              backgroundColor: theme.colorScheme.primary,
              foregroundColor: theme.colorScheme.onPrimary,
              minimumSize: const Size(180, 48),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            child: Text(
              'RETRY',
              style: TextStyle(
                fontWeight: FontWeight.w900,
                letterSpacing: 1.2,
                fontFamily: GoogleFonts.lexend().fontFamily,
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
  final bool isCurrent;
  final ThemeData theme;
  final AppColors appColors;
  final VoidCallback onTap;

  const _PlanCard({
    required this.plan,
    required this.isCurrent,
    required this.theme,
    required this.appColors,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: appColors.bgElevated,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isCurrent ? theme.colorScheme.primary : appColors.bgBorder,
            width: isCurrent ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: isCurrent
                  ? theme.colorScheme.primary.withValues(alpha: 0.15)
                  : Colors.black.withValues(alpha: 0.08),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [_buildImageSection(), _buildContentSection()],
        ),
      ),
    );
  }

  Widget _buildImageSection() {
    final hasImage =
        plan.service?.imageUrl != null && plan.service!.imageUrl!.isNotEmpty;

    return SizedBox(
      height: 160,
      child: Stack(
        fit: StackFit.expand,
        children: [
          if (hasImage)
            PremiumNetworkImage(
              imageUrl: plan.service!.imageUrl!,
              fit: BoxFit.cover,
            )
          else
            Container(
              color: theme.colorScheme.surfaceContainerHighest,
              child: Icon(
                Symbols.workspace_premium,
                size: 48,
                color: theme.colorScheme.primary.withValues(alpha: 0.3),
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
                    Colors.black.withValues(alpha: 0.6),
                  ],
                  stops: const [0.6, 1.0],
                ),
              ),
            ),
          ),
          Positioned(left: 16, bottom: 16, child: _buildBadge()),
        ],
      ),
    );
  }

  Widget _buildBadge() {
    if (isCurrent) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: theme.colorScheme.primary,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          'ACTIVE NOW',
          style: TextStyle(
            color: theme.colorScheme.onPrimary,
            fontWeight: FontWeight.w900,
            fontSize: 11,
            fontFamily: GoogleFonts.lexend().fontFamily,
            letterSpacing: 1,
          ),
        ),
      );
    }

    if (plan.service?.name != null) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: appColors.bgSurface.withValues(alpha: 0.85),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: appColors.bgBorder.withValues(alpha: 0.5)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Symbols.bolt, size: 12, color: theme.colorScheme.primary),
            const SizedBox(width: 4),
            Text(
              plan.service!.name!.toUpperCase(),
              style: TextStyle(
                color: theme.colorScheme.onSurface,
                fontSize: 11,
                fontWeight: FontWeight.w800,
                fontFamily: GoogleFonts.lexend().fontFamily,
                letterSpacing: 1,
              ),
            ),
          ],
        ),
      );
    }

    return const SizedBox.shrink();
  }

  Widget _buildContentSection() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            plan.name.toUpperCase(),
            style: theme.textTheme.titleLarge?.copyWith(
              fontFamily: AppConstants.displayFontFamily,
              fontWeight: FontWeight.w900,
              fontSize: 18,
              letterSpacing: 0.5,
              color: theme.colorScheme.onSurface,
              height: 1.1,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          if (plan.description != null && plan.description!.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              plan.description!,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                height: 1.4,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${plan.price.toStringAsFixed(0)} TND',
                style: theme.textTheme.displaySmall?.copyWith(
                  fontWeight: FontWeight.w900,
                  color: isCurrent
                      ? theme.colorScheme.primary
                      : theme.colorScheme.onSurface,
                ),
              ),
              if (plan.billingCycle != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 6, left: 4),
                  child: Text(
                    '/ ${plan.billingCycle!.toUpperCase()}',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1,
                      fontFamily: GoogleFonts.lexend().fontFamily,
                    ),
                  ),
                ),
              const Spacer(),
              Text(
                'VIEW DETAILS',
                style: theme.textTheme.labelSmall?.copyWith(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 2,
                  fontFamily: GoogleFonts.lexend().fontFamily,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SkeletonPlanCard extends StatelessWidget {
  final ThemeData theme;
  final AppColors appColors;

  const _SkeletonPlanCard({required this.theme, required this.appColors});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: theme.colorScheme.onSurface.withValues(alpha: 0.05),
      highlightColor: theme.colorScheme.onSurface.withValues(alpha: 0.1),
      child: Container(
        decoration: BoxDecoration(
          color: appColors.bgElevated,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: appColors.bgBorder),
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(height: 160, color: Colors.white),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 180,
                    height: 18,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    height: 14,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Container(
                        width: 100,
                        height: 28,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      const Spacer(),
                      Container(
                        width: 90,
                        height: 14,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ],
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
