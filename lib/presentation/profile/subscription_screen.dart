import 'package:bourgo_arena_mobile/domain/entities/subscription.dart';
import 'package:bourgo_arena_mobile/domain/usecases/family/get_children_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/subscription/get_active_subscriptions_use_case.dart';

import 'package:bourgo_arena_mobile/core/di/locator.dart';
import 'package:bourgo_arena_mobile/presentation/profile/subscription_view_model.dart';
import 'package:bourgo_arena_mobile/core/theme/bourgo_theme.dart';
import 'package:bourgo_arena_mobile/presentation/common/widgets/sub_screen_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';

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
      getActiveSubscriptionsUseCase: locator<GetActiveSubscriptionsUseCase>(),
      getChildrenUseCase: locator<GetChildrenUseCase>(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = context.spacing;

    return ListenableBuilder(
      listenable: _viewModel,
      builder: (context, _) {
        final subscriptions = _viewModel.memberSubscriptions;

        return Scaffold(
          backgroundColor: theme.scaffoldBackgroundColor,
          appBar: SubScreenAppBar(title: 'MON ABONNEMENT'),
          body: _viewModel.isLoading && subscriptions.isEmpty
              ? const Center(child: CircularProgressIndicator())
              : RefreshIndicator(
                  onRefresh: _viewModel.loadSubscription,
                  color: theme.colorScheme.primary,
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: EdgeInsets.all(spacing.lg),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (subscriptions.isNotEmpty) ...[
                          for (int i = 0; i < subscriptions.length; i++) ...[
                            if (i > 0) ...[
                              SizedBox(height: spacing.xl),
                              Container(
                                height: 1,
                                color: theme
                                    .extension<AppColors>()!
                                    .bgBorder
                                    .withValues(alpha: 0.3),
                              ),
                              SizedBox(height: spacing.xl),
                            ],
                            _SubscriptionCard(
                                  subscription: subscriptions[i].subscription,
                                  appColors: theme.extension<AppColors>()!,
                                )
                                .animate()
                                .fade(duration: 400.ms)
                                .slideY(
                                  begin: 0.1,
                                  end: 0,
                                  curve: Curves.easeOutQuad,
                                ),
                            SizedBox(height: spacing.xl),
                            _PlanDetailsSection(
                                  subscription: subscriptions[i].subscription,
                                  appColors: theme.extension<AppColors>()!,
                                )
                                .animate(delay: 100.ms)
                                .fade(duration: 400.ms)
                                .slideY(
                                  begin: 0.1,
                                  end: 0,
                                  curve: Curves.easeOutQuad,
                                ),
                            SizedBox(height: spacing.xl),
                            _ServiceSection(
                                  subscription: subscriptions[i].subscription,
                                )
                                .animate(delay: 200.ms)
                                .fade(duration: 400.ms)
                                .slideY(
                                  begin: 0.1,
                                  end: 0,
                                  curve: Curves.easeOutQuad,
                                ),
                            SizedBox(height: spacing.xl),
                            _PaymentSection(
                                  subscription: subscriptions[i].subscription,
                                  appColors: theme.extension<AppColors>()!,
                                )
                                .animate(delay: 300.ms)
                                .fade(duration: 400.ms)
                                .slideY(
                                  begin: 0.1,
                                  end: 0,
                                  curve: Curves.easeOutQuad,
                                ),
                          ],
                        ] else if (_viewModel.errorMessage != null) ...[
                          _ErrorState(
                            message: _viewModel.errorMessage!,
                            onRetry: _viewModel.loadSubscription,
                          ),
                        ] else ...[
                          _EmptyState(),
                        ],
                        SizedBox(height: spacing.lg),
                        SizedBox(
                          width: double.infinity,
                          height: 56,
                          child:
                              ElevatedButton.icon(
                                    onPressed: () => context.push('/plans'),
                                    icon: const Icon(Symbols.explore, size: 20),
                                    label: const Text(
                                      'VOIR LES OFFRES',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w900,
                                        letterSpacing: 1.2,
                                      ),
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                          theme.colorScheme.primary,
                                      foregroundColor:
                                          theme.colorScheme.onPrimary,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                    ),
                                  )
                                  .animate(delay: 400.ms)
                                  .fade(duration: 400.ms)
                                  .slideY(
                                    begin: 0.1,
                                    end: 0,
                                    curve: Curves.easeOutQuad,
                                  ),
                        ),
                        SizedBox(height: spacing.xl),
                      ],
                    ),
                  ),
                ),
        );
      },
    );
  }
}

class _SubscriptionCard extends StatelessWidget {
  final Subscription subscription;
  final AppColors appColors;

  const _SubscriptionCard({
    required this.subscription,
    required this.appColors,
  });

