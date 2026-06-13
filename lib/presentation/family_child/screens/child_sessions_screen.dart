import 'package:bourgo_arena_mobile/l10n/app_localizations.dart';
import 'package:bourgo_arena_mobile/core/di/locator.dart';
import 'package:bourgo_arena_mobile/core/theme/bourgo_theme.dart';
import 'package:bourgo_arena_mobile/core/utils/haptic_utils.dart';
import 'package:bourgo_arena_mobile/domain/entities/course.dart';
import 'package:bourgo_arena_mobile/domain/usecases/family/book_child_session_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/family/get_child_available_sessions_use_case.dart';
import 'package:bourgo_arena_mobile/presentation/common/widgets/app_shimmer.dart';
import 'package:bourgo_arena_mobile/presentation/common/widgets/pressable_card.dart';
import 'package:bourgo_arena_mobile/presentation/common/widgets/sub_screen_app_bar.dart';
import 'package:bourgo_arena_mobile/presentation/family_child/viewmodels/child_sessions_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:material_symbols_icons/symbols.dart';

class ChildSessionsScreen extends StatefulWidget {
  final String childId;

  const ChildSessionsScreen({super.key, required this.childId});

  @override
  State<ChildSessionsScreen> createState() => _ChildSessionsScreenState();
}

class _ChildSessionsScreenState extends State<ChildSessionsScreen> {
  late final ChildSessionsViewModel _viewModel;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _viewModel = ChildSessionsViewModel(
      getChildAvailableSessionsUseCase:
          locator<GetChildAvailableSessionsUseCase>(),
      bookChildSessionUseCase: locator<BookChildSessionUseCase>(),
    );
    _viewModel.load(widget.childId);
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _viewModel.dispose();
    super.dispose();
  }

  void _onScroll() {
    final position = _scrollController.position;
    if (position.maxScrollExtent <= 0 || position.pixels <= 0) return;
    if (position.pixels >= position.maxScrollExtent - 200) {
      _viewModel.loadMore();
    }
  }

  void _bookSession(CourseSession session) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        DateTime selectedDate = DateTime.now();
        final dayNames = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
        final dayName = session.dayOfWeek >= 1 && session.dayOfWeek <= 7
            ? dayNames[session.dayOfWeek - 1]
            : '';

        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: Text(
                AppLocalizations.of(context)!.familyChildSessionsBookTitle,
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    session.title,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${AppLocalizations.of(context)!.familyChildSessionsBookDay} $dayName',
                  ),
                  Text(
                    '${AppLocalizations.of(context)!.familyChildSessionsBookTime} ${session.startTime} - ${session.endTime}',
                  ),
                  Text(
                    '${AppLocalizations.of(context)!.familyChildSessionsBookSpots} ${session.remainingSpots}/${session.capacity}',
                  ),
                  if (session.isFull) ...[
                    const SizedBox(height: 8),
                    Text(
                      AppLocalizations.of(context)!.familyChildSessionsBookFull,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.error,
                      ),
                    ),
                  ],
                  const SizedBox(height: 16),
                  if (!session.isFull)
                    TextButton(
                      onPressed: () async {
                        final date = await showDatePicker(
                          context: context,
                          initialDate: selectedDate,
                          firstDate: DateTime.now(),
                          lastDate: DateTime.now().add(
                            const Duration(days: 30),
                          ),
                        );
                        if (date != null) {
                          setDialogState(() => selectedDate = date);
                        }
                      },
                      child: Text(
                        '${AppLocalizations.of(context)!.familyChildSessionsBookDate} ${selectedDate.day}/${selectedDate.month}/${selectedDate.year}',
                      ),
                    ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    AppHaptics.light();
                    Navigator.pop(dialogContext);
                  },
                  child: Text(
                    AppLocalizations.of(context)!.familyChildSessionsBookCancel,
                  ),
                ),
                if (!session.isFull)
                  ElevatedButton(
                    onPressed: () async {
                      AppHaptics.light();
                      Navigator.pop(dialogContext);
                      final theme = Theme.of(this.context);
                      final appColors = theme.extension<AppColors>()!;
                      final messenger = ScaffoldMessenger.of(this.context);
                      final dateStr =
                          '${selectedDate.year}-${selectedDate.month.toString().padLeft(2, '0')}-${selectedDate.day.toString().padLeft(2, '0')}';
                      final booking = await _viewModel.bookSession(
                        childId: widget.childId,
                        sessionId: session.id,
                        date: dateStr,
                      );
                      if (mounted) {
                        if (booking != null) {
                          AppHaptics.success();
                        } else {
                          AppHaptics.error();
                        }
                        messenger
                          ..hideCurrentSnackBar()
                          ..showSnackBar(
                            SnackBar(
                              content: Text(
                                booking != null
                                    ? AppLocalizations.of(
                                        context,
                                      )!.familyChildSessionsBookSuccess
                                    : _viewModel.errorMessage ??
                                          AppLocalizations.of(
                                            context,
                                          )!.familyChildSessionsBookFailure,
                              ),
                              backgroundColor: booking != null
                                  ? appColors.statusSuccess
                                  : theme.colorScheme.error,
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                        if (booking != null) _viewModel.load(widget.childId);
                      }
                    },
                    child: Text(
                      AppLocalizations.of(
                        context,
                      )!.familyChildSessionsBookConfirm,
                    ),
                  ),
              ],
            );
          },
        );
      },
    );
  }

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
          appBar: SubScreenAppBar(
            title: AppLocalizations.of(context)!.familyChildSessionsTitle,
          ),
          body: _viewModel.isLoading
              ? _buildLoadingState(theme, spacing)
              : RefreshIndicator(
                  onRefresh: () => _viewModel.load(widget.childId),
                  color: theme.colorScheme.primary,
                  child: _viewModel.sessions.isEmpty
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
                          controller: _scrollController,
                          physics: const AlwaysScrollableScrollPhysics(),
                          padding: EdgeInsets.all(spacing.lg),
                          itemCount:
                              _viewModel.sessions.length +
                              (_viewModel.isLoadingMore ? 1 : 0),
                          itemBuilder: (context, index) {
                            if (index == _viewModel.sessions.length) {
                              return const Padding(
                                padding: EdgeInsets.all(16),
                                child: Center(
                                  child: CircularProgressIndicator(),
                                ),
                              );
                            }
                            final session = _viewModel.sessions[index];
                            return Padding(
                              padding: EdgeInsets.only(bottom: spacing.md),
                              child: _SessionCard(
                                session: session,
                                index: index,
                                theme: theme,
                                spacing: spacing,
                                appColors: appColors,
                                onBook: session.isBooked
                                    ? null
                                    : () => _bookSession(session),
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
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    AppShimmer.block(width: 44, height: 44, borderRadius: 12),
                    SizedBox(width: spacing.lg),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AppShimmer.block(width: 150, height: 16),
                          SizedBox(height: spacing.sm),
                          AppShimmer.block(width: 100, height: 12),
                        ],
                      ),
                    ),
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
                  Symbols.sports_kabaddi,
                  size: 56,
                  color: theme.colorScheme.primary,
                ),
              )
              .animate()
              .scale(duration: 400.ms, curve: Curves.easeOutBack)
              .fade(duration: 400.ms),
          SizedBox(height: spacing.xl),
          Text(
                AppLocalizations.of(context)!.familyChildSessionsEmptyTitle,
                textAlign: TextAlign.center,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w900,
                ),
              )
              .animate(delay: 100.ms)
              .fade(duration: 400.ms)
              .slideY(begin: 0.15, end: 0, curve: Curves.easeOutQuad),
        ],
      ),
    );
  }
}

