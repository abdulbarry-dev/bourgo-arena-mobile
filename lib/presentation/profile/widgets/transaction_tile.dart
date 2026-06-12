import 'package:bourgo_arena_mobile/core/constants/app_constants.dart';
import 'package:bourgo_arena_mobile/core/theme/bourgo_theme.dart';
import 'package:bourgo_arena_mobile/domain/entities/payment.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:material_symbols_icons/symbols.dart';

class TransactionTile extends StatelessWidget {
  final Payment payment;

  const TransactionTile({super.key, required this.payment});

  IconData _iconForType(String type) {
    switch (type) {
      case 'subscription':
        return Symbols.card_membership;
      case 'reservation':
      case 'reservation_deposit':
        return Symbols.event;
      case 'loyalty_points':
        return Symbols.stars;
      default:
        return Symbols.payments;
    }
  }

  String? _gatewayLabel(String? gateway) {
    if (gateway == null) return null;
    switch (gateway.toLowerCase()) {
      case 'konnect':
        return 'Konnect';
      case 'flouci':
        return 'Flouci';
      case 'loyalty_points':
        return 'Fidelity';
      case 'manual_admin':
        return 'Manual';
      default:
        return gateway;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = theme.extension<AppColors>()!;
    final formattedDate = DateFormat('d MMM yyyy').format(payment.createdAt);
    final formattedTime = DateFormat.Hm().format(payment.createdAt);
    final isSuccess =
        payment.status.toLowerCase() == 'paid' ||
        payment.status.toLowerCase() == 'success';
    final isPending = payment.status.toLowerCase() == 'initiated';

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: appColors.bgElevated,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: appColors.bgBorder),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: isSuccess
                    ? theme.colorScheme.primary.withValues(alpha: 0.12)
                    : isPending
                    ? Colors.amber.withValues(alpha: 0.12)
                    : theme.colorScheme.error.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(
                _iconForType(payment.type),
                color: isSuccess
                    ? theme.colorScheme.primary
                    : isPending
                    ? Colors.amber.shade700
                    : theme.colorScheme.error,
                size: 22,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          payment.description.isNotEmpty
                              ? payment.description
                              : payment.type == 'subscription'
                              ? 'Subscription'
                              : payment.type == 'reservation_deposit'
                              ? 'Reservation Deposit'
                              : 'Reservation',
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontFamily: AppConstants.displayFontFamily,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.5,
                            color: theme.colorScheme.onSurface,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '${payment.amount.toStringAsFixed(2)} TND',
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontFamily: AppConstants.displayFontFamily,
                          fontWeight: FontWeight.w900,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Icon(
                        Symbols.schedule,
                        size: 14,
                        color: theme.colorScheme.onSurfaceVariant.withValues(
                          alpha: 0.5,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '$formattedDate · $formattedTime',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant.withValues(
                            alpha: 0.6,
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (payment.paymentReference.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Symbols.tag,
                          size: 14,
                          color: theme.colorScheme.onSurfaceVariant.withValues(
                            alpha: 0.4,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          payment.paymentReference,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant
                                .withValues(alpha: 0.45),
                            fontSize: 11,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(width: 10),
            Column(
              children: [
                if (_gatewayLabel(payment.gateway) != null)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: appColors.bgSurface,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: appColors.bgBorder),
                    ),
                    child: Text(
                      _gatewayLabel(payment.gateway)!,
                      style: theme.textTheme.labelSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: theme.colorScheme.onSurfaceVariant,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: isSuccess
                        ? theme.colorScheme.primary.withValues(alpha: 0.12)
                        : isPending
                        ? Colors.amber.withValues(alpha: 0.12)
                        : theme.colorScheme.error.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    payment.status.toUpperCase(),
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: isSuccess
                          ? theme.colorScheme.primary
                          : isPending
                          ? Colors.amber.shade700
                          : theme.colorScheme.error,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