  String _statusLabel(String status) {
    switch (status.toLowerCase()) {
      case 'active':
        return 'ACTIF';
      case 'expired':
        return 'EXPIRÉ';
      case 'cancelled':
        return 'ANNULÉ';
      case 'pending':
        return 'EN ATTENTE';
      default:
        return status.toUpperCase();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = context.spacing;
    final statusColor = switch (subscription.status.toLowerCase()) {
      'active' => appColors.statusSuccess,
      'cancelled' => theme.colorScheme.error,
      'pending' => appColors.statusWarning,
      _ => theme.colorScheme.onSurfaceVariant,
    };
    final plan = subscription.plan;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(spacing.lg),
      decoration: BoxDecoration(
        color: appColors.bgElevated,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: appColors.bgBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  if (subscription.service?.name != null) ...[
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: spacing.sm,
                        vertical: spacing.xxs,
                      ),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        subscription.service!.name!.toUpperCase(),
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 0.8,
                        ),
                      ),
                    ),
                    SizedBox(width: spacing.xs),
                  ],
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: spacing.sm,
                      vertical: spacing.xxs,
                    ),
                    decoration: BoxDecoration(
                      color: statusColor.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      _statusLabel(subscription.status),
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: statusColor,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1.0,
                      ),
                    ),
                  ),
                ],
              ),
              Container(
                padding: EdgeInsets.all(spacing.sm),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Symbols.workspace_premium,
                  color: theme.colorScheme.primary,
                  size: 24,
                ),
              ),
            ],
          ),
          SizedBox(height: spacing.lg),
          Text(
            plan?.name.toUpperCase() ?? 'ABONNEMENT',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w900,
              color: theme.colorScheme.onSurface,
            ),
          ),
          if (plan?.description != null && plan!.description!.isNotEmpty) ...[
            SizedBox(height: spacing.xs),
            Text(
              plan.description!,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
          SizedBox(height: spacing.md),
          Row(
            children: [
              Icon(
                Symbols.schedule,
                size: 16,
                color: theme.colorScheme.onSurfaceVariant,
              ),
              SizedBox(width: spacing.xs),
              Text(
                '${subscription.daysRemaining ?? 0} jours restants',
                style: theme.textTheme.labelMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
          SizedBox(height: spacing.md),
          Row(
            children: [
              Expanded(
                child: _DateLabel(
                  label: 'DÉBUT',
                  date: subscription.startsAt,
                  theme: theme,
                ),
              ),
              SizedBox(width: spacing.sm),
              Icon(
                Symbols.arrow_forward,
                size: 16,
                color: theme.colorScheme.onSurfaceVariant.withValues(
                  alpha: 0.4,
                ),
              ),
              SizedBox(width: spacing.sm),
              Expanded(
                child: _DateLabel(
                  label: 'FIN',
                  date: subscription.endsAt,
                  theme: theme,
                ),
              ),
            ],
          ),
          if (plan?.price != null || subscription.amountPaid != null) ...[
            SizedBox(height: spacing.md),
            Row(
              children: [
                Icon(
                  Symbols.payments,
                  size: 16,
                  color: theme.colorScheme.primary,
                ),
                SizedBox(width: spacing.xs),
                Text(
                  '${plan?.price.toStringAsFixed(3) ?? subscription.amountPaid?.toStringAsFixed(3) ?? '0.000'} TND/mois',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w900,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _DateLabel extends StatelessWidget {
  final String label;
  final String? date;
  final ThemeData theme;

  const _DateLabel({
    required this.label,
    required this.date,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    final spacing = context.spacing;

    return Container(
      padding: EdgeInsets.all(spacing.sm),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: theme.textTheme.labelSmall?.copyWith(
              fontWeight: FontWeight.w900,
              letterSpacing: 1.0,
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          SizedBox(height: spacing.xxs),
          Text(
            date ?? '—',
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w700,
              color: theme.colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}

class _PlanDetailsSection extends StatelessWidget {
  final Subscription subscription;
  final AppColors appColors;

  const _PlanDetailsSection({
    required this.subscription,
    required this.appColors,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = context.spacing;
    final description = subscription.plan?.description;

    if (description == null || description.isEmpty)
      return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'DESCRIPTION',
          style: theme.textTheme.labelSmall?.copyWith(
            fontWeight: FontWeight.w900,
            letterSpacing: 1.5,
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        SizedBox(height: spacing.sm),
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(spacing.md),
          decoration: BoxDecoration(
            color: appColors.bgElevated,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: appColors.bgBorder),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.all(spacing.xs),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  Symbols.description,
                  size: 20,
                  color: theme.colorScheme.primary,
                ),
              ),
              SizedBox(width: spacing.md),
              Expanded(
                child: Text(
                  description,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                    height: 1.5,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ServiceSection extends StatelessWidget {
  final Subscription subscription;

  const _ServiceSection({required this.subscription});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = context.spacing;
    final service = subscription.service;

    if (service == null) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'SERVICE',
          style: theme.textTheme.labelSmall?.copyWith(
            fontWeight: FontWeight.w900,
            letterSpacing: 1.5,
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        SizedBox(height: spacing.sm),
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(spacing.md),
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainerHighest.withValues(
              alpha: 0.3,
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  image: service.imageUrl != null
                      ? DecorationImage(
                          image: NetworkImage(service.imageUrl!),
                          fit: BoxFit.cover,
                        )
                      : null,
                  color: theme.colorScheme.primary.withValues(alpha: 0.1),
                ),
                child: service.imageUrl == null
                    ? Icon(
                        Symbols.fitness_center,
                        color: theme.colorScheme.primary,
                        size: 24,
                      )
                    : null,
              ),
              SizedBox(width: spacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      service.name ?? 'Service',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                    if (service.slug != null) ...[
                      SizedBox(height: spacing.xxs),
                      Text(
                        service.slug!.replaceAll('-', ' ').toUpperCase(),
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _PaymentSection extends StatelessWidget {
  final Subscription subscription;
  final AppColors appColors;

  const _PaymentSection({required this.subscription, required this.appColors});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = context.spacing;

    if (subscription.amountPaid == null &&
        subscription.paymentMethod == null &&
        subscription.receiptUrl == null) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'PAIEMENT',
          style: theme.textTheme.labelSmall?.copyWith(
            fontWeight: FontWeight.w900,
            letterSpacing: 1.5,
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        SizedBox(height: spacing.sm),
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(spacing.md),
          decoration: BoxDecoration(
            color: appColors.bgElevated,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: appColors.bgBorder),
          ),
          child: Column(
            children: [
              if (subscription.amountPaid != null ||
                  subscription.paymentMethod != null)
                Row(
                  children: [
                    if (subscription.amountPaid != null) ...[
                      Icon(
                        Symbols.payments,
                        size: 20,
                        color: theme.colorScheme.primary,
                      ),
                      SizedBox(width: spacing.sm),
                      Text(
                        '${subscription.amountPaid!.toStringAsFixed(3)} TND',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w900,
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                    ],
                    const Spacer(),
                    if (subscription.paymentMethod != null)
                      _PaymentMethodBadge(
                        method: subscription.paymentMethod!,
                        appColors: appColors,
                        theme: theme,
                      ),
                  ],
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class _PaymentMethodBadge extends StatelessWidget {
  final String method;
  final AppColors appColors;
  final ThemeData theme;

  const _PaymentMethodBadge({
    required this.method,
    required this.appColors,
    required this.theme,
  });

  (IconData, Color, String) _paymentMethodInfo() {
    switch (method.toLowerCase()) {
      case 'loyalty_points':
        return (Symbols.stars, const Color(0xFFF59E0B), 'Fidelity');
      case 'konnect':
        return (
          Symbols.account_balance_wallet,
          const Color(0xFF6366F1),
          'Konnect',
        );
      case 'flouci':
        return (Symbols.credit_card_gear, const Color(0xFF10B981), 'Flouci');
      case 'manual_admin':
        return (
          Symbols.admin_panel_settings,
          appColors.statusWarning,
          'Manual',
        );
      default:
        return (
          Symbols.payments,
          theme.colorScheme.onSurfaceVariant,
          method.toUpperCase(),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final (icon, color, label) = _paymentMethodInfo();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 6),
          Text(
            label,
            style: theme.textTheme.labelSmall?.copyWith(
              fontWeight: FontWeight.w800,
              color: color,
              letterSpacing: 0.3,
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = context.spacing;

    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: spacing.xxl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Symbols.workspace_premium,
              size: 64,
              color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.3),
            ),
            SizedBox(height: spacing.lg),
            Text(
              'Aucun abonnement actif',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w900,
                color: theme.colorScheme.onSurface,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: spacing.sm),
            Text(
              'Découvrez nos formules pour accéder à tous les cours et avantages.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorState({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = context.spacing;

    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: spacing.xxl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(spacing.lg),
              decoration: BoxDecoration(
                color: theme.colorScheme.error.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Symbols.wifi_off,
                size: 48,
                color: theme.colorScheme.error,
              ),
            ),
            SizedBox(height: spacing.lg),
            Text(
              'Chargement échoué',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w900,
                color: theme.colorScheme.onSurface,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: spacing.sm),
            Text(
              message,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: spacing.xl),
            FilledButton.icon(
              onPressed: onRetry,
              icon: const Icon(Symbols.refresh, size: 20),
              label: const Text('Réessayer'),
              style: FilledButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
