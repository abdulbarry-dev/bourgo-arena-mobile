import 'package:bourgo_arena_mobile/core/theme/bourgo_theme.dart';
import 'package:bourgo_arena_mobile/domain/entities/subscription.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

class SubscriptionCard extends StatelessWidget {
  final Subscription subscription;
  final AppColors appColors;

  const SubscriptionCard({required this.subscription, required this.appColors});

  String _statusLabel(String status) {
    switch (status.toLowerCase()) {
      case 'active':
        return 'ACTIF';
      case 'expired':
        return 'EXPIR\u00C9';
      case 'cancelled':
        return 'ANNUL\u00C9';
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
                child: DateLabel(
                  label: 'D\u00C9BUT',
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
                child: DateLabel(
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

class DateLabel extends StatelessWidget {
  final String label;
  final String? date;
  final ThemeData theme;

  const DateLabel({
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
            date ?? '\u2014',
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

class PlanDetailsSection extends StatelessWidget {
  final Subscription subscription;
  final AppColors appColors;

  const PlanDetailsSection({
    required this.subscription,
    required this.appColors,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = context.spacing;
    final description = subscription.plan?.description;

    if (description == null || description.isEmpty) {
      return const SizedBox.shrink();
    }

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

class ServiceSection extends StatelessWidget {
  final Subscription subscription;

  const ServiceSection({required this.subscription});

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

class PaymentSection extends StatelessWidget {
  final Subscription subscription;
  final AppColors appColors;

  const PaymentSection({required this.subscription, required this.appColors});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = context.spacing;

    if (subscription.amountPaid == null && subscription.paymentMethod == null) {
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
                      PaymentMethodBadge(
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

class PaymentMethodBadge extends StatelessWidget {
  final String method;
  final AppColors appColors;
  final ThemeData theme;

  const PaymentMethodBadge({
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
