import 'package:bourgo_arena_mobile/domain/usecases/family/get_children_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/subscription/get_active_subscriptions_use_case.dart';
import 'package:bourgo_arena_mobile/presentation/profile/widgets/subscription_card.dart';

import 'package:bourgo_arena_mobile/core/di/locator.dart';
import 'package:bourgo_arena_mobile/presentation/profile/subscription_view_model.dart';
import 'package:bourgo_arena_mobile/core/theme/bourgo_theme.dart';
import 'package:bourgo_arena_mobile/presentation/common/widgets/sub_screen_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';

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
      getActiveSubscriptionsUseCase: locator<GetActiveSubscriptionsUseCase>(),
      getChildrenUseCase: locator<GetChildrenUseCase>(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = context.spacing;

    return ListenableBuilder(
      listenable: _viewModel,
      builder: (context, _) {
        final subscriptions = _viewModel.memberSubscriptions;

        return Scaffold(
          backgroundColor: theme.scaffoldBackgroundColor,
          appBar: SubScreenAppBar(title: 'MON ABONNEMENT'),
          body: _viewModel.isLoading && subscriptions.isEmpty
              ? const Center(child: CircularProgressIndicator())
              : RefreshIndicator(
                  onRefresh: _viewModel.loadSubscription,
                  color: theme.colorScheme.primary,
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: EdgeInsets.all(spacing.lg),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (subscriptions.isNotEmpty) ...[
                          for (int i = 0; i < subscriptions.length; i++) ...[
                            if (i > 0) ...[
                              SizedBox(height: spacing.xl),
                              Container(
                                height: 1,
                                color: theme
                                    .extension<AppColors>()!
                                    .bgBorder
                                    .withValues(alpha: 0.3),
                              ),
                              SizedBox(height: spacing.xl),
                            ],
                            SubscriptionCard(
                                  subscription: subscriptions[i].subscription,
                                  appColors: theme.extension<AppColors>()!,
                                )
                                .animate()
                                .fade(duration: 400.ms)
                                .slideY(
                                  begin: 0.1,
                                  end: 0,
                                  curve: Curves.easeOutQuad,
                                ),
                            SizedBox(height: spacing.xl),
                            PlanDetailsSection(
                                  subscription: subscriptions[i].subscription,
                                  appColors: theme.extension<AppColors>()!,
                                )
                                .animate(delay: 100.ms)
                                .fade(duration: 400.ms)
                                .slideY(
                                  begin: 0.1,
                                  end: 0,
                                  curve: Curves.easeOutQuad,
                                ),
                            SizedBox(height: spacing.xl),
                            ServiceSection(
                                  subscription: subscriptions[i].subscription,
                                )
                                .animate(delay: 200.ms)
                                .fade(duration: 400.ms)
                                .slideY(
                                  begin: 0.1,
                                  end: 0,
                                  curve: Curves.easeOutQuad,
                                ),
                            SizedBox(height: spacing.xl),
                            PaymentSection(
                                  subscription: subscriptions[i].subscription,
                                  appColors: theme.extension<AppColors>()!,
                                )
                                .animate(delay: 300.ms)
                                .fade(duration: 400.ms)
                                .slideY(
                                  begin: 0.1,
                                  end: 0,
                                  curve: Curves.easeOutQuad,
                                ),
                          ],
                        ] else if (_viewModel.errorMessage != null) ...[
                          _ErrorState(
                            message: _viewModel.errorMessage!,
                            onRetry: _viewModel.loadSubscription,
                          ),
                        ] else ...[
                          _EmptyState(),
                        ],
                        SizedBox(height: spacing.lg),
                        SizedBox(
                          width: double.infinity,
                          height: 56,
                          child:
                              ElevatedButton.icon(
                                    onPressed: () => context.push('/plans'),
                                    icon: const Icon(Symbols.explore, size: 20),
                                    label: const Text(
                                      'VOIR LES OFFRES',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w900,
                                        letterSpacing: 1.2,
                                      ),
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                          theme.colorScheme.primary,
                                      foregroundColor:
                                          theme.colorScheme.onPrimary,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                    ),
                                  )
                                  .animate(delay: 400.ms)
                                  .fade(duration: 400.ms)
                                  .slideY(
                                    begin: 0.1,
                                    end: 0,
                                    curve: Curves.easeOutQuad,
                                  ),
                        ),
                        SizedBox(height: spacing.xl),
                      ],
                    ),
                  ),
                ),
        );
      },
    );
  }
}

class _EmptyState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = context.spacing;

    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: spacing.xxl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Symbols.workspace_premium,
              size: 64,
              color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.3),
            ),
            SizedBox(height: spacing.lg),
            Text(
              'Aucun abonnement actif',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w900,
                color: theme.colorScheme.onSurface,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: spacing.sm),
            Text(
              'Découvrez nos formules pour accéder à tous les cours et avantages.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorState({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = context.spacing;

    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: spacing.xxl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(spacing.lg),
              decoration: BoxDecoration(
                color: theme.colorScheme.error.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Symbols.wifi_off,
                size: 48,
                color: theme.colorScheme.error,
              ),
            ),
            SizedBox(height: spacing.lg),
            Text(
              'Chargement échoué',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w900,
                color: theme.colorScheme.onSurface,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: spacing.sm),
            Text(
              message,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: spacing.xl),
            FilledButton.icon(
              onPressed: onRetry,
              icon: const Icon(Symbols.refresh, size: 20),
              label: const Text('Réessayer'),
              style: FilledButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
