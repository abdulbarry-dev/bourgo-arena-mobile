import 'package:bourgo_arena_mobile/l10n/app_localizations.dart';
import 'package:bourgo_arena_mobile/core/di/locator.dart';
import 'package:bourgo_arena_mobile/core/theme/bourgo_theme.dart';
import 'package:bourgo_arena_mobile/core/utils/haptic_utils.dart';
import 'package:bourgo_arena_mobile/domain/entities/child_booking.dart';
import 'package:bourgo_arena_mobile/domain/usecases/family/complete_child_booking_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/family/get_child_bookings_use_case.dart';
import 'package:bourgo_arena_mobile/presentation/common/widgets/app_shimmer.dart';
import '../../common/widgets/app_toast.dart';
import 'package:bourgo_arena_mobile/presentation/common/widgets/filter_pill.dart';
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
          appBar: SubScreenAppBar(
            title: AppLocalizations.of(context)!.familyChildBookingsTitle,
          ),
          body: _viewModel.isLoading
              ? _buildLoadingState(theme, spacing)
              : RefreshIndicator(
                  onRefresh: () => _viewModel.load(
                    childId: widget.childId,
                    filter: _viewModel.filter,
                  ),
                  color: theme.colorScheme.primary,
                  child: CustomScrollView(
                    controller: _scrollController,
                    physics: const AlwaysScrollableScrollPhysics(),
                    slivers: [
                      SliverToBoxAdapter(child: _buildFilterTabs(spacing)),
                      if (_viewModel.bookings.isEmpty)
                        SliverFillRemaining(
                          hasScrollBody: false,
                          child: _buildEmptyState(theme, spacing),
                        )
                      else
                        SliverPadding(
                          padding: EdgeInsets.all(spacing.lg),
                          sliver: SliverList(
                            delegate: SliverChildBuilderDelegate((
                              context,
                              index,
                            ) {
                              final booking = _viewModel.bookings[index];
                              return Padding(
                                padding: EdgeInsets.only(bottom: spacing.md),
                                child: _BookingCard(
                                  booking: booking,
                                  index: index,
                                  theme: theme,
                                  spacing: spacing,
                                  appColors: appColors,
                                  onComplete:
                                      booking.status == 'confirmed' &&
                                          !booking.isCompleted
                                      ? () => _markComplete(booking.id)
                                      : null,
                                ),
                              );
                            }, childCount: _viewModel.bookings.length),
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

  Widget _buildFilterTabs(AppSpacing spacing) {
    final filters = ['all', 'upcoming', 'past'];
    return Padding(
          padding: EdgeInsets.fromLTRB(spacing.lg, spacing.lg, spacing.lg, 0),
          child: Row(
            children: filters.map((f) {
              return Padding(
                padding: EdgeInsets.only(right: spacing.sm),
                child: FilterPill(
                  label: f.toUpperCase(),
                  isSelected: _viewModel.filter == f,
                  onTap: () =>
                      _viewModel.load(childId: widget.childId, filter: f),
                  hapticFeedback: true,
                ),
              );
            }).toList(),
          ),
        )
        .animate()
        .fadeIn(duration: 400.ms)
        .slideY(begin: 0.1, end: 0, curve: Curves.easeOutQuad);
  }

  void _markComplete(String bookingId) async {
    final success = await _viewModel.markComplete(
      childId: widget.childId,
      bookingId: bookingId,
    );
    if (mounted) {
      if (success) {
        AppHaptics.success();
      } else {
        AppHaptics.error();
      }
      AppToast.show(
        context,
        success
            ? AppLocalizations.of(context)!.familyChildBookingCompletedSuccess
            : AppLocalizations.of(context)!.familyChildBookingCompletedFailure,
        type: success ? AppToastType.success : AppToastType.error,
      );
    }
  }

  Widget _buildEmptyState(ThemeData theme, AppSpacing spacing) {
    return Center(
      child: Padding(
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
                    Symbols.event_busy,
                    size: 56,
                    color: theme.colorScheme.primary,
                  ),
                )
                .animate()
                .scale(duration: 400.ms, curve: Curves.easeOutBack)
                .fade(duration: 400.ms),
            SizedBox(height: spacing.xl),
            Text(
                  AppLocalizations.of(context)!.familyChildBookingsEmptyTitle,
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
                  AppLocalizations.of(context)!.familyChildBookingsEmptyMessage,
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
    required this.booking,
    required this.index,
    required this.theme,
    required this.spacing,
    required this.appColors,
    this.onComplete,
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
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: booking.isCompleted
                        ? Semantics(
                            label: AppLocalizations.of(
                              context,
                            )!.familyChildBookingsCompletedStatus,
                            child: Icon(
                              Symbols.check_circle,
                              color: appColors.statusSuccess,
                              size: 24,
                            ),
                          )
                        : Icon(
                            Symbols.event,
                            color: theme.colorScheme.primary,
                            size: 24,
                          ),
                  ),
                ),
                SizedBox(width: spacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        booking.courseName,
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
                            booking.date,
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                          SizedBox(width: spacing.sm),
                          Icon(
                            Symbols.schedule,
                            size: 12,
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                          SizedBox(width: spacing.xxs),
                          Text(
                            '${booking.startTime} - ${booking.endTime}',
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                if (onComplete != null)
                  IconButton(
                    onPressed: onComplete,
                    icon: Icon(
                      Symbols.check_circle_outline,
                      color: theme.colorScheme.primary,
                    ),
                    tooltip: AppLocalizations.of(
                      context,
                    )!.familyChildBookingsMarkCompletedTooltip,
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
