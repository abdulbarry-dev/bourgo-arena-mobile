import 'package:bourgo_arena_mobile/l10n/app_localizations.dart';
import 'package:bourgo_arena_mobile/core/di/locator.dart';
import 'package:bourgo_arena_mobile/core/theme/bourgo_theme.dart';
import 'package:bourgo_arena_mobile/core/utils/haptic_utils.dart';
import 'package:bourgo_arena_mobile/domain/usecases/family/buy_child_subscription_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/family/get_child_subscriptions_use_case.dart';
import 'package:bourgo_arena_mobile/presentation/common/widgets/app_shimmer.dart';
import 'package:bourgo_arena_mobile/presentation/common/widgets/sub_screen_app_bar.dart';
import 'package:bourgo_arena_mobile/presentation/family_child/viewmodels/child_subscriptions_view_model.dart';
import 'package:bourgo_arena_mobile/presentation/profile/widgets/subscription_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';

class ChildSubscriptionsScreen extends StatefulWidget {
  final String childId;

  const ChildSubscriptionsScreen({super.key, required this.childId});

  @override
  State<ChildSubscriptionsScreen> createState() =>
      _ChildSubscriptionsScreenState();
}

class _ChildSubscriptionsScreenState extends State<ChildSubscriptionsScreen> {
  late final ChildSubscriptionsViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = ChildSubscriptionsViewModel(
      getChildSubscriptionsUseCase: locator<GetChildSubscriptionsUseCase>(),
      buyChildSubscriptionUseCase: locator<BuyChildSubscriptionUseCase>(),
    );
    _viewModel.load(widget.childId);
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = context.spacing;
    final appColors = theme.extension<AppColors>()!;

