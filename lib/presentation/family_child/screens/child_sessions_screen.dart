import 'package:bourgo_arena_mobile/core/di/locator.dart';
import 'package:bourgo_arena_mobile/core/theme/bourgo_theme.dart';
import 'package:bourgo_arena_mobile/domain/entities/course.dart';
import 'package:bourgo_arena_mobile/domain/usecases/family/book_child_session_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/family/get_child_available_sessions_use_case.dart';
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
      getChildAvailableSessionsUseCase: locator<GetChildAvailableSessionsUseCase>(),
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
              title: Text('Book Session'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(session.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text('Day: $dayName'),
                  Text('Time: ${session.startTime} - ${session.endTime}'),
                  Text('Spots: ${session.remainingSpots}/${session.capacity}'),
                  if (session.isFull) ...[
                    const SizedBox(height: 8),
                    Text('Session is full', style: TextStyle(color: Theme.of(context).colorScheme.error)),
                  ],
                  const SizedBox(height: 16),
                  if (!session.isFull)
                    TextButton(
                      onPressed: () async {
                        final date = await showDatePicker(
                          context: context,
                          initialDate: selectedDate,
                          firstDate: DateTime.now(),
                          lastDate: DateTime.now().add(const Duration(days: 30)),
                        );
                        if (date != null) {
                          setDialogState(() => selectedDate = date);
                        }
                      },
                      child: Text(
                        'Date: ${selectedDate.day}/${selectedDate.month}/${selectedDate.year}',
                      ),
                    ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(dialogContext),
                  child: const Text('Cancel'),
                ),
                if (!session.isFull)
                  ElevatedButton(
                    onPressed: () async {
                      Navigator.pop(dialogContext);
                      final dateStr =
                          '${selectedDate.year}-${selectedDate.month.toString().padLeft(2, '0')}-${selectedDate.day.toString().padLeft(2, '0')}';
                      final booking = await _viewModel.bookSession(
                        childId: widget.childId,
                        sessionId: session.id,
                        date: dateStr,
                      );
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              booking != null
                                  ? 'Successfully booked!'
                                  : _viewModel.errorMessage ?? 'Failed to book',
                            ),
                            backgroundColor: booking != null ? Colors.green : Theme.of(context).colorScheme.error,
                          ),
                        );
                        if (booking != null) _viewModel.load(widget.childId);
                      }
                    },
                    child: const Text('Confirm Booking'),
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
          appBar: SubScreenAppBar(title: 'AVAILABLE SESSIONS'),
          body: _viewModel.isLoading
              ? const Center(child: CircularProgressIndicator())
              : RefreshIndicator(
                  onRefresh: () => _viewModel.load(widget.childId),
                  color: theme.colorScheme.primary,
                  child: _viewModel.sessions.isEmpty
                      ? _buildEmptyState(theme, spacing)
                      : ListView.builder(
                          controller: _scrollController,
                          physics: const AlwaysScrollableScrollPhysics(),
                          padding: EdgeInsets.all(spacing.lg),
                          itemCount: _viewModel.sessions.length + (_viewModel.isLoadingMore ? 1 : 0),
                          itemBuilder: (context, index) {
                            if (index == _viewModel.sessions.length) {
                              return const Padding(
                                padding: EdgeInsets.all(16),
                                child: Center(child: CircularProgressIndicator()),
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
                                onBook: session.isBooked ? null : () => _bookSession(session),
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
            Icon(Symbols.sports_kabaddi, size: 64,
              color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.3)),
            SizedBox(height: spacing.lg),
            Text('No sessions available',
              style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900)),
          ],
        ),
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
    required this.session, required this.index, required this.theme,
    required this.spacing, required this.appColors, this.onBook,
  });

  @override
  Widget build(BuildContext context) {
    final dayNames = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    final dayName = session.dayOfWeek >= 1 && session.dayOfWeek <= 7
        ? dayNames[session.dayOfWeek - 1]
        : '';

    return Container(
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
                    Text(session.title,
                      style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800)),
                    if (session.isBooked) ...[
                      SizedBox(width: spacing.sm),
                      Icon(Symbols.check_circle, size: 16, color: appColors.statusSuccess),
                    ],
                  ],
                ),
                SizedBox(height: spacing.xs),
                Row(
                  children: [
                    Icon(Symbols.calendar_today, size: 12, color: theme.colorScheme.onSurfaceVariant),
                    SizedBox(width: spacing.xxs),
                    Text(dayName,
                      style: theme.textTheme.labelSmall?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
                    SizedBox(width: spacing.md),
                    Icon(Symbols.schedule, size: 12, color: theme.colorScheme.onSurfaceVariant),
                    SizedBox(width: spacing.xxs),
                    Text('${session.startTime} - ${session.endTime}',
                      style: theme.textTheme.labelSmall?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
                  ],
                ),
                SizedBox(height: spacing.xs),
                Row(
                  children: [
                    Icon(Symbols.group, size: 12, color: theme.colorScheme.onSurfaceVariant),
                    SizedBox(width: spacing.xxs),
                    Text('${session.enrolled}/${session.capacity}',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: session.isFull ? theme.colorScheme.error : theme.colorScheme.onSurfaceVariant,
                        fontWeight: session.isFull ? FontWeight.w700 : FontWeight.normal,
                      )),
                    if (session.isFull) ...[
                      SizedBox(width: spacing.sm),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: spacing.xs, vertical: 2),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.error.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text('FULL', style: theme.textTheme.labelSmall?.copyWith(
                            fontWeight: FontWeight.w900, color: theme.colorScheme.error, fontSize: 9,
                        )),
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
              tooltip: 'Book session',
            ),
        ],
      ),
    ).animate(delay: (index * 50).ms).fade(duration: 300.ms).slideX(begin: -0.02, end: 0);
  }
}
