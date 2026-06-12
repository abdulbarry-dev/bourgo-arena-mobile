import 'package:bourgo_arena_mobile/core/di/locator.dart';
import 'package:bourgo_arena_mobile/core/theme/bourgo_theme.dart';
import 'package:bourgo_arena_mobile/core/utils/haptic_utils.dart';
import 'package:bourgo_arena_mobile/domain/entities/schedule_item.dart';
import 'package:bourgo_arena_mobile/domain/usecases/family/get_child_schedule_use_case.dart';
import 'package:bourgo_arena_mobile/presentation/common/widgets/app_shimmer.dart';
import 'package:bourgo_arena_mobile/presentation/common/widgets/sub_screen_app_bar.dart';
import 'package:bourgo_arena_mobile/presentation/family_child/viewmodels/child_schedule_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:material_symbols_icons/symbols.dart';

class ChildScheduleScreen extends StatefulWidget {
  final String childId;

  const ChildScheduleScreen({super.key, required this.childId});

  @override
  State<ChildScheduleScreen> createState() => _ChildScheduleScreenState();
}

class _ChildScheduleScreenState extends State<ChildScheduleScreen> {
  late final ChildScheduleViewModel _viewModel;
  late DateTime _from;
  late DateTime _to;

  @override
  void initState() {
    super.initState();
    _viewModel = ChildScheduleViewModel(
      getChildScheduleUseCase: locator<GetChildScheduleUseCase>(),
    );
    _from = DateTime.now();
    _to = _from.add(const Duration(days: 7));
    _load();
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  void _load() {
    _viewModel.load(
      childId: widget.childId,
      from: _toIsoDate(_from),
      to: _toIsoDate(_to),
    );
  }

  String _toIsoDate(DateTime date) =>
      '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = context.spacing;
    final appColors = theme.extension<AppColors>()!;

    return ListenableBuilder(
      listenable: _viewModel,
      builder: (context, _) {
        return Scaffold(
          backgroundColor: theme.scaffoldBackgroundColor,
          appBar: SubScreenAppBar(title: 'SCHEDULE'),
          body: _viewModel.isLoading
              ? _buildLoadingState(theme, spacing)
              : RefreshIndicator(
                  onRefresh: () async => _load(),
                  color: theme.colorScheme.primary,
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: EdgeInsets.all(spacing.lg),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildDateRangePicker(theme, spacing, appColors)
                            .animate()
                            .fadeIn(duration: 400.ms)
                            .slideY(
                              begin: 0.1,
                              end: 0,
                              curve: Curves.easeOutQuad,
                            ),
                        SizedBox(height: spacing.xl),
                        if (_viewModel.items.isEmpty)
                          _buildEmptyState(theme, spacing)
                        else
                          ..._viewModel.items.asMap().entries.map((entry) {
                            return Padding(
                              padding: EdgeInsets.only(bottom: spacing.md),
                              child: _ScheduleItemCard(
                                item: entry.value,
                                index: entry.key,
                                theme: theme,
                                spacing: spacing,
                                appColors: appColors,
                              ),
                            );
                          }),
                      ],
                    ),
                  ),
                ),
        );
      },
    );
  }

  Widget _buildDateRangePicker(ThemeData theme, AppSpacing spacing, AppColors appColors) {
    return Container(
      padding: EdgeInsets.all(spacing.md),
      decoration: BoxDecoration(
        color: appColors.bgElevated,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: appColors.bgBorder),
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () {
                AppHaptics.selection();
                _pickDate(true);
              },
              child: _DateChip(label: 'FROM', date: _toIsoDate(_from), theme: theme, spacing: spacing),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: spacing.sm),
            child: Icon(Symbols.arrow_forward, size: 16, color: theme.colorScheme.onSurfaceVariant),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () {
                AppHaptics.selection();
                _pickDate(false);
              },
              child: _DateChip(label: 'TO', date: _toIsoDate(_to), theme: theme, spacing: spacing),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _pickDate(bool isFrom) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: isFrom ? _from : _to,
      firstDate: DateTime.now().subtract(const Duration(days: 30)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      setState(() {
        if (isFrom) {
          _from = picked;
          if (_to.isBefore(_from)) _to = _from.add(const Duration(days: 7));
        } else {
          _to = picked;
          if (_from.isAfter(_to)) _from = _to.subtract(const Duration(days: 7));
        }
      });
      _load();
    }
  }

  Widget _buildLoadingState(ThemeData theme, AppSpacing spacing) {
    return AppShimmer(
      child: Padding(
        padding: EdgeInsets.all(spacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              height: 64,
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest
                    .withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            SizedBox(height: spacing.xl),
            ...List.generate(
              5,
              (_) => Padding(
                padding: EdgeInsets.only(bottom: spacing.md),
                child: Container(
                  padding: EdgeInsets.all(spacing.lg),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surfaceContainerHighest
                        .withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      AppShimmer.block(width: 4, height: 56, borderRadius: 2),
                      SizedBox(width: spacing.md),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AppShimmer.block(width: 70, height: 14),
                            SizedBox(height: spacing.sm),
                            AppShimmer.block(width: 150, height: 16),
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
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(ThemeData theme, AppSpacing spacing) {
    return Center(
      child: Padding(
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
                Symbols.schedule,
                size: 56,
                color: theme.colorScheme.primary,
              ),
            ),
            SizedBox(height: spacing.xl),
            Text('No events scheduled',
              textAlign: TextAlign.center,
              style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900)),
            SizedBox(height: spacing.sm),
            Text('No courses or activities in this date range.',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 300.ms).slideY(
          begin: 0.08,
          end: 0,
          curve: Curves.easeOutQuad,
        );
  }
}

class _DateChip extends StatelessWidget {
  final String label;
  final String date;
  final ThemeData theme;
  final AppSpacing spacing;

  const _DateChip({required this.label, required this.date, required this.theme, required this.spacing});

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: '$label $date',
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOutCubic,
        padding: EdgeInsets.all(spacing.sm),
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Text(label, style: theme.textTheme.labelSmall?.copyWith(
              fontWeight: FontWeight.w900, letterSpacing: 1.0, color: theme.colorScheme.onSurfaceVariant,
            )),
            SizedBox(height: spacing.xxs),
            Text(date, style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w700)),
          ],
        ),
      ),
    );
  }
}

