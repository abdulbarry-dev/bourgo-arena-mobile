import 'package:bourgo_arena_mobile/core/theme/bourgo_theme.dart';
import 'package:bourgo_arena_mobile/domain/entities/payment.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:material_symbols_icons/symbols.dart';

class TransactionTile extends StatelessWidget {
  final Payment payment;
  final VoidCallback? onTapReceipt;

  const TransactionTile({super.key, required this.payment, this.onTapReceipt});

  IconData _iconForType(String type) {
    switch (type.toLowerCase()) {
      case 'subscription':
        return Symbols.card_membership;
      case 'reservation':
        return Symbols.event;
      default:
        return Symbols.payments;
    }
  }

  String _gatewayLabel(String gateway) {
    switch (gateway.toLowerCase()) {
      case 'konnect':
        return 'Konnect';
      case 'flouci':
        return 'Flouci';
      default:
        return gateway;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = theme.extension<AppColors>()!;
    final spacing = context.spacing;

    final formattedDate = DateFormat.yMMMd().format(payment.createdAt);
    final formattedTime = DateFormat.Hm().format(payment.createdAt);
    final isSuccess =
        payment.status.toLowerCase() == 'success' ||
        payment.status.toLowerCase() == 'paid';

    return Container(
      margin: EdgeInsets.only(bottom: spacing.sm),
      padding: EdgeInsets.all(spacing.md),
      decoration: BoxDecoration(
        color: appColors.bgSurface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: appColors.bgBorder),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(spacing.sm),
            decoration: BoxDecoration(
              color: appColors.brandPrimaryGhost,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(
              _iconForType(payment.type),
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
                  payment.description,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                SizedBox(height: spacing.xxs),
                Text(
                  '$formattedDate à $formattedTime',
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                SizedBox(height: spacing.xxs),
                Text(
                  '${payment.paymentReference} • ${_gatewayLabel(payment.gateway)}',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
                  ),
                ),
                if (payment.receiptUrl != null) ...[
                  SizedBox(height: spacing.xs),
                  GestureDetector(
                    onTap: onTapReceipt,
                    child: Row(
                      children: [
                        Icon(
                          Symbols.receipt_long,
                          size: 14,
                          color: theme.colorScheme.primary,
                        ),
                        SizedBox(width: spacing.xxs),
                        Text(
                          'Voir le reçu',
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
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${payment.amount.toStringAsFixed(3)} TND',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w900,
                  color: theme.colorScheme.onSurface,
                ),
              ),
              SizedBox(height: spacing.xxs),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: spacing.sm,
                  vertical: spacing.xxs,
                ),
                decoration: BoxDecoration(
                  color: isSuccess
                      ? theme.colorScheme.primary.withValues(alpha: 0.1)
                      : theme.colorScheme.error.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  payment.status.toUpperCase(),
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: isSuccess
                        ? theme.colorScheme.primary
                        : theme.colorScheme.error,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