class _SessionCard extends StatelessWidget {
  final CourseSession session;
  final int index;
  final ThemeData theme;
  final AppSpacing spacing;
  final AppColors appColors;
  final VoidCallback? onBook;

  const _SessionCard({
    required this.session,
    required this.index,
    required this.theme,
    required this.spacing,
    required this.appColors,
    this.onBook,
  });

  @override
  Widget build(BuildContext context) {
    final dayNames = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    final dayName = session.dayOfWeek >= 1 && session.dayOfWeek <= 7
        ? dayNames[session.dayOfWeek - 1]
        : '';

    final card = Container(
      padding: EdgeInsets.all(spacing.lg),
      decoration: BoxDecoration(
        color: appColors.bgElevated,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: appColors.bgBorder),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      session.title,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    if (session.isBooked) ...[
                      SizedBox(width: spacing.sm),
                      Semantics(
                        label: AppLocalizations.of(
                          context,
                        )!.familyChildSessionsStatusBooked,
                        child: Icon(
                          Symbols.check_circle,
                          size: 16,
                          color: appColors.statusSuccess,
                        ),
                      ),
                    ],
                  ],
                ),
                SizedBox(height: spacing.xs),
                Row(
                  children: [
                    Icon(
                      Symbols.calendar_today,
                      size: 12,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                    SizedBox(width: spacing.xxs),
                    Text(
                      dayName,
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    SizedBox(width: spacing.md),
                    Icon(
                      Symbols.schedule,
                      size: 12,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                    SizedBox(width: spacing.xxs),
                    Text(
                      '${session.startTime} - ${session.endTime}',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: spacing.xs),
                Row(
                  children: [
                    Icon(
                      Symbols.group,
                      size: 12,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                    SizedBox(width: spacing.xxs),
                    Text(
                      '${session.enrolled}/${session.capacity}',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: session.isFull
                            ? appColors.statusError
                            : theme.colorScheme.onSurfaceVariant,
                        fontWeight: session.isFull
                            ? FontWeight.w700
                            : FontWeight.normal,
                      ),
                    ),
                    if (session.isFull) ...[
                      SizedBox(width: spacing.sm),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: spacing.xs,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: appColors.statusError.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          AppLocalizations.of(
                            context,
                          )!.familyChildSessionsStatusFull,
                          style: theme.textTheme.labelSmall?.copyWith(
                            fontWeight: FontWeight.w900,
                            color: appColors.statusError,
                            fontSize: 9,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
          if (onBook != null)
            IconButton(
              onPressed: onBook,
              icon: Icon(Symbols.add_circle, color: theme.colorScheme.primary),
              tooltip: AppLocalizations.of(
                context,
              )!.familyChildSessionsBookTooltip,
            ),
        ],
      ),
    );

    final content = onBook != null
        ? PressableCard(
            borderRadius: BorderRadius.circular(16),
            onTap: onBook,
            child: card,
          )
        : card;

    return content
        .animate(delay: (index.clamp(0, 8) * 50).ms)
        .fadeIn(duration: 350.ms)
        .slideY(begin: 0.08, end: 0, curve: Curves.easeOutCubic);
  }
}
