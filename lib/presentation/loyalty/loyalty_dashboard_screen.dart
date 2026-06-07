import 'package:bourgo_arena_mobile/core/theme/bourgo_theme.dart';
import 'package:bourgo_arena_mobile/domain/entities/loyalty_balance.dart';
import 'package:bourgo_arena_mobile/domain/entities/member_tier.dart';
import 'package:bourgo_arena_mobile/presentation/loyalty/loyalty_dashboard_view_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:material_symbols_icons/symbols.dart';

({String label, IconData icon}) _mapSourceType(String sourceType) {
  switch (sourceType) {
    case 'daily_checkin':
      return (label: 'Check-in quotidien', icon: Symbols.calendar_check);
    case 'referral':
      return (label: 'Parrainage', icon: Symbols.person_add);
    case 'subscription_renewal':
      return (label: "Renouvellement d'abonnement", icon: Symbols.card_membership);
    case 'reservation_completed':
      return (label: 'Réservation complétée', icon: Symbols.event_available);
    case 'welcome_bonus':
      return (label: 'Bonus de bienvenue', icon: Symbols.celebration);
    default:
      final label = sourceType.replaceAll('_', ' ');
      return (label: label[0].toUpperCase() + label.substring(1), icon: Symbols.receipt_long);
  }
}

class LoyaltyDashboardScreen extends StatelessWidget {
  final LoyaltyDashboardViewModel viewModel;