    return ListenableBuilder(
      listenable: _viewModel,
      builder: (context, _) {
        final subscriptions = _viewModel.subscriptions;

        return Scaffold(
          backgroundColor: theme.scaffoldBackgroundColor,
          appBar: SubScreenAppBar(
            title: AppLocalizations.of(context)!.familyChildSubscriptionsTitle,
          ),
          body: _viewModel.isLoading
              ? _buildLoadingState(theme, spacing)
              : RefreshIndicator(
                  onRefresh: () => _viewModel.load(widget.childId),
                  color: theme.colorScheme.primary,
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      if (_viewModel.errorMessage != null) {
                        return SingleChildScrollView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          padding: EdgeInsets.fromLTRB(
                            spacing.lg,
                            spacing.lg,
                            spacing.lg,
                            spacing.lg + MediaQuery.paddingOf(context).bottom,
                          ),
                          child: ConstrainedBox(
                            constraints: BoxConstraints(
                              minHeight: constraints.maxHeight - spacing.lg * 2,
                            ),
                            child: Center(
                              child: _ErrorState(
                                message: _viewModel.errorMessage!,
                                onRetry: () => _viewModel.load(widget.childId),
                              ),
                            ),
                          ),
                        );
                      }

                      if (subscriptions.isEmpty) {
                        return SingleChildScrollView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          padding: EdgeInsets.fromLTRB(
                            spacing.lg,
                            spacing.lg,
                            spacing.lg,
                            spacing.lg + MediaQuery.paddingOf(context).bottom,
                          ),
                          child: ConstrainedBox(
                            constraints: BoxConstraints(
                              minHeight: constraints.maxHeight - spacing.lg * 2,
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const SizedBox(),
                                _buildEmptyState(theme, spacing),
                                SizedBox(
                                  width: double.infinity,
                                  height: 56,
                                  child: ElevatedButton.icon(
                                    onPressed: () {
                                      AppHaptics.light();
                                      context.push(
                                        '/plans?childId=${widget.childId}',
                                      );
                                    },
                                    icon: const Icon(Symbols.add, size: 20),
                                    label: Text(
                                      AppLocalizations.of(
                                        context,
                                      )!.familyChildSubscriptionsBuyNew,
                                      style: const TextStyle(
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
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }

                      return SingleChildScrollView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        padding: EdgeInsets.fromLTRB(
                          spacing.lg,
                          spacing.lg,
                          spacing.lg,
                          spacing.lg + MediaQuery.paddingOf(context).bottom,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            for (int i = 0; i < subscriptions.length; i++) ...[
                              if (i > 0) ...[
                                SizedBox(height: spacing.xl),
                                Container(
                                  height: 1,
                                  color: appColors.bgBorder.withValues(
                                    alpha: 0.3,
                                  ),
                                ),
                                SizedBox(height: spacing.xl),
                              ],
                              SubscriptionCard(
                                    subscription: subscriptions[i],
                                    appColors: appColors,
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
                                    subscription: subscriptions[i],
                                    appColors: appColors,
                                  )
                                  .animate(delay: 100.ms)
                                  .fade(duration: 400.ms)
                                  .slideY(
                                    begin: 0.1,
                                    end: 0,
                                    curve: Curves.easeOutQuad,
                                  ),
                              SizedBox(height: spacing.xl),
                              ServiceSection(subscription: subscriptions[i])
                                  .animate(delay: 200.ms)
                                  .fade(duration: 400.ms)
                                  .slideY(
                                    begin: 0.1,
                                    end: 0,
                                    curve: Curves.easeOutQuad,
                                  ),
                              SizedBox(height: spacing.xl),
                              PaymentSection(
                                    subscription: subscriptions[i],
                                    appColors: appColors,
                                  )
                                  .animate(delay: 300.ms)
                                  .fade(duration: 400.ms)
                                  .slideY(
                                    begin: 0.1,
                                    end: 0,
                                    curve: Curves.easeOutQuad,
                                  ),
                            ],
                            SizedBox(height: spacing.lg),
                            SizedBox(
                              width: double.infinity,
                              height: 56,
                              child: ElevatedButton.icon(
                                onPressed: () {
                                  AppHaptics.light();
                                  context.push(
                                    '/plans?childId=${widget.childId}',
                                  );
                                },
                                icon: const Icon(Symbols.add, size: 20),
                                label: Text(
                                  AppLocalizations.of(
                                    context,
                                  )!.familyChildSubscriptionsBuyNew,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w900,
                                    letterSpacing: 1.2,
                                  ),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: theme.colorScheme.primary,
                                  foregroundColor: theme.colorScheme.onPrimary,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
        );
      },
    );
  }

  Widget _buildLoadingState(ThemeData theme, AppSpacing spacing) {
    return AppShimmer(
      child: Padding(
        padding: EdgeInsets.all(spacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: List.generate(
            5,
            (_) => Padding(
              padding: EdgeInsets.only(bottom: spacing.md),
              child: Container(
                padding: EdgeInsets.all(spacing.lg),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainerHighest.withValues(
                    alpha: 0.3,
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        AppShimmer.block(
                          width: 72,
                          height: 22,
                          borderRadius: 8,
                        ),
                        AppShimmer.block(
                          width: 40,
                          height: 40,
                          borderRadius: 8,
                        ),
                      ],
                    ),
                    SizedBox(height: spacing.md),
                    AppShimmer.block(width: 160, height: 16),
                    SizedBox(height: spacing.sm),
                    AppShimmer.block(width: 120, height: 12),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(ThemeData theme, AppSpacing spacing) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: spacing.xxl),
      child: Column(
        children: [
          Container(
                width: 112,
                height: 112,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: theme.colorScheme.primary.withValues(alpha: 0.08),
                  border: Border.all(
                    color: theme.colorScheme.primary.withValues(alpha: 0.15),
                  ),
                ),
                child: Icon(
                  Symbols.workspace_premium,
                  size: 56,
                  color: theme.colorScheme.primary,
                ),
              )
              .animate()
              .scale(duration: 400.ms, curve: Curves.easeOutBack)
              .fade(duration: 400.ms),
          SizedBox(height: spacing.xl),
          Text(
                AppLocalizations.of(
                  context,
                )!.familyChildSubscriptionsEmptyTitle,
                textAlign: TextAlign.center,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w900,
                ),
              )
              .animate(delay: 100.ms)
              .fade(duration: 400.ms)
              .slideY(begin: 0.15, end: 0, curve: Curves.easeOutQuad),
          SizedBox(height: spacing.sm),
          Text(
                AppLocalizations.of(
                  context,
                )!.familyChildSubscriptionsEmptyMessage,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              )
              .animate(delay: 200.ms)
              .fade(duration: 400.ms)
              .slideY(begin: 0.15, end: 0, curve: Curves.easeOutQuad),
        ],
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
              'Chargement \u00E9chou\u00E9',
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
              label: Text(AppLocalizations.of(context)!.commonRetry),
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
