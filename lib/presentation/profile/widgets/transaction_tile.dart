import 'package:flutter/material.dart';
import 'package:bourgo_arena_mobile/domain/entities/payment.dart';
import 'package:bourgo_arena_mobile/core/theme/bourgo_theme.dart';
import 'package:intl/intl.dart';

class TransactionTile extends StatelessWidget {
  final Payment payment;

  const TransactionTile({super.key, required this.payment});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = AppSpacing.standard;

    // Formatting date and amount
    final formattedDate = DateFormat.yMMMd().format(payment.createdAt);
    final isSuccess = payment.status.toLowerCase() == 'success';

    return Container(
      margin: EdgeInsets.only(bottom: spacing.sm),
      padding: spacing.all(spacing.md),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border(bottom: BorderSide(color: theme.colorScheme.outlineVariant)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            backgroundColor: theme.colorScheme.primary.withOpacity(0.1),
            child: Icon(
              Icons.credit_card,
              color: theme.colorScheme.primary,
            ),
          ),
          SizedBox(width: spacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  payment.paymentReference,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: spacing.xxs),
                Text(
                  formattedDate,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '\$${payment.amount.toStringAsFixed(2)} ${payment.currency}',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: spacing.xs),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: spacing.sm,
                  vertical: spacing.xxs,
                ),
                decoration: BoxDecoration(
                  color: isSuccess ? Colors.green.withOpacity(0.2) : Colors.red.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(spacing.md),
                ),
                child: Text(
                  payment.status.toUpperCase(),
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: isSuccess ? Colors.green[800] : Colors.red[800],
                    fontWeight: FontWeight.bold,
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