  const LoyaltyDashboardScreen({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = context.spacing;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        title: Text(
          'MES POINTS',
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w900,
            letterSpacing: 1.5,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => Navigator.pop(context),
          color: theme.colorScheme.onSurface,
        ),
      ),
      body: AnimatedBuilder(
        animation: viewModel,
        builder: (context, _) {
          if (viewModel.isLoading && viewModel.currentPoints == 0 && viewModel.recentTransactions.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          if (viewModel.errorMessage != null && viewModel.currentPoints == 0 && viewModel.recentTransactions.isEmpty) {
            return _buildErrorState(context, theme, spacing);
          }

          final points = viewModel.currentPoints;
          final currentTier = viewModel.currentTier;
          final nextTier = viewModel.nextTier;
          final pointsToNext = viewModel.pointsToNextTier;
          final progress = viewModel.progressToNextTier;

          return RefreshIndicator(
            onRefresh: () => viewModel.loadBalance(),
            color: theme.colorScheme.primary,
            child: CustomScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: [
                SliverPadding(
                  padding: EdgeInsets.all(spacing.lg),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      _buildPointsCard(context, theme, spacing, points, currentTier),
                      SizedBox(height: spacing.lg),
                      if (nextTier != null)
                        _buildProgressSection(context, theme, spacing, progress, pointsToNext, nextTier)
                      else
                        _buildMaxTierMessage(context, theme, spacing),
                      SizedBox(height: spacing.xl),
                      _buildSectionTitle(theme, 'HISTORIQUE DES POINTS'),
                      SizedBox(height: spacing.md),
                    ]),
                  ),
                ),
                if (viewModel.recentTransactions.isEmpty)
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: _buildEmptyState(context, theme, spacing),
                  )
                else
                  SliverPadding(
                    padding: EdgeInsets.symmetric(horizontal: spacing.md),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final tx = viewModel.recentTransactions[index];
                          return _buildTransactionItem(context, theme, spacing, tx);
                        },
                        childCount: viewModel.recentTransactions.length,
                      ),
                    ),
                  ),
                SliverToBoxAdapter(child: SizedBox(height: spacing.xxl)),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildPointsCard(BuildContext context, ThemeData theme, AppSpacing spacing, int points, MemberTier tier) {
    final formattedPoints = NumberFormat('#,###').format(points).replaceAll(',', ' ');

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(spacing.lg),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            theme.colorScheme.primary.withValues(alpha: 0.15),
            theme.colorScheme.primary.withValues(alpha: 0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: theme.colorScheme.primary.withValues(alpha: 0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: spacing.sm, vertical: spacing.xxs),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  tier.label.toUpperCase(),
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.0,
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.all(spacing.sm),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(Symbols.stars, color: theme.colorScheme.primary, size: 24),
              ),
            ],
          ),
          SizedBox(height: spacing.xl),
          Text(
            'SOLDE DE POINTS',
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.5,
            ),
          ),
          SizedBox(height: spacing.xs),
          Text(
            formattedPoints,
            style: theme.textTheme.displaySmall?.copyWith(
              fontWeight: FontWeight.w900,
              color: theme.colorScheme.onSurface,
              letterSpacing: 1.0,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressSection(BuildContext context, ThemeData theme, AppSpacing spacing, double progress, int pointsToNext, MemberTier nextTier) {
    final appColors = theme.extension<AppColors>()!;
    final formattedPoints = NumberFormat('#,###').format(pointsToNext);

    return Container(
      padding: EdgeInsets.all(spacing.md),
      decoration: BoxDecoration(
        color: appColors.bgElevated,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: appColors.bgBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Prochain palier : ${nextTier.label}',
                style: theme.textTheme.labelMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              Text(
                '$formattedPoints pts',
                style: theme.textTheme.labelMedium?.copyWith(
                  fontWeight: FontWeight.w900,
                  color: theme.colorScheme.primary,
                ),
              ),
            ],
          ),
          SizedBox(height: spacing.sm),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: theme.colorScheme.surfaceContainerHighest,
              valueColor: AlwaysStoppedAnimation(theme.colorScheme.primary),
              minHeight: 8,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMaxTierMessage(BuildContext context, ThemeData theme, AppSpacing spacing) {
    return Container(
      padding: EdgeInsets.all(spacing.md),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.colorScheme.primary.withValues(alpha: 0.15)),
      ),
      child: Row(
        children: [
          Icon(Symbols.workspace_premium, color: theme.colorScheme.primary, size: 20),
          SizedBox(width: spacing.sm),
          Text(
            'Niveau maximum atteint',
            style: theme.textTheme.labelLarge?.copyWith(
              fontWeight: FontWeight.w700,
              color: theme.colorScheme.primary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(ThemeData theme, String title) {
    return Text(
      title.toUpperCase(),
      style: theme.textTheme.labelSmall?.copyWith(
        color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
        fontWeight: FontWeight.bold,
        letterSpacing: 1.5,
      ),
    );
  }

  Widget _buildTransactionItem(BuildContext context, ThemeData theme, AppSpacing spacing, LoyaltyTransaction tx) {
    final appColors = theme.extension<AppColors>()!;
    final sourceType = tx.description ?? '';
    final mapped = _mapSourceType(sourceType);
    final isPositive = tx.points >= 0;
    final sign = isPositive ? '+' : '';

    return Container(
      margin: EdgeInsets.only(bottom: spacing.sm),
      padding: EdgeInsets.all(spacing.md),
      decoration: BoxDecoration(
        color: appColors.bgSurface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: appColors.bgBorder),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: isPositive
                  ? Colors.green.withValues(alpha: 0.1)
                  : Colors.red.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(mapped.icon, color: isPositive ? Colors.green.shade600 : Colors.red.shade600, size: 22),
          ),
          SizedBox(width: spacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  mapped.label,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                if (tx.createdAt != null) ...[
                  SizedBox(height: spacing.xxs),
                  Text(
                    _formatDate(tx.createdAt!),
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
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
              color: isPositive ? Colors.green.shade600 : Colors.red.shade600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, ThemeData theme, AppSpacing spacing) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: spacing.xxl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(spacing.lg),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withValues(alpha: 0.05),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Symbols.receipt_long,
                size: 56,
                color: theme.colorScheme.primary.withValues(alpha: 0.5),
              ),
            ),
            SizedBox(height: spacing.lg),
            Text(
              'Aucune transaction',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w900,
                color: theme.colorScheme.onSurface,
              ),
            ),
            SizedBox(height: spacing.sm),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: spacing.xl),
              child: Text(
                'Vos transactions de points apparaîtront ici.',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, ThemeData theme, AppSpacing spacing) {
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
              child: Icon(Symbols.wifi_off, size: 48, color: theme.colorScheme.error),
            ),
            SizedBox(height: spacing.lg),
            Text(
              'Chargement échoué',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w900,
                color: theme.colorScheme.onSurface,
              ),
            ),
            SizedBox(height: spacing.sm),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: spacing.xl),
              child: Text(
                viewModel.errorMessage ?? 'Impossible de charger vos points.',
                style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: spacing.xl),
            FilledButton.icon(
              onPressed: () => viewModel.loadBalance(),
              icon: const Icon(Symbols.refresh, size: 20),
              label: const Text('Réessayer'),
              style: FilledButton.styleFrom(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(String isoString) {
    try {
      return DateFormat('MMM d, yyyy').format(DateTime.parse(isoString));
    } catch (_) {
      return isoString;
    }
  }
}
