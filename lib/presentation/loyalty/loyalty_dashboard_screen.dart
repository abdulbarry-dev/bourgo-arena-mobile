import 'package:bourgo_arena_mobile/domain/entities/member_tier.dart';
import 'package:bourgo_arena_mobile/l10n/app_localizations.dart';
import 'package:bourgo_arena_mobile/presentation/loyalty/loyalty_dashboard_view_model.dart';
import 'package:bourgo_arena_mobile/presentation/loyalty/widgets/tier_badge.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Loyalty Dashboard screen showing points and progress.
class LoyaltyDashboardScreen extends StatelessWidget {
  final LoyaltyDashboardViewModel viewModel;

  const LoyaltyDashboardScreen({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final numberFormat = NumberFormat('#,###');

    return Scaffold(
      appBar: AppBar(title: Text(l10n.loyaltyDashboardTitle)),
      body: AnimatedBuilder(
        animation: viewModel,
        builder: (context, _) {
          final points = viewModel.currentPoints;
          final currentTier = viewModel.currentTier;
          final nextTier = viewModel.nextTier;
          final pointsToNext = viewModel.pointsToNextTier;
          final progress = viewModel.progressToNextTier;

          // Map current tier to localized string if possible, otherwise use domain label.
          final String tierName = switch (currentTier) {
            MemberTier.standard => l10n.profileStandardTier,
            MemberTier.ultra =>
              l10n.loyaltyGoldMember, // Assuming Ultra mapping to Gold for now based on previous UI
            _ => currentTier.label,
          };

          // Map next tier name for the progress message.
          final String nextTierLabel = switch (nextTier) {
            MemberTier.ultra =>
              'Platinum', // Assuming mapping for demo consistency
            MemberTier.standard => 'Gold',
            _ => nextTier?.label ?? '',
          };

          return SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Column(
                    children: [
                      Text(
                        l10n.loyaltyTotalPoints,
                        style: const TextStyle(color: Colors.white70),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        numberFormat.format(points),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      TierBadge(tierName: tierName),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                if (nextTier != null) ...[
                  LinearProgressIndicator(
                    value: progress,
                    backgroundColor: theme.colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(8),
                    minHeight: 8,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    l10n
                        .loyaltyPointsToPlatinum(
                          numberFormat.format(pointsToNext),
                        )
                        .replaceAll('Platinum', nextTierLabel),
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ] else ...[
                  Text(
                    'You have reached the highest tier!',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }
}
