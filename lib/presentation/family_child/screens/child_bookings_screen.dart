import 'package:bourgo_arena_mobile/core/di/locator.dart';
import 'package:bourgo_arena_mobile/core/theme/bourgo_theme.dart';
import 'package:bourgo_arena_mobile/domain/entities/child_booking.dart';
import 'package:bourgo_arena_mobile/domain/usecases/family/complete_child_booking_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/family/get_child_bookings_use_case.dart';
import 'package:bourgo_arena_mobile/presentation/common/widgets/sub_screen_app_bar.dart';
import 'package:bourgo_arena_mobile/presentation/family_child/viewmodels/child_bookings_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:material_symbols_icons/symbols.dart';

class ChildBookingsScreen extends StatefulWidget {
  final String childId;

  const ChildBookingsScreen({super.key, required this.childId});

  @override
  State<ChildBookingsScreen> createState() => _ChildBookingsScreenState();
}

class _ChildBookingsScreenState extends State<ChildBookingsScreen> {
  late final ChildBookingsViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = ChildBookingsViewModel(
      getChildBookingsUseCase: locator<GetChildBookingsUseCase>(),
      completeChildBookingUseCase: locator<CompleteChildBookingUseCase>(),
    );
    _viewModel.load(childId: widget.childId);
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
        return Scaffold(
          backgroundColor: theme.scaffoldBackgroundColor,
          appBar: SubScreenAppBar(title: 'BOOKINGS'),
          body: _viewModel.isLoading
              ? const Center(child: CircularProgressIndicator())
              : RefreshIndicator(
                  onRefresh: () => _viewModel.load(childId: widget.childId, filter: _viewModel.filter),
                  color: theme.colorScheme.primary,
                  child: CustomScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    slivers: [
                      SliverToBoxAdapter(
                        child: _buildFilterTabs(context, theme, spacing, appColors),
                      ),
                      if (_viewModel.bookings.isEmpty)
                        SliverFillRemaining(child: _buildEmptyState(theme, spacing, appColors))
                      else
                        SliverPadding(
                          padding: EdgeInsets.all(spacing.lg),
                          sliver: SliverList(
                            delegate: SliverChildBuilderDelegate(
                              (context, index) {
                                final booking = _viewModel.bookings[index];
                                return Padding(
                                  padding: EdgeInsets.only(bottom: spacing.md),
                                  child: _BookingCard(
                                    booking: booking,
                                    index: index,
                                    theme: theme,
                                    spacing: spacing,
                                    appColors: appColors,
                                    onComplete: booking.status == 'confirmed' && !booking.isCompleted
                                        ? () => _markComplete(booking.id)
                                        : null,
                                  ),
                                );
                              },
                              childCount: _viewModel.bookings.length,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
        );
      },
    );
  }

  Widget _buildFilterTabs(BuildContext context, ThemeData theme, AppSpacing spacing, AppColors appColors) {
    final filters = ['all', 'upcoming', 'past'];
    return Padding(
      padding: EdgeInsets.fromLTRB(spacing.lg, spacing.lg, spacing.lg, 0),
      child: Row(
        children: filters.map((f) {
          final isSelected = _viewModel.filter == f;
          return Padding(
            padding: EdgeInsets.only(right: spacing.sm),
            child: GestureDetector(
              onTap: () => _viewModel.load(childId: widget.childId, filter: f),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: spacing.md, vertical: spacing.sm),
                decoration: BoxDecoration(
                  color: isSelected ? theme.colorScheme.primary : appColors.bgElevated,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSelected ? theme.colorScheme.primary : appColors.bgBorder,
                  ),
                ),
                child: Text(
                  f.toUpperCase(),
                  style: theme.textTheme.labelMedium?.copyWith(
                    fontWeight: FontWeight.w900,
                    color: isSelected ? theme.colorScheme.onPrimary : theme.colorScheme.onSurfaceVariant,
                    letterSpacing: 1.0,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  void _markComplete(String bookingId) async {
    final success = await _viewModel.markComplete(
      childId: widget.childId,
      bookingId: bookingId,
    );
    if (mounted) {
      final t = Theme.of(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(success ? 'Booking marked as completed' : 'Failed to complete booking'),
          backgroundColor: success ? Colors.green : t.colorScheme.error,
        ),
      );
    }
  }

  Widget _buildEmptyState(ThemeData theme, AppSpacing spacing, AppColors appColors) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: spacing.xxl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Symbols.event_busy, size: 64,
              color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.3)),
            SizedBox(height: spacing.lg),
            Text('No bookings', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900)),
          ],
        ),
      ),
    );
  }
}

class _BookingCard extends StatelessWidget {
  final ChildBooking booking;
  final int index;
  final ThemeData theme;
  final AppSpacing spacing;
  final AppColors appColors;
  final VoidCallback? onComplete;

  const _BookingCard({
    required this.booking, required this.index, required this.theme,
    required this.spacing, required this.appColors, this.onComplete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(spacing.lg),
      decoration: BoxDecoration(
        color: appColors.bgElevated,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: appColors.bgBorder),
      ),
      child: Row(
        children: [
          Container(
            width: 48, height: 48,
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: booking.isCompleted
                  ? Icon(Symbols.check_circle, color: const Color(0xFF22C55E), size: 24)
                  : Icon(Symbols.event, color: theme.colorScheme.primary, size: 24),
            ),
          ),
          SizedBox(width: spacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(booking.courseName,
                  style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800)),
                SizedBox(height: spacing.xxs),
                Row(
                  children: [
                    Icon(Symbols.calendar_today, size: 12, color: theme.colorScheme.onSurfaceVariant),
                    SizedBox(width: spacing.xxs),
                    Text(booking.date,
                      style: theme.textTheme.labelSmall?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
                    SizedBox(width: spacing.sm),
                    Icon(Symbols.schedule, size: 12, color: theme.colorScheme.onSurfaceVariant),
                    SizedBox(width: spacing.xxs),
                    Text('${booking.startTime} - ${booking.endTime}',
                      style: theme.textTheme.labelSmall?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
                  ],
                ),
              ],
            ),
          ),
          if (onComplete != null)
            IconButton(
              onPressed: onComplete,
              icon: Icon(Symbols.check_circle_outline, color: theme.colorScheme.primary),
              tooltip: 'Mark completed',
            ),
        ],
      ),
    ).animate(delay: (index * 50).ms).fade(duration: 300.ms).slideX(begin: -0.02, end: 0);
  }
}
