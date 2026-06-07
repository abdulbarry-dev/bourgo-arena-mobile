import 'package:bourgo_arena_mobile/core/di/locator.dart';
import 'package:bourgo_arena_mobile/domain/entities/subscription.dart';
import 'package:bourgo_arena_mobile/domain/entities/plan.dart';
import 'package:bourgo_arena_mobile/domain/usecases/subscription/get_plans_use_case.dart';
import 'package:bourgo_arena_mobile/core/utils/auth_utils.dart';
import 'package:bourgo_arena_mobile/l10n/app_localizations.dart';
import 'package:bourgo_arena_mobile/presentation/profile/viewmodels/plans_view_model.dart';
import 'package:bourgo_arena_mobile/core/theme/bourgo_theme.dart';
import 'package:bourgo_arena_mobile/core/constants/app_constants.dart';
import 'package:bourgo_arena_mobile/presentation/common/widgets/premium_network_image.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:go_router/go_router.dart';
import 'dart:ui';

/// Screen for managing subscription plans, with premium UI.
class SubscriptionManagementScreen extends StatefulWidget {
  final Subscription? currentSubscription;

  const SubscriptionManagementScreen({super.key, this.currentSubscription});

  @override
  State<SubscriptionManagementScreen> createState() =>
      _SubscriptionManagementScreenState();
}

