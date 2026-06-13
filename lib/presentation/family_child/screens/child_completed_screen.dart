import 'package:bourgo_arena_mobile/l10n/app_localizations.dart';
import 'package:bourgo_arena_mobile/core/di/locator.dart';
import 'package:bourgo_arena_mobile/core/theme/bourgo_theme.dart';
import 'package:bourgo_arena_mobile/domain/usecases/family/get_child_completed_items_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/family/get_child_schedule_use_case.dart';
import 'package:bourgo_arena_mobile/presentation/common/widgets/app_shimmer.dart';
import 'package:bourgo_arena_mobile/presentation/common/widgets/pressable_card.dart';
import 'package:bourgo_arena_mobile/presentation/common/widgets/sub_screen_app_bar.dart';
import 'package:bourgo_arena_mobile/presentation/family_child/viewmodels/child_completed_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:material_symbols_icons/symbols.dart';

class ChildCompletedScreen extends StatefulWidget {
  final String childId;

  const ChildCompletedScreen({super.key, required this.childId});

  @override
  State<ChildCompletedScreen> createState() => _ChildCompletedScreenState();
}

class _ChildCompletedScreenState extends State<ChildCompletedScreen> {
  late final ChildCompletedViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = ChildCompletedViewModel(
      getChildCompletedItemsUseCase: locator<GetChildCompletedItemsUseCase>(),
      getChildScheduleUseCase: locator<GetChildScheduleUseCase>(),
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

    return ListenableBuilder(
      listenable: _viewModel,
      builder: (context, _) {
        return Scaffold(
          backgroundColor: theme.scaffoldBackgroundColor,
          appBar: SubScreenAppBar(
            title: AppLocalizations.of(context)!.familyChildCompletedTitle,
          ),
          body: _viewModel.isLoading
              ? _buildLoadingState(theme, spacing)
              : RefreshIndicator(
                  onRefresh: () => _viewModel.load(widget.childId),
                  color: theme.colorScheme.primary,
                  child: _viewModel.items.isEmpty
                      ? LayoutBuilder(
                          builder: (context, constraints) {
                            return SingleChildScrollView(
                              physics: const AlwaysScrollableScrollPhysics(),
                              child: ConstrainedBox(
                                constraints: BoxConstraints(
                                  minHeight: constraints.maxHeight,
                                ),
                                child: Center(
                                  child: _buildEmptyState(theme, spacing),
                                ),
                              ),
                            );
                          },
                        )
                      : ListView.builder(
                          physics: const AlwaysScrollableScrollPhysics(),
                          padding: EdgeInsets.all(spacing.lg),
                          itemCount: _viewModel.items.length,
                          itemBuilder: (context, index) {
                            final item = _viewModel.items[index];
                            return Padding(
                              padding: EdgeInsets.only(bottom: spacing.md),
                              child: _ActivityCard(
                                item: item,
                                index: index,
                                theme: theme,
                                spacing: spacing,
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
              child: Row(
                children: [
                  AppShimmer.block(width: 48, height: 48, borderRadius: 12),
                  SizedBox(width: spacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppShimmer.block(width: 160, height: 16),
                        SizedBox(height: spacing.sm),
                        AppShimmer.block(width: 110, height: 12),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(ThemeData theme, AppSpacing spacing) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: spacing.xxl,
        horizontal: spacing.xl,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
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
                  Symbols.check_circle,
                  size: 56,
                  color: theme.colorScheme.primary,
                ),
              )
              .animate()
              .scale(duration: 400.ms, curve: Curves.easeOutBack)
              .fade(duration: 400.ms),
          SizedBox(height: spacing.xl),
          Text(
                AppLocalizations.of(context)!.familyChildCompletedEmptyTitle,
                textAlign: TextAlign.center,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w900,
                ),
              )
              .animate(delay: 100.ms)
              .fade(duration: 400.ms)
              .slideY(begin: 0.15, end: 0, curve: Curves.easeOutQuad),
          SizedBox(height: spacing.md),
          Text(
                AppLocalizations.of(context)!.familyChildCompletedEmptyMessage,
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

class _ActivityCard extends StatelessWidget {
  final ChildActivityItem item;
  final int index;
  final ThemeData theme;
  final AppSpacing spacing;

  const _ActivityCard({
    required this.item,
    required this.index,
    required this.theme,
    required this.spacing,
  });

  @override
  Widget build(BuildContext context) {
    final appColors = theme.extension<AppColors>()!;
    final isUpcoming = item.status == ChildActivityStatus.upcoming;
    final statusColor = isUpcoming
        ? theme.colorScheme.primary
        : appColors.statusSuccess;

    return PressableCard(
          borderRadius: BorderRadius.circular(16),
          onTap: () {},
          child: Container(
            padding: EdgeInsets.all(spacing.lg),
            decoration: BoxDecoration(
              color: appColors.bgElevated,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: appColors.bgBorder),
            ),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Icon(
                      isUpcoming ? Symbols.schedule : Symbols.check_circle,
                      color: statusColor,
                      size: 24,
                    ),
                  ),
                ),
                SizedBox(width: spacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: spacing.xs,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: statusColor.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              item.typeLabel.toUpperCase(),
                              style: theme.textTheme.labelSmall?.copyWith(
                                fontWeight: FontWeight.w900,
                                color: statusColor,
                                fontSize: 9,
                              ),
                            ),
                          ),
                          const Spacer(),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: spacing.xs,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: isUpcoming
                                  ? theme.colorScheme.primary.withValues(
                                      alpha: 0.08,
                                    )
                                  : appColors.statusSuccess.withValues(
                                      alpha: 0.08,
                                    ),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              isUpcoming ? 'UPCOMING' : 'COMPLETED',
                              style: theme.textTheme.labelSmall?.copyWith(
                                fontWeight: FontWeight.w900,
                                color: statusColor,
                                fontSize: 9,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: spacing.xs),
                      Text(
                        item.name,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      SizedBox(height: spacing.xxs),
                      Row(
                        children: [
                          Icon(
                            Symbols.calendar_today,
                            size: 12,
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                          SizedBox(width: spacing.xxs),
                          Text(
                            item.date,
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                          if (item.timeDisplay != null) ...[
                            SizedBox(width: spacing.sm),
                            Icon(
                              Symbols.schedule,
                              size: 12,
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                            SizedBox(width: spacing.xxs),
                            Text(
                              item.timeDisplay!,
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ],
                      ),
                      if (!isUpcoming && item.completedAt != null) ...[
                        SizedBox(height: spacing.xxs),
                        Row(
                          children: [
                            Icon(
                              Symbols.check_circle,
                              size: 12,
                              color: appColors.statusSuccess,
                            ),
                            SizedBox(width: spacing.xxs),
                            Text(
                              '${AppLocalizations.of(context)!.familyChildCompletedAtPrefix} ${item.completedAt}',
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        )
        .animate(delay: (index.clamp(0, 8) * 50).ms)
        .fadeIn(duration: 350.ms)
        .slideY(begin: 0.08, end: 0, curve: Curves.easeOutCubic);
  }
}
