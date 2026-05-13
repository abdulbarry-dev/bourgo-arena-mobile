import 'package:bourgo_arena_mobile/core/constants/app_constants.dart';
import 'package:bourgo_arena_mobile/domain/entities/subscription.dart';
import 'package:bourgo_arena_mobile/domain/usecases/subscription/get_active_subscription_use_case.dart';
import 'package:bourgo_arena_mobile/core/di/locator.dart';
import 'package:bourgo_arena_mobile/l10n/app_localizations.dart';
import 'package:bourgo_arena_mobile/presentation/profile/subscription_view_model.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

/// Screen displaying the user's subscription details.
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
      getActiveSubscriptionUseCase: locator<GetActiveSubscriptionUseCase>(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return ListenableBuilder(
      listenable: _viewModel,
      builder: (context, _) {
        final subscription = _viewModel.subscription;

        return Scaffold(
          appBar: AppBar(
            title: Text(l10n.profileSubscriptionTitle),
            backgroundColor: theme.colorScheme.surface,
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _ActivePlanCard(
                  subscription: subscription,
                  fallbackPlanLabel: l10n.profilePlanLabel,
                  fallbackNextBilling: l10n.profileNextBilling,
                ),
                const SizedBox(height: 32),
                Text(
                  l10n.profileAdvantages,
                  style: theme.textTheme.labelSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.5,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 16),
                ..._buildBenefits(subscription, l10n),
                const SizedBox(height: 40),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 56),
                  ),
                  child: Text(l10n.profileManageSubscription),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  List<Widget> _buildBenefits(
    Subscription? subscription,
    AppLocalizations l10n,
  ) {
    final benefits = subscription?.benefits;
    if (benefits != null && benefits.isNotEmpty) {
      return benefits.map((benefit) => _BenefitItem(text: benefit)).toList();
    }

    return [
      _BenefitItem(text: l10n.profileBenefit1),
      _BenefitItem(text: l10n.profileBenefit2),
      _BenefitItem(text: l10n.profileBenefit3),
      _BenefitItem(text: l10n.profileBenefit4),
    ];
  }
}

class _ActivePlanCard extends StatelessWidget {
  final Subscription? subscription;
  final String fallbackPlanLabel;
  final String fallbackNextBilling;

  const _ActivePlanCard({
    required this.subscription,
    required this.fallbackPlanLabel,
    required this.fallbackNextBilling,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: theme.colorScheme.primary.withAlpha(50)),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            theme.colorScheme.surface,
            theme.colorScheme.primary.withAlpha(15),
          ],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                subscription?.name ?? fallbackPlanLabel,
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontFamily: AppConstants.displayFontFamily,
                  color: theme.colorScheme.primary,
                ),
              ),
              Icon(
                Symbols.verified,
                color: theme.colorScheme.onSurface.withValues(alpha: 0.2),
                size: 40,
              ),
            ],
          ),
          const SizedBox(height: 24),
          Text(
            fallbackNextBilling,
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              letterSpacing: 1,
            ),
          ),
          Text(
            subscription?.durationMonths != null
                ? '${subscription!.durationMonths} months'
                : '...',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 24),
          LinearProgressIndicator(
            value: 0.7,
            backgroundColor: theme.colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(2),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                AppLocalizations.of(context)!.profileMonthlyUsage,
                style: theme.textTheme.labelSmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              Text(
                '70%',
                style: theme.textTheme.labelSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _BenefitItem extends StatelessWidget {
  final String text;

  const _BenefitItem({required this.text});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(
            Symbols.check_circle,
            color: theme.colorScheme.primary,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
