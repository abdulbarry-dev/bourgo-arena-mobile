import 'package:bourgo_arena_mobile/core/theme/bourgo_theme.dart';
import 'package:bourgo_arena_mobile/domain/entities/subscription.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:material_symbols_icons/symbols.dart';

class SubscriptionHistoryTile extends StatelessWidget {
  final Subscription subscription;
  final VoidCallback? onTapReceipt;

  const SubscriptionHistoryTile({
    super.key,
    required this.subscription,
    this.onTapReceipt,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = theme.extension<AppColors>()!;
    final spacing = context.spacing;

    final planName = subscription.plan?.name ?? 'Unknown Plan';
    final serviceName = subscription.service?.name;
    final isActive = subscription.isActive;

    String dateRange = '';
    if (subscription.startsAt != null && subscription.endsAt != null) {
      final start = _formatDate(subscription.startsAt!);
      final end = _formatDate(subscription.endsAt!);
      dateRange = '$start - $end';
    } else if (subscription.startsAt != null) {
      dateRange = 'From ${_formatDate(subscription.startsAt!)}';
    }

    return Container(
      margin: EdgeInsets.only(bottom: spacing.sm),
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
              Container(
                padding: EdgeInsets.all(spacing.sm),
                decoration: BoxDecoration(
                  color: appColors.brandPrimaryGhost,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(
                  Symbols.card_membership,
                  color: theme.colorScheme.primary,
                  size: 24,
                ),
              ),
              SizedBox(width: spacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      planName,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                    if (serviceName != null) ...[
                      SizedBox(height: spacing.xxs),
                      Text(
                        serviceName,
                        style: theme.textTheme.labelMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: spacing.sm,
                  vertical: spacing.xxs,
                ),
                decoration: BoxDecoration(
                  color: isActive
                      ? theme.colorScheme.primary.withValues(alpha: 0.1)
                      : theme.colorScheme.error.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  (subscription.status ?? 'unknown').toUpperCase(),
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: isActive
                        ? theme.colorScheme.primary
                        : theme.colorScheme.error,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ],
          ),
          if (dateRange.isNotEmpty) ...[
            SizedBox(height: spacing.sm),
            Row(
              children: [
                Icon(
                  Symbols.calendar_month,
                  size: 14,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                SizedBox(width: spacing.xxs),
                Text(
                  dateRange,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ],
          if (subscription.amountPaid != null) ...[
            SizedBox(height: spacing.xxs),
            Text(
              '${subscription.amountPaid!.toStringAsFixed(3)} TND',
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w900,
                color: theme.colorScheme.onSurface,
              ),
            ),
          ],
          if (subscription.daysRemaining != null && isActive) ...[
            SizedBox(height: spacing.xxs),
            Row(
              children: [
                Icon(Symbols.timer, size: 14, color: theme.colorScheme.primary),
                SizedBox(width: spacing.xxs),
                Text(
                  '${subscription.daysRemaining} days remaining',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ],
          if (onTapReceipt != null) ...[
            SizedBox(height: spacing.sm),
            GestureDetector(
              onTap: onTapReceipt,
              child: Row(
                children: [
                  Icon(
                    Symbols.receipt_long,
                    size: 16,
                    color: theme.colorScheme.primary,
                  ),
                  SizedBox(width: spacing.xxs),
                  Text(
                    'Download Receipt',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  String _formatDate(String isoDate) {
    try {
      final date = DateTime.parse(isoDate);
      return DateFormat.yMMMd().format(date);
    } catch (_) {
      return isoDate;
    }
  }
}
