import 'package:bourgo_arena_mobile/core/constants/app_constants.dart';
import 'package:bourgo_arena_mobile/core/theme/bourgo_theme.dart';
import 'package:bourgo_arena_mobile/domain/entities/member_tier.dart';
import 'package:bourgo_arena_mobile/l10n/app_localizations.dart';
import 'package:bourgo_arena_mobile/presentation/loyalty/loyalty_dashboard_view_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:bourgo_arena_mobile/domain/entities/loyalty_balance.dart';

/// Loyalty Dashboard screen showing points, progress, and transactions.
class LoyaltyDashboardScreen extends StatelessWidget {
  final LoyaltyDashboardViewModel viewModel;

  const LoyaltyDashboardScreen({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = theme.extension<AppColors>()!;
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: theme.colorScheme.primaryContainer.withValues(
                  alpha: 0.5,
                ),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(
                Symbols.stars,
                color: theme.colorScheme.primary,
                size: 22,
              ),
            ),
            const SizedBox(width: 16),
            Text(
              l10n.loyaltyDashboardTitle,
              style: theme.textTheme.headlineSmall?.copyWith(
                fontFamily: AppConstants.displayFontFamily,
                fontWeight: FontWeight.w900,
                letterSpacing: 0.5,
                color: theme.colorScheme.onSurface,
              ),
            ),
          ],
        ),
        backgroundColor: appColors.bgSurface.withValues(alpha: 0.9),
      ),
      body: AnimatedBuilder(
        animation: viewModel,
        builder: (context, _) {
          if (viewModel.isLoading &&
              viewModel.currentPoints == 0 &&
              viewModel.recentTransactions.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          final points = viewModel.currentPoints;
          final currentTier = viewModel.currentTier;
          final nextTier = viewModel.nextTier;
          final pointsToNext = viewModel.pointsToNextTier;
          final progress = viewModel.progressToNextTier;

          final String tierName = switch (currentTier) {
            MemberTier.standard => l10n.profileStandardTier,
            MemberTier.ultra => l10n.loyaltyGoldMember,
            _ => currentTier.label,
          };

          final String nextTierLabel = switch (nextTier) {
            MemberTier.ultra => 'Platinum',
            MemberTier.standard => 'Gold',
            _ => nextTier?.label ?? '',
          };

          final userName = (viewModel.user?.name.trim().isNotEmpty == true)
              ? viewModel.user!.name
              : 'Guest Member';

          return RefreshIndicator(
            onRefresh: () => viewModel.loadBalance(),
            child: CustomScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: [
                SliverPadding(
                  padding: const EdgeInsets.all(20),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      _buildPointsCard(
                        context,
                        theme,
                        appColors,
                        l10n,
                        points,
                        tierName,
                        userName,
                      ),
                      const SizedBox(height: 24),
                      if (nextTier != null)
                        _buildProgressBar(
                          context,
                          theme,
                          appColors,
                          l10n,
                          progress,
                          pointsToNext,
                          nextTierLabel,
                        )
                      else
                        _buildMaxTierMessage(context, theme),
                      const SizedBox(height: 32),
                      _buildSectionTitle(
                        context,
                        theme,
                        l10n.loyaltyRecentTransactions,
                      ),
                      const SizedBox(height: 16),
                    ]),
                  ),
                ),
                if (viewModel.recentTransactions.isEmpty)
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: _buildEmptyState(context, theme, appColors, l10n),
                  )
                else
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 8,
                    ),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate((context, index) {
                        final tx = viewModel.recentTransactions[index];
                        return _buildTransactionItem(
                          context,
                          theme,
                          appColors,
                          tx,
                        );
                      }, childCount: viewModel.recentTransactions.length),
                    ),
                  ),
                const SliverToBoxAdapter(child: SizedBox(height: 40)),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildPointsCard(
    BuildContext context,
    ThemeData theme,
    AppColors appColors,
    AppLocalizations l10n,
    int points,
    String tierName,
    String userName,
  ) {
    final formattedPoints = NumberFormat(
      '#,###',
    ).format(points).replaceAll(',', ' ');

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF2A2D34), // Sleek dark slate
            Color(0xFF141518), // Deeper slate
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'BOURGO LOYALTY',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.5),
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2.0,
                  fontSize: 10,
                ),
              ),
              Icon(
                Symbols.contactless,
                color: Colors.white.withValues(alpha: 0.5),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Text(
            l10n.loyaltyTotalPoints.toUpperCase(),
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.7),
              fontWeight: FontWeight.w500,
              letterSpacing: 1.0,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            formattedPoints,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 40,
              fontWeight: FontWeight.w900,
              letterSpacing: 2.0,
            ),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'MEMBER',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.5),
                      fontSize: 8,
                      letterSpacing: 1.5,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    userName.toUpperCase(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.5,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.2),
                  ),
                ),
                child: Text(
                  tierName.toUpperCase(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.0,
                    fontSize: 10,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProgressBar(
    BuildContext context,
    ThemeData theme,
    AppColors appColors,
    AppLocalizations l10n,
    double progress,
    int pointsToNext,
    String nextTierLabel,
  ) {
    final numberFormat = NumberFormat('#,###');
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Stack(
          children: [
            Container(
              height: 12,
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(6),
              ),
            ),
            FractionallySizedBox(
              widthFactor: progress,
              child: Container(
                height: 12,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      theme.colorScheme.primary.withValues(alpha: 0.7),
                      theme.colorScheme.primary,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(6),
                  boxShadow: [
                    BoxShadow(
                      color: theme.colorScheme.primary.withValues(alpha: 0.4),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Text(
          l10n
              .loyaltyPointsToPlatinum(numberFormat.format(pointsToNext))
              .replaceAll('Platinum', nextTierLabel),
          textAlign: TextAlign.center,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildMaxTierMessage(BuildContext context, ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.colorScheme.primary.withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Symbols.workspace_premium, color: theme.colorScheme.primary),
          const SizedBox(width: 12),
          Text(
            'Highest tier reached!',
            style: theme.textTheme.titleSmall?.copyWith(
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(
    BuildContext context,
    ThemeData theme,
    String title,
  ) {
    return Text(
      title.toUpperCase(),
      style: theme.textTheme.labelSmall?.copyWith(
        color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
        fontWeight: FontWeight.bold,
        letterSpacing: 1.5,
      ),
    );
  }

  Widget _buildEmptyState(
    BuildContext context,
    ThemeData theme,
    AppColors appColors,
    AppLocalizations l10n,
  ) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withValues(alpha: 0.05),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Symbols.receipt_long,
              size: 64,
              color: theme.colorScheme.primary.withValues(alpha: 0.5),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            l10n.loyaltyNoTransactions,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Text(
              l10n.loyaltyNoTransactionsSubtitle,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant.withValues(
                  alpha: 0.8,
                ),
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionItem(
    BuildContext context,
    ThemeData theme,
    AppColors appColors,
    LoyaltyTransaction tx,
  ) {
    final bool isPositive = tx.points >= 0;
    final color = isPositive ? Colors.green.shade600 : Colors.red.shade600;
    final icon = isPositive ? Symbols.add_circle : Symbols.remove_circle;
    final sign = isPositive ? '+' : '';

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: appColors.bgElevated,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: appColors.bgBorder, width: 1),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  tx.description ??
                      (isPositive ? 'Points Earned' : 'Points Redeemed'),
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                if (tx.createdAt != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    _formatDate(tx.createdAt!),
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant.withValues(
                        alpha: 0.7,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
          Text(
            '$sign${tx.points}',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w900,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(String isoString) {
    try {
      final date = DateTime.parse(isoString);
      return DateFormat('MMM d, yyyy').format(date);
    } catch (e) {
      return isoString;
    }
  }
}
