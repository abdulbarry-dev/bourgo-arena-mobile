import 'package:bourgo_arena_mobile/core/constants/app_constants.dart';
import 'package:bourgo_arena_mobile/domain/entities/subscription.dart';
import 'package:bourgo_arena_mobile/domain/usecases/subscription/get_active_subscription_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/subscription/cancel_subscription_use_case.dart';
import 'package:bourgo_arena_mobile/core/di/locator.dart';
import 'package:bourgo_arena_mobile/l10n/app_localizations.dart';
import 'package:bourgo_arena_mobile/presentation/profile/subscription_view_model.dart';
import 'package:bourgo_arena_mobile/core/theme/bourgo_theme.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'dart:ui';

/// Screen displaying the user's subscription details with premium UI.
class SubscriptionScreen extends StatefulWidget {
  const SubscriptionScreen({super.key});

  @override
  State<SubscriptionScreen> createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen> {
  late final SubscriptionViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = SubscriptionViewModel(
      getActiveSubscriptionUseCase: locator<GetActiveSubscriptionUseCase>(),
      cancelSubscriptionUseCase: locator<CancelSubscriptionUseCase>(),
    );
  }

  void _showCancelDialog() {
    final theme = Theme.of(context);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: theme.colorScheme.surface,
        title: Text(
          'Cancel Subscription',
          style: TextStyle(
            color: theme.colorScheme.onSurface,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          'Are you sure you want to cancel your subscription? You will lose access to your premium benefits after the current billing period.',
          style: TextStyle(color: theme.colorScheme.onSurfaceVariant),
        ),
        actions: [
          TextButton(
            onPressed: () => context.pop(),
            child: Text(
              'Keep It',
              style: TextStyle(color: theme.colorScheme.primary),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              context.pop();
              final success = await _viewModel.cancelSubscription();
              if (success && mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Subscription cancelled successfully.'),
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: theme.colorScheme.error,
              foregroundColor: theme.colorScheme.onError,
            ),
            child: const Text('Cancel Plan'),
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
        final subscription = _viewModel.subscription;

        return Scaffold(
          backgroundColor: theme.colorScheme.surface,
          appBar: AppBar(
            elevation: 0,
            scrolledUnderElevation: 0,
            centerTitle: false,
            title: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(
                    Symbols.workspace_premium,
                    color: theme.colorScheme.primary,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 16),
                Text(
                  l10n.profileSubscriptionTitle,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontFamily: AppConstants.displayFontFamily,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 0.5,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
              ],
            ),
            backgroundColor: theme.colorScheme.surface,
          ),
          body: _viewModel.isLoading && subscription == null
              ? const Center(child: CircularProgressIndicator())
              : RefreshIndicator(
                  onRefresh: _viewModel.loadSubscription,
                  color: theme.colorScheme.primary,
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (subscription != null) ...[
                          _ActivePlanPremiumCard(
                            subscription: subscription,
                            fallbackPlanLabel: l10n.profilePlanLabel,
                            fallbackNextBilling: l10n.profileNextBilling,
                            theme: theme,
                            appColors: appColors,
                          ),
                          const SizedBox(height: 32),
                          Text(
                            l10n.profileAdvantages.toUpperCase(),
                            style: theme.textTheme.labelMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.5,
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                          const SizedBox(height: 16),
                          ..._buildBenefits(subscription, l10n, theme),
                          const SizedBox(height: 40),
                        ] else if (_viewModel.errorMessage != null) ...[
                          // Error state
                          Center(
                            child: Column(
                              children: [
                                const SizedBox(height: 40),
                                Icon(
                                  Symbols.error,
                                  size: 64,
                                  color: theme.colorScheme.error.withValues(
                                    alpha: 0.8,
                                  ),
                                ),
                                const SizedBox(height: 24),
                                Text(
                                  'Error Loading Subscription',
                                  style: theme.textTheme.headlineSmall
                                      ?.copyWith(fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  _viewModel.errorMessage!,
                                  textAlign: TextAlign.center,
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color: theme.colorScheme.error,
                                  ),
                                ),
                                const SizedBox(height: 40),
                              ],
                            ),
                          ),
                        ] else ...[
                          // No active subscription state
                          Center(
                            child: Column(
                              children: [
                                const SizedBox(height: 40),
                                Icon(
                                  Symbols.block,
                                  size: 64,
                                  color: theme.colorScheme.onSurfaceVariant
                                      .withValues(alpha: 0.5),
                                ),
                                const SizedBox(height: 24),
                                Text(
                                  'No Active Subscription',
                                  style: theme.textTheme.headlineSmall
                                      ?.copyWith(fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Discover our plans to unlock premium features and courses.',
                                  textAlign: TextAlign.center,
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color: theme.colorScheme.onSurfaceVariant,
                                  ),
                                ),
                                const SizedBox(height: 40),
                              ],
                            ),
                          ),
                        ],

                        ElevatedButton.icon(
                          onPressed: () => context.push('/plans'),
                          icon: const Icon(Symbols.explore),
                          label: Text(
                            subscription == null
                                ? 'DISCOVER PLANS'
                                : l10n.profileManageSubscription.toUpperCase(),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.2,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: theme.colorScheme.primary,
                            foregroundColor: theme.colorScheme.onPrimary,
                            minimumSize: const Size(double.infinity, 56),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            elevation: 8,
                            shadowColor: theme.colorScheme.primary.withValues(
                              alpha: 0.5,
                            ),
                          ),
                        ),
                        if (subscription != null) ...[
                          const SizedBox(height: 16),
                          OutlinedButton.icon(
                            onPressed: _viewModel.isLoading
                                ? null
                                : _showCancelDialog,
                            icon: const Icon(Symbols.cancel),
                            label: const Text(
                              'CANCEL SUBSCRIPTION',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.2,
                              ),
                            ),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: theme.colorScheme.error,
                              minimumSize: const Size(double.infinity, 56),
                              side: BorderSide(
                                color: theme.colorScheme.error.withValues(
                                  alpha: 0.5,
                                ),
                                width: 1.5,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
        );
      },
    );
  }

  List<Widget> _buildBenefits(
    Subscription? subscription,
    AppLocalizations l10n,
    ThemeData theme,
  ) {
    final description = subscription?.planDescription;
    if (description != null && description.isNotEmpty) {
      return [_BenefitItem(text: description, theme: theme)];
    }

    // Fallback static benefits if no data
    return [
      _BenefitItem(text: l10n.profileBenefit1, theme: theme),
      _BenefitItem(text: l10n.profileBenefit2, theme: theme),
      _BenefitItem(text: l10n.profileBenefit3, theme: theme),
      _BenefitItem(text: l10n.profileBenefit4, theme: theme),
    ];
  }
}

class _ActivePlanPremiumCard extends StatelessWidget {
  final Subscription subscription;
  final String fallbackPlanLabel;
  final String fallbackNextBilling;
  final ThemeData theme;
  final AppColors appColors;

  const _ActivePlanPremiumCard({
    required this.subscription,
    required this.fallbackPlanLabel,
    required this.fallbackNextBilling,
    required this.theme,
    required this.appColors,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: appColors.bgElevated,
        borderRadius: BorderRadius.circular(32),
        border: Border.all(
          color: theme.colorScheme.primary.withValues(alpha: 0.5),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.primary.withValues(
              alpha: isDark ? 0.2 : 0.1,
            ),
            blurRadius: 24,
            spreadRadius: 4,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          // Background Glow effect
          Positioned(
            top: -50,
            right: -50,
            child: Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: theme.colorScheme.primary.withValues(alpha: 0.15),
              ),
            ),
          ),
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
              child: Container(color: Colors.transparent),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
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
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Symbols.check_circle,
                            size: 14,
                            color: theme.colorScheme.onPrimary,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'ACTIVE NOW',
                            style: TextStyle(
                              color: theme.colorScheme.onPrimary,
                              fontSize: 10,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 1.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      Symbols.workspace_premium,
                      color: theme.colorScheme.primary,
                      size: 32,
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Text(
                  (subscription.planName ?? fallbackPlanLabel).toUpperCase(),
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontFamily: AppConstants.displayFontFamily,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.0,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 24),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: appColors.bgSurface.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: appColors.bgBorder),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Symbols.event_upcoming,
                        color: theme.colorScheme.primary,
                      ),
                      const SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            fallbackNextBilling.toUpperCase(),
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.0,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            subscription.endsAt ??
                                '${subscription.daysRemaining ?? '...'} Days Left',
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: theme.colorScheme.onSurface,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                if (subscription.amountPaid != null ||
                    subscription.paymentMethod != null) ...[
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (subscription.paymentMethod != null)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: appColors.bgSurface.withValues(alpha: 0.5),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: appColors.bgBorder),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Symbols.wallet,
                                size: 16,
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                subscription.paymentMethod!.toUpperCase(),
                                style: theme.textTheme.labelSmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: theme.colorScheme.onSurfaceVariant,
                                  letterSpacing: 1.0,
                                ),
                              ),
                            ],
                          ),
                        ),
                      if (subscription.amountPaid != null)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primary.withValues(
                              alpha: 0.1,
                            ),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: theme.colorScheme.primary.withValues(
                                alpha: 0.3,
                              ),
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Symbols.payments,
                                size: 16,
                                color: theme.colorScheme.primary,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                '${subscription.amountPaid!.toStringAsFixed(0)} TND',
                                style: theme.textTheme.labelSmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: theme.colorScheme.primary,
                                  letterSpacing: 1.0,
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _BenefitItem extends StatelessWidget {
  final String text;
  final ThemeData theme;

  const _BenefitItem({required this.text, required this.theme});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Symbols.check,
              color: theme.colorScheme.primary,
              size: 16,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 2),
              child: Text(
                text,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                  height: 1.4,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
