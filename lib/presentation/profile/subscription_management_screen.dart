import 'package:bourgo_arena_mobile/domain/entities/subscription.dart';
import 'package:bourgo_arena_mobile/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

/// Screen for managing subscription plans.
class SubscriptionManagementScreen extends StatelessWidget {
  final Subscription? currentSubscription;

  const SubscriptionManagementScreen({super.key, this.currentSubscription});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.profileManageSubscription),
        backgroundColor: theme.colorScheme.surface,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.subscriptionSelectPlanTitle,
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),
            _PlanOption(
              title: l10n.subscriptionPlanBasic,
              price: '19.99',
              selected: currentSubscription?.name == 'Basic',
              onTap: () {},
            ),
            const SizedBox(height: 16),
            _PlanOption(
              title: l10n.subscriptionPlanPremium,
              price: '49.99',
              selected: currentSubscription?.name == 'Premium',
              onTap: () {},
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 56),
              ),
              child: Text(l10n.subscriptionConfirmPlan),
            ),
          ],
        ),
      ),
    );
  }
}

class _PlanOption extends StatelessWidget {
  final String title;
  final String price;
  final bool selected;
  final VoidCallback onTap;

  const _PlanOption({
    required this.title,
    required this.price,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: selected
              ? theme.colorScheme.primary.withAlpha(25)
              : theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: selected
                ? theme.colorScheme.primary
                : theme.colorScheme.outlineVariant,
            width: selected ? 2 : 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  AppLocalizations.of(
                    context,
                  )!.subscriptionPricePerMonth(price),
                ),
              ],
            ),
            if (selected)
              Icon(Icons.check_circle, color: theme.colorScheme.primary),
          ],
        ),
      ),
    );
  }
}
