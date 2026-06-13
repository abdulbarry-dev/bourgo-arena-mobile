import 'package:flutter/material.dart';
import 'package:bourgo_arena_mobile/domain/entities/plan.dart';
import 'package:bourgo_arena_mobile/core/theme/bourgo_theme.dart';
import 'package:bourgo_arena_mobile/l10n/app_localizations.dart';
import 'package:bourgo_arena_mobile/presentation/common/widgets/premium_network_image.dart';

class PlanCard extends StatelessWidget {
  final Plan plan;
  final VoidCallback onSubscribe;
  final bool isSubmitting;

  const PlanCard({
    super.key,
    required this.plan,
    required this.onSubscribe,
    this.isSubmitting = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = theme.extension<AppColors>()!;
    final spacing = AppSpacing.standard;

    return Container(
      width: 280,
      margin: EdgeInsets.only(right: spacing.md),
      decoration: BoxDecoration(
        color: appColors.bgElevated,
        borderRadius: BorderRadius.circular(spacing.md),
        border: Border.all(color: appColors.bgBorder),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (plan.serviceImageUrl != null)
            PremiumNetworkImage(
              imageUrl: plan.serviceImageUrl!,
              height: 120,
              fit: BoxFit.cover,
            )
          else
            Container(
              height: 120,
              color: appColors.bgSurface,
              child: const Icon(Icons.workspace_premium, size: 48),
            ),
          Padding(
            padding: spacing.all(spacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  plan.name,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: spacing.xxs),
                Text(
                  '${plan.price} TND / ${plan.billingCycle}',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: spacing.md),
                Text(
                  plan.description ?? '',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                SizedBox(height: spacing.lg),
                ElevatedButton(
                  onPressed: isSubmitting ? null : onSubscribe,
                  child: isSubmitting
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Text(
                          AppLocalizations.of(context)!
                              .planCardSubscribeButton,
                        ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