class _SubscriptionManagementScreenState
    extends State<SubscriptionManagementScreen> {
  late final PlansViewModel _viewModel;
  String _searchQuery = '';
  String _selectedServiceId = 'All';

  @override
  void initState() {
    super.initState();
    _viewModel = PlansViewModel(getPlansUseCase: locator<GetPlansUseCase>());
  }

  void _showPlanDetailsModal(BuildContext context, Plan plan, bool isCurrent) {
    final theme = Theme.of(context);
    final appColors = theme.extension<AppColors>()!;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          decoration: BoxDecoration(
            color: appColors.bgElevated.withValues(alpha: 0.9),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
            border: Border(
              top: BorderSide(color: appColors.bgBorder, width: 1.5),
            ),
          ),
          padding: const EdgeInsets.only(
            left: 24,
            right: 24,
            top: 12,
            bottom: 40,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Container(
                  width: 48,
                  height: 4,
                  decoration: BoxDecoration(
                    color: appColors.bgBorder,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 32),
              if (plan.service != null && plan.service!.imageUrl != null)
                Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(24),
                    child: PremiumNetworkImage(
                      imageUrl: plan.service!.imageUrl!,
                      width: double.infinity,
                      height: 140,
                      fit: BoxFit.cover,
                    ),
                  ),
                )
              else
                Center(
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: appColors.brandPrimaryGhost,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: theme.colorScheme.primary.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Icon(
                      Symbols.workspace_premium,
                      size: 40,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                ),
              const SizedBox(height: 24),
              Text(
                plan.name.toUpperCase(),
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontFamily: AppConstants.displayFontFamily,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.2,
                  color: theme.colorScheme.onSurface,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                '${plan.price.toStringAsFixed(0)} TND',
                style: theme.textTheme.displaySmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.primary,
                ),
                textAlign: TextAlign.center,
              ),
              if (plan.durationDays != null)
                Text(
                  'Every ${plan.durationDays} Days',
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                    letterSpacing: 1.0,
                  ),
                  textAlign: TextAlign.center,
                ),
              const SizedBox(height: 32),

              Text(
                'INCLUDES',
                style: theme.textTheme.labelSmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5,
                ),
              ),
              const SizedBox(height: 16),
              if (plan.service != null)
                _buildFeatureRow(
                  theme,
                  Symbols.business,
                  'Service Access: ${plan.service!.name}',
                ),
              if (plan.hasAllCourses)
                _buildFeatureRow(
                  theme,
                  Symbols.all_inclusive,
                  'Access to ALL courses',
                ),
              if (plan.description != null && plan.description!.isNotEmpty)
                _buildFeatureRow(theme, Symbols.info, plan.description!),

              const SizedBox(height: 40),
              if (isCurrent)
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: theme.colorScheme.primary),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Symbols.check_circle,
                        color: theme.colorScheme.primary,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'CURRENTLY ACTIVE PLAN',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.0,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                )
              else ...[
                Text(
                  'PROCEED TO PAYMENT',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    if (!ensureAuthenticated(context)) return;
                    context.pop(); // close modal
                    context.push('/payment-selection', extra: plan);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.colorScheme.primary,
                    foregroundColor: theme.colorScheme.onPrimary,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: const Text(
                    'CONTINUE TO PAYMENT',
                    style: TextStyle(
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.2,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureRow(ThemeData theme, IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: theme.colorScheme.primary),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant.withValues(
                  alpha: 0.9,
                ),
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = theme.extension<AppColors>()!;
    final l10n = AppLocalizations.of(context)!;

    return ListenableBuilder(
      listenable: _viewModel,
      builder: (context, _) {
        // Compute unique services for filtering
        final Map<String, String> servicesMap = {'All': 'All Services'};
        for (var plan in _viewModel.plans) {
          if (plan.service != null) {
            servicesMap[plan.service!.id] = plan.service!.name ?? 'Unknown';
          }
        }

        // Filter Plans
        final filteredPlans = _viewModel.plans.where((plan) {
          final matchesService =
              _selectedServiceId == 'All' ||
              plan.service?.id == _selectedServiceId;
          final matchesSearch =
              plan.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
              (plan.service?.name?.toLowerCase().contains(
                    _searchQuery.toLowerCase(),
                  ) ??
                  false);
          return matchesService && matchesSearch;
        }).toList();

        return Scaffold(
          backgroundColor: theme.colorScheme.surface,
          body: _viewModel.isLoading
              ? const Center(child: CircularProgressIndicator())
              : _viewModel.errorMessage != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(_viewModel.errorMessage!),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _viewModel.loadPlans,
                        child: Text(l10n.commonRetry),
                      ),
                    ],
                  ),
                )
              : CustomScrollView(
                  slivers: [
                    SliverAppBar(
                      expandedHeight: 180,
                      pinned: true,
                      backgroundColor: appColors.bgSurface.withValues(
                        alpha: 0.9,
                      ),
                      flexibleSpace: FlexibleSpaceBar(
                        titlePadding: const EdgeInsets.only(
                          left: 24,
                          bottom: 16,
                          right: 24,
                        ),
                        title: Text(
                          'EXPLORE PLANS',
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontFamily: AppConstants.displayFontFamily,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 1.2,
                            color: theme.colorScheme.onSurface,
                          ),
                        ),
                        background: Stack(
                          fit: StackFit.expand,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    theme.colorScheme.primary.withValues(
                                      alpha: 0.1,
                                    ),
                                    appColors.bgSurface,
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
                        child: TextField(
                          onChanged: (val) =>
                              setState(() => _searchQuery = val),
                          style: TextStyle(color: theme.colorScheme.onSurface),
                          decoration: InputDecoration(
                            hintText: 'Search plans or services...',
                            hintStyle: TextStyle(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                            prefixIcon: Icon(
                              Symbols.search,
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                            filled: true,
                            fillColor: appColors.bgElevated,
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 16,
                              horizontal: 20,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: BorderSide(color: appColors.bgBorder),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: BorderSide(color: appColors.bgBorder),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: BorderSide(
                                color: theme.colorScheme.primary,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SliverPersistentHeader(
                      pinned: true,
                      delegate: _SliverFilterDelegate(
                        child: Container(
                          color: appColors.bgSurface.withValues(alpha: 0.95),
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 16,
                            ),
                            itemCount: servicesMap.length,
                            itemBuilder: (context, index) {
                              final key = servicesMap.keys.elementAt(index);
                              final name = servicesMap[key]!;
                              final isSelected = _selectedServiceId == key;

                              return Padding(
                                padding: const EdgeInsets.only(right: 12),
                                child: ChoiceChip(
                                  label: Text(
                                    name.toUpperCase(),
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 0.5,
                                      color: isSelected
                                          ? theme.colorScheme.onPrimary
                                          : theme.colorScheme.onSurface,
                                    ),
                                  ),
                                  selected: isSelected,
                                  onSelected: (val) {
                                    if (val) {
                                      setState(() => _selectedServiceId = key);
                                    }
                                  },
                                  selectedColor: theme.colorScheme.primary,
                                  backgroundColor: appColors.bgElevated,
                                  side: BorderSide(
                                    color: isSelected
                                        ? theme.colorScheme.primary
                                        : appColors.bgBorder,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                    SliverPadding(
                      padding: const EdgeInsets.all(24),
                      sliver: filteredPlans.isEmpty
                          ? SliverToBoxAdapter(
                              child: Center(
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 40),
                                  child: Text(
                                    'No plans found.',
                                    style: TextStyle(
                                      color: theme.colorScheme.onSurfaceVariant,
                                    ),
                                  ),
                                ),
                              ),
                            )
                          : SliverList(
                              delegate: SliverChildBuilderDelegate((
                                context,
                                index,
                              ) {
                                final plan = filteredPlans[index];
                                final isCurrent =
                                    widget.currentSubscription?.planName ==
                                    plan.name;

                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 24),
                                  child: _PremiumPlanCard(
                                    plan: plan,
                                    isCurrent: isCurrent,
                                    theme: theme,
                                    appColors: appColors,
                                    onTap: () => _showPlanDetailsModal(
                                      context,
                                      plan,
                                      isCurrent,
                                    ),
                                  ),
                                );
                              }, childCount: filteredPlans.length),
                            ),
                    ),
                  ],
                ),
        );
      },
    );
  }
}

class _SliverFilterDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;
  _SliverFilterDelegate({required this.child});

  @override
  double get minExtent => 72.0;
  @override
  double get maxExtent => 72.0;
  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) => child;
  @override
  bool shouldRebuild(covariant _SliverFilterDelegate oldDelegate) => true;
}

class _PremiumPlanCard extends StatelessWidget {
  final Plan plan;
  final bool isCurrent;
  final ThemeData theme;
  final AppColors appColors;
  final VoidCallback onTap;

  const _PremiumPlanCard({
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
          borderRadius: BorderRadius.circular(32),
          border: Border.all(
            color: isCurrent ? theme.colorScheme.primary : appColors.bgBorder,
            width: isCurrent ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: isCurrent
                  ? theme.colorScheme.primary.withValues(alpha: 0.2)
                  : theme.shadowColor.withValues(alpha: 0.3),
              blurRadius: 24,
              offset: const Offset(0, 12),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          children: [
            if (plan.service != null && plan.service!.imageUrl != null)
              Positioned.fill(
                child: PremiumNetworkImage(
                  imageUrl: plan.service!.imageUrl!,
                  fit: BoxFit.cover,
                ),
              ),
            // Complex Glassmorphism Overlay
            Positioned.fill(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        appColors.bgElevated.withValues(alpha: 0.85),
                        appColors.bgSurface.withValues(alpha: 0.95),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            // Content
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (isCurrent)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primary,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: theme.colorScheme.primary.withValues(
                                  alpha: 0.4,
                                ),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Text(
                            'ACTIVE NOW',
                            style: TextStyle(
                              color: theme.colorScheme.onPrimary,
                              fontSize: 10,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 1.0,
                            ),
                          ),
                        )
                      else if (plan.service != null)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: appColors.bgSurface,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: appColors.bgBorder),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Symbols.bolt,
                                size: 12,
                                color: theme.colorScheme.primary,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                plan.service!.name?.toUpperCase() ?? 'SERVICE',
                                style: TextStyle(
                                  color: theme.colorScheme.onSurfaceVariant
                                      .withValues(alpha: 0.8),
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1.0,
                                ),
                              ),
                            ],
                          ),
                        ),
                      Icon(
                        Symbols.arrow_outward,
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Text(
                    plan.name.toUpperCase(),
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontFamily: AppConstants.displayFontFamily,
                      fontWeight: FontWeight.w900,
                      color: theme.colorScheme.onSurface,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 8),
                  if (plan.description != null && plan.description!.isNotEmpty)
                    Text(
                      plan.description!,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                        height: 1.5,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  const SizedBox(height: 32),
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
                      if (plan.durationDays != null)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 6, left: 4),
                          child: Text(
                            '/ ${plan.durationDays} DAYS',
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.0,
                            ),
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