class _ScheduleItemCard extends StatelessWidget {
  final ScheduleItem item;
  final int index;
  final ThemeData theme;
  final AppSpacing spacing;
  final AppColors appColors;

  const _ScheduleItemCard({
    required this.item,
    required this.index,
    required this.theme,
    required this.spacing,
    required this.appColors,
  });

  @override
  Widget build(BuildContext context) {
    final isActivity = item.type == ScheduleItemType.activity;
    final color = isActivity ? const Color(0xFF8B5CF6) : theme.colorScheme.primary;

    return Container(
      padding: EdgeInsets.all(spacing.lg),
      decoration: BoxDecoration(
        color: appColors.bgElevated,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: appColors.bgBorder),
        gradient: LinearGradient(
          colors: [color.withValues(alpha: 0.05), Colors.transparent],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 56,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(2),
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
                    SizedBox(width: spacing.sm),
                    if (item.isCompleted)
                      Semantics(
                        label: 'Completed',
                        child: Icon(Symbols.check_circle,
                            size: 14, color: appColors.statusSuccess),
                      ),
                    const Spacer(),
                    Text(item.date, style: theme.textTheme.labelSmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    )),
                  ],
                ),
                SizedBox(height: spacing.xs),
                Text(item.name, style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                )),
                SizedBox(height: spacing.xxs),
                Row(
                  children: [
                    Icon(Symbols.schedule, size: 14, color: theme.colorScheme.onSurfaceVariant),
                    SizedBox(width: spacing.xxs),
                    Text('${item.startTime} · ${item.durationMinutes} min',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      )),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    )
        .animate(delay: (index.clamp(0, 8) * 50).ms)
        .fadeIn(duration: 350.ms)
        .slideY(begin: 0.08, end: 0, curve: Curves.easeOutCubic);
  }
}
