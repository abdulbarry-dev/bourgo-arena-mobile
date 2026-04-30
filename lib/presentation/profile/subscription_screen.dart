import 'package:bourgo_arena_mobile/core/constants.dart';
import 'package:bourgo_arena_mobile/data/services/data_service.dart';
import 'package:bourgo_arena_mobile/presentation/profile/profile_view_model.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

/// Screen displaying the user's subscription details.
class SubscriptionScreen extends StatefulWidget {
  const SubscriptionScreen({super.key});

  @override
  State<SubscriptionScreen> createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen> {
  late final ProfileViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = ProfileViewModel(dataService: DataService());
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListenableBuilder(
      listenable: _viewModel,
      builder: (context, _) {
        final profile = _viewModel.profile;

        return Scaffold(
          appBar: AppBar(
            title: const Text(AppConstants.profileSubscriptionTitle),
            backgroundColor: theme.colorScheme.surface,
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _ActivePlanCard(profile: profile),
                const SizedBox(height: 32),
                const Text(
                  AppConstants.profileAdvantages,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.5,
                    color: Colors.white54,
                  ),
                ),
                const SizedBox(height: 16),
                _BenefitItem(text: AppConstants.profileBenefit1),
                _BenefitItem(text: AppConstants.profileBenefit2),
                _BenefitItem(text: AppConstants.profileBenefit3),
                _BenefitItem(text: AppConstants.profileBenefit4),
                const SizedBox(height: 40),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 56),
                  ),
                  child: const Text(AppConstants.profileManageSubscription),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _ActivePlanCard extends StatelessWidget {
  final dynamic profile;

  const _ActivePlanCard({required this.profile});

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
                profile?.subscriptionLevel ?? AppConstants.profilePlanLabel,
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontFamily: 'BlackHanSans',
                  color: theme.colorScheme.primary,
                ),
              ),
              const Icon(Symbols.verified, color: Colors.white24, size: 40),
            ],
          ),
          const SizedBox(height: 24),
          const Text(
            AppConstants.profileNextBilling,
            style: TextStyle(
              color: Colors.white54,
              fontSize: 10,
              letterSpacing: 1,
            ),
          ),
          Text(
            profile?.subscriptionExpiry ?? '...',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          const SizedBox(height: 24),
          LinearProgressIndicator(
            value: 0.7,
            backgroundColor: Colors.white12,
            borderRadius: BorderRadius.circular(2),
          ),
          const SizedBox(height: 8),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                AppConstants.profileMonthlyUsage,
                style: TextStyle(color: Colors.white54, fontSize: 12),
              ),
              Text(
                '70%',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
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
          Text(text, style: const TextStyle(color: Colors.white70)),
        ],
      ),
    );
  }
}
