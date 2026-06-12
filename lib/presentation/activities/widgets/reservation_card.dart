import 'package:bourgo_arena_mobile/core/theme/bourgo_theme.dart';
import 'package:bourgo_arena_mobile/domain/entities/reservation.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

class ReservationCard extends StatelessWidget {
  final Reservation reservation;

  const ReservationCard({super.key, required this.reservation});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = theme.extension<AppColors>()!;
    final spacing = context.spacing;

    return Container(
      margin: EdgeInsets.only(bottom: spacing.md),
      padding: EdgeInsets.all(spacing.md),
      decoration: BoxDecoration(
        color: appColors.bgSurface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: appColors.bgBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _StatusBadge(status: reservation.status),
              const Spacer(),
              Text(
                '#${reservation.id.length > 8 ? reservation.id.substring(0, 8) : reservation.id}',
                style: theme.textTheme.labelSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
          SizedBox(height: spacing.md),
          Text(
            reservation.activityTitle.toUpperCase(),
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w900,
              letterSpacing: -0.3,
            ),
          ),
          SizedBox(height: spacing.sm),
          Row(
            children: [
              Icon(
                Symbols.calendar_today,
                size: 14,
                color: theme.colorScheme.primary,
              ),
              SizedBox(width: spacing.xs),
              Text(
                reservation.date,
                style: theme.textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              SizedBox(width: spacing.md),
              Icon(
                Symbols.schedule,
                size: 14,
                color: theme.colorScheme.primary,
              ),
              SizedBox(width: spacing.xs),
              Text(
                reservation.time,
                style: theme.textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
          SizedBox(height: spacing.sm),
          Row(
            children: [
              Icon(
                Symbols.payments,
                size: 14,
                color: theme.colorScheme.primary,
              ),
              SizedBox(width: spacing.xs),
              Text(
                '${reservation.price.toStringAsFixed(3)} TND',
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w900,
                  color: theme.colorScheme.onSurface,
                ),
              ),
              if (reservation.paymentStatus.isNotEmpty) ...[
                const Spacer(),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: spacing.sm,
                    vertical: spacing.xxs,
                  ),
                  decoration: BoxDecoration(
                    color: reservation.paymentStatus == 'paid'
                        ? theme.colorScheme.primary.withValues(alpha: 0.1)
                        : Colors.orange.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    reservation.paymentStatus.toUpperCase(),
                    style: theme.textTheme.labelSmall?.copyWith(
                      fontWeight: FontWeight.w900,
                      color: reservation.paymentStatus == 'paid'
                          ? theme.colorScheme.primary
                          : Colors.orange,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final String status;

  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final (Color color, String label, IconData icon) = switch (status
        .toLowerCase()) {
      'confirmed' => (
        theme.colorScheme.primary,
        'CONFIRMÉ',
        Symbols.check_circle,
      ),
      'pending' => (Colors.orange, 'EN ATTENTE', Symbols.schedule),
      'cancelled' => (theme.colorScheme.error, 'ANNULÉ', Symbols.cancel),
      _ => (
        theme.colorScheme.onSurfaceVariant,
        status.toUpperCase(),
        Symbols.info,
      ),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 10,
              fontWeight: FontWeight.w900,
              letterSpacing: 1,
            ),
          ),
        ],
      ),
    );
  }
}
