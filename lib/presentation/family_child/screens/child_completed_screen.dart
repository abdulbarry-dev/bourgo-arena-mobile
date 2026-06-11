import 'package:bourgo_arena_mobile/core/di/locator.dart';
import 'package:bourgo_arena_mobile/core/theme/bourgo_theme.dart';
import 'package:bourgo_arena_mobile/domain/entities/completed_item.dart';
import 'package:bourgo_arena_mobile/domain/usecases/family/get_child_completed_items_use_case.dart';
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
          appBar: SubScreenAppBar(title: 'COMPLETED'),
          body: _viewModel.isLoading
              ? const Center(child: CircularProgressIndicator())
              : RefreshIndicator(
                  onRefresh: () => _viewModel.load(widget.childId),
                  color: theme.colorScheme.primary,
                  child: _viewModel.items.isEmpty
                      ? _buildEmptyState(theme, spacing)
                      : ListView.builder(
                          physics: const AlwaysScrollableScrollPhysics(),
                          padding: EdgeInsets.all(spacing.lg),
                          itemCount: _viewModel.items.length,
                          itemBuilder: (context, index) {
                            final item = _viewModel.items[index];
                            return Padding(
                              padding: EdgeInsets.only(bottom: spacing.md),
                              child: _CompletedCard(
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

  Widget _buildEmptyState(ThemeData theme, AppSpacing spacing) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: spacing.xxl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Symbols.check_circle, size: 64,
              color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.3)),
            SizedBox(height: spacing.lg),
            Text('No completed items',
              style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900)),
          ],
        ),
      ),
    );
  }
}

class _CompletedCard extends StatelessWidget {
  final CompletedItem item;
  final int index;
  final ThemeData theme;
  final AppSpacing spacing;

  const _CompletedCard({
    required this.item, required this.index, required this.theme, required this.spacing,
  });

  @override
  Widget build(BuildContext context) {
    final isActivity = item.type == CompletedItemType.activity;
    final color = isActivity ? const Color(0xFF8B5CF6) : theme.colorScheme.primary;

    return Container(
      padding: EdgeInsets.all(spacing.lg),
      decoration: BoxDecoration(
        color: theme.extension<AppColors>()!.bgElevated,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.extension<AppColors>()!.bgBorder),
      ),
      child: Row(
        children: [
          Container(
            width: 48, height: 48,
            decoration: BoxDecoration(
              color: const Color(0xFF22C55E).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Icon(Symbols.check_circle, color: const Color(0xFF22C55E), size: 24),
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
                      padding: EdgeInsets.symmetric(horizontal: spacing.xs, vertical: 2),
                      decoration: BoxDecoration(
                        color: color.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(item.typeLabel.toUpperCase(),
                        style: theme.textTheme.labelSmall?.copyWith(
                          fontWeight: FontWeight.w900, color: color, fontSize: 9,
                        )),
                    ),
                    const Spacer(),
                    Text(item.date,
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant)),
                  ],
                ),
                SizedBox(height: spacing.xs),
                Text(item.name,
                  style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800)),
                SizedBox(height: spacing.xxs),
                Row(
                  children: [
                    Icon(Symbols.check_circle, size: 12, color: const Color(0xFF22C55E)),
                    SizedBox(width: spacing.xxs),
                    Text('Completed: ${item.completedAt}',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    ).animate(delay: (index * 50).ms).fade(duration: 300.ms).slideX(begin: -0.02, end: 0);
  }
}
