import 'package:bourgo_arena_mobile/core/di/locator.dart';
import 'package:bourgo_arena_mobile/core/theme/bourgo_theme.dart';
import 'package:bourgo_arena_mobile/core/utils/haptic_utils.dart';
import 'package:bourgo_arena_mobile/domain/entities/subscription.dart';
import 'package:bourgo_arena_mobile/domain/usecases/family/buy_child_subscription_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/family/get_child_subscriptions_use_case.dart';
import 'package:bourgo_arena_mobile/presentation/common/widgets/app_shimmer.dart';
import 'package:bourgo_arena_mobile/presentation/common/widgets/sub_screen_app_bar.dart';
import 'package:bourgo_arena_mobile/presentation/family_child/viewmodels/child_subscriptions_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';

class ChildSubscriptionsScreen extends StatefulWidget {
  final String childId;

  const ChildSubscriptionsScreen({super.key, required this.childId});

  @override
  State<ChildSubscriptionsScreen> createState() => _ChildSubscriptionsScreenState();
}

class _ChildSubscriptionsScreenState extends State<ChildSubscriptionsScreen> {
  late final ChildSubscriptionsViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = ChildSubscriptionsViewModel(
      getChildSubscriptionsUseCase: locator<GetChildSubscriptionsUseCase>(),
      buyChildSubscriptionUseCase: locator<BuyChildSubscriptionUseCase>(),
    );
    _viewModel.load(widget.childId);
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  Color _statusColor(String status, AppColors appColors) {
    switch (status.toLowerCase()) {
      case 'active': return appColors.statusSuccess;
      case 'expired': return const Color(0xFF9CA3AF);
      case 'cancelled': return appColors.statusError;
      case 'pending': return appColors.statusWarning;
      default: return const Color(0xFF9CA3AF);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = context.spacing;
    final appColors = theme.extension<AppColors>()!;

    return ListenableBuilder(
      listenable: _viewModel,
      builder: (context, _) {
        return Scaffold(
          backgroundColor: theme.scaffoldBackgroundColor,
          appBar: SubScreenAppBar(title: 'SUBSCRIPTIONS'),
          body: _viewModel.isLoading
              ? _buildLoadingState(theme, spacing)
              : RefreshIndicator(
                  onRefresh: () => _viewModel.load(widget.childId),
                  color: theme.colorScheme.primary,
                  child: ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: EdgeInsets.all(spacing.lg),
                    children: [
                      if (_viewModel.subscriptions.isEmpty)
                        _buildEmptyState(theme, spacing)
                      else
                        ..._viewModel.subscriptions.asMap().entries.map((entry) {
                          return Padding(
                            padding: EdgeInsets.only(bottom: spacing.md),
                            child: _SubCard(
                              subscription: entry.value,
                              statusColor:
                                  _statusColor(entry.value.status, appColors),
                              theme: theme,
                              spacing: spacing,
                              appColors: appColors,
                            ).animate(
                              delay: (entry.key.clamp(0, 8) * 50).ms,
                            )
                              .fadeIn(duration: 350.ms)
                              .slideY(
                                begin: 0.08,
                                end: 0,
                                curve: Curves.easeOutCubic,
                              ),
                          );
                        }),
                      SizedBox(height: spacing.lg),
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            AppHaptics.light();
                            context.push('/plans');
                          },
                          icon: const Icon(Symbols.add, size: 20),
                          label: const Text('BUY NEW SUBSCRIPTION',
                            style: TextStyle(fontWeight: FontWeight.w900, letterSpacing: 1.2),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: theme.colorScheme.primary,
                            foregroundColor: theme.colorScheme.onPrimary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: spacing.xl),
                    ],
                  ),
                ),
        );
      },
    );
  }

  Widget _buildLoadingState(ThemeData theme, AppSpacing spacing) {
    return AppShimmer(
      child: Padding(
        padding: EdgeInsets.all(spacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: List.generate(
            5,
            (_) => Padding(
              padding: EdgeInsets.only(bottom: spacing.md),
              child: Container(
                padding: EdgeInsets.all(spacing.lg),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainerHighest
                      .withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        AppShimmer.block(width: 72, height: 22, borderRadius: 8),
                        AppShimmer.block(width: 40, height: 40, borderRadius: 8),
                      ],
                    ),
                    SizedBox(height: spacing.md),
                    AppShimmer.block(width: 160, height: 16),
                    SizedBox(height: spacing.sm),
                    AppShimmer.block(width: 120, height: 12),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(ThemeData theme, AppSpacing spacing) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: spacing.xxl),
      child: Column(
        children: [
          Container(
            width: 112,
            height: 112,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: theme.colorScheme.primary.withValues(alpha: 0.08),
              border: Border.all(
                color: theme.colorScheme.primary.withValues(alpha: 0.15),
              ),
            ),
            child: Icon(
              Symbols.workspace_premium,
              size: 56,
              color: theme.colorScheme.primary,
            ),
          ),
          SizedBox(height: spacing.xl),
          Text('No subscriptions',
            textAlign: TextAlign.center,
            style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900)),
          SizedBox(height: spacing.sm),
          Text('Buy a subscription to get started.',
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
        ],
      ),
    ).animate().fadeIn(duration: 300.ms).slideY(
          begin: 0.08,
          end: 0,
          curve: Curves.easeOutQuad,
        );
  }
}

class _SubCard extends StatelessWidget {
  final Subscription subscription;
  final Color statusColor;
  final ThemeData theme;
  final AppSpacing spacing;
  final AppColors appColors;

  const _SubCard({
    required this.subscription, required this.statusColor, required this.theme,
    required this.spacing, required this.appColors,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(spacing.lg),
      decoration: BoxDecoration(
        color: appColors.bgElevated,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: appColors.bgBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: spacing.sm, vertical: spacing.xxs),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  subscription.status.toUpperCase(),
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: statusColor, fontWeight: FontWeight.w900, letterSpacing: 1.0,
                  ),
                ),
              ),
              if (subscription.plan?.service?.imageUrl != null)
                Semantics(
                  label: subscription.plan?.service?.name ??
                      subscription.plan?.name ??
                      '',
                  image: true,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      subscription.plan!.service!.imageUrl!,
                      width: 40, height: 40, fit: BoxFit.cover,
                    ),
                  ),
                ),
            ],
          ),
          SizedBox(height: spacing.md),
          Text(
            subscription.plan?.name.toUpperCase() ?? '',
            style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w900),
          ),
          if (subscription.plan?.description != null && subscription.plan!.description!.isNotEmpty)
            Padding(
              padding: EdgeInsets.only(top: spacing.xs),
              child: Text(subscription.plan!.description!,
                style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
            ),
          SizedBox(height: spacing.md),
          Row(
            children: [
              Icon(Symbols.schedule, size: 14, color: theme.colorScheme.onSurfaceVariant),
              SizedBox(width: spacing.xxs),
              Text('${subscription.daysRemaining ?? 0} days remaining',
                style: theme.textTheme.labelMedium?.copyWith(
                  fontWeight: FontWeight.w700, color: theme.colorScheme.onSurfaceVariant)),
            ],
          ),
          SizedBox(height: spacing.sm),
          Row(
            children: [
              Expanded(
                child: Text('Start: ${subscription.startsAt ?? '—'}',
                  style: theme.textTheme.labelSmall?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
              ),
              Expanded(
                child: Text('End: ${subscription.endsAt ?? '—'}',
                  style: theme.textTheme.labelSmall?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
