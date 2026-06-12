import 'package:bourgo_arena_mobile/core/di/locator.dart';
import 'package:bourgo_arena_mobile/core/theme/bourgo_theme.dart';
import 'package:bourgo_arena_mobile/core/utils/haptic_utils.dart';
import 'package:bourgo_arena_mobile/domain/entities/child_booking.dart';
import 'package:bourgo_arena_mobile/domain/usecases/family/complete_child_booking_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/family/get_child_bookings_use_case.dart';
import 'package:bourgo_arena_mobile/presentation/common/widgets/app_shimmer.dart';
import 'package:bourgo_arena_mobile/presentation/common/widgets/pressable_card.dart';
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
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _viewModel = ChildBookingsViewModel(
      getChildBookingsUseCase: locator<GetChildBookingsUseCase>(),
      completeChildBookingUseCase: locator<CompleteChildBookingUseCase>(),
    );
    _viewModel.load(childId: widget.childId);
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
              ? _buildLoadingState(theme, spacing)
              : RefreshIndicator(
                  onRefresh: () => _viewModel.load(childId: widget.childId, filter: _viewModel.filter),
                  color: theme.colorScheme.primary,
                  child: CustomScrollView(
                    controller: _scrollController,
                    physics: const AlwaysScrollableScrollPhysics(),
                    slivers: [
                      SliverToBoxAdapter(
                        child: _buildFilterTabs(context, theme, spacing, appColors),
                      ),
                      if (_viewModel.bookings.isEmpty)
                        SliverFillRemaining(child: _buildEmptyState(theme, spacing))
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
                        if (_viewModel.isLoadingMore)
                          const SliverToBoxAdapter(
                            child: Padding(
                              padding: EdgeInsets.all(16),
                              child: Center(child: CircularProgressIndicator()),
                            ),
                          ),
                      ],
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

  Widget _buildFilterTabs(BuildContext context, ThemeData theme, AppSpacing spacing, AppColors appColors) {
    final filters = ['all', 'upcoming', 'past'];
    return Padding(
      padding: EdgeInsets.fromLTRB(spacing.lg, spacing.lg, spacing.lg, 0),
      child: Row(
        children: filters.map((f) {
          final isSelected = _viewModel.filter == f;
          return Padding(
            padding: EdgeInsets.only(right: spacing.sm),
            child: Semantics(
              button: true,
              selected: isSelected,
              label: f,
              child: GestureDetector(
                onTap: () {
                  AppHaptics.selection();
                  _viewModel.load(childId: widget.childId, filter: f);
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeOutCubic,
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
            ),
          );
        }).toList(),
      ),
    ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.1, end: 0, curve: Curves.easeOutQuad);
  }

  void _markComplete(String bookingId) async {
    final success = await _viewModel.markComplete(
      childId: widget.childId,
      bookingId: bookingId,
    );
    if (mounted) {
      final t = Theme.of(context);
      final appColors = t.extension<AppColors>()!;
      if (success) {
        AppHaptics.success();
      } else {
        AppHaptics.error();
      }
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Text(success ? 'Booking marked as completed' : 'Failed to complete booking'),
            backgroundColor: success ? appColors.statusSuccess : t.colorScheme.error,
            behavior: SnackBarBehavior.floating,
          ),
        );
    }
  }

  Widget _buildEmptyState(ThemeData theme, AppSpacing spacing) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: spacing.xxl, horizontal: spacing.xl),
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
              child: Icon(Symbols.event_busy, size: 56, color: theme.colorScheme.primary),
            ),
            SizedBox(height: spacing.xl),
            Text(
              'No bookings',
              textAlign: TextAlign.center,
              style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900),
            ),
            SizedBox(height: spacing.md),
            Text(
              'Bookings for this child will appear here.',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 300.ms).slideY(begin: 0.08, end: 0, curve: Curves.easeOutQuad);
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
              width: 48, height: 48,
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: booking.isCompleted
                    ? Semantics(
                        label: 'Completed',
                        child: Icon(Symbols.check_circle, color: appColors.statusSuccess, size: 24),
                      )
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
      ),
    ).animate(delay: (index.clamp(0, 8) * 50).ms)
        .fadeIn(duration: 350.ms)
        .slideY(begin: 0.08, end: 0, curve: Curves.easeOutCubic);
  }
}
