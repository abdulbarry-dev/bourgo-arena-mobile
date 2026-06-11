import 'package:bourgo_arena_mobile/core/di/locator.dart';
import 'package:bourgo_arena_mobile/core/theme/bourgo_theme.dart';
import 'package:bourgo_arena_mobile/domain/entities/reservation.dart';
import 'package:bourgo_arena_mobile/domain/usecases/family/get_child_reservations_use_case.dart';
import 'package:bourgo_arena_mobile/presentation/common/widgets/sub_screen_app_bar.dart';
import 'package:bourgo_arena_mobile/presentation/family_child/viewmodels/child_reservations_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:material_symbols_icons/symbols.dart';

class ChildReservationsScreen extends StatefulWidget {
  final String childId;

  const ChildReservationsScreen({super.key, required this.childId});

  @override
  State<ChildReservationsScreen> createState() => _ChildReservationsScreenState();
}

class _ChildReservationsScreenState extends State<ChildReservationsScreen> {
  late final ChildReservationsViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = ChildReservationsViewModel(
      getChildReservationsUseCase: locator<GetChildReservationsUseCase>(),
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
          appBar: SubScreenAppBar(title: 'RESERVATIONS'),
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
                      if (_viewModel.reservations.isEmpty)
                        SliverFillRemaining(child: _buildEmptyState(theme, spacing))
                      else
                        SliverPadding(
                          padding: EdgeInsets.all(spacing.lg),
                          sliver: SliverList(
                            delegate: SliverChildBuilderDelegate(
                              (context, index) {
                                final reservation = _viewModel.reservations[index];
                                return Padding(
                                  padding: EdgeInsets.only(bottom: spacing.md),
                                  child: _ReservationCard(
                                    reservation: reservation,
                                    index: index,
                                    theme: theme,
                                    spacing: spacing,
                                    appColors: appColors,
                                  ),
                                );
                              },
                              childCount: _viewModel.reservations.length,
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

  Widget _buildEmptyState(ThemeData theme, AppSpacing spacing) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: spacing.xxl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Symbols.list_alt, size: 64,
              color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.3)),
            SizedBox(height: spacing.lg),
            Text('No reservations', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900)),
          ],
        ),
      ),
    );
  }
}

class _ReservationCard extends StatelessWidget {
  final Reservation reservation;
  final int index;
  final ThemeData theme;
  final AppSpacing spacing;
  final AppColors appColors;

  const _ReservationCard({
    required this.reservation, required this.index, required this.theme,
    required this.spacing, required this.appColors,
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
              color: const Color(0xFF8B5CF6).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Icon(Symbols.sports, color: const Color(0xFF8B5CF6), size: 24),
            ),
          ),
          SizedBox(width: spacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(reservation.activityTitle,
                  style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800)),
                SizedBox(height: spacing.xxs),
                Row(
                  children: [
                    Icon(Symbols.calendar_today, size: 12, color: theme.colorScheme.onSurfaceVariant),
                    SizedBox(width: spacing.xxs),
                    Text(reservation.date,
                      style: theme.textTheme.labelSmall?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
                    SizedBox(width: spacing.sm),
                    Icon(Symbols.schedule, size: 12, color: theme.colorScheme.onSurfaceVariant),
                    SizedBox(width: spacing.xxs),
                    Text(reservation.time,
                      style: theme.textTheme.labelSmall?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
                  ],
                ),
                SizedBox(height: spacing.xxs),
                Row(
                  children: [
                    Text('${reservation.price.toStringAsFixed(3)} TND',
                      style: theme.textTheme.labelSmall?.copyWith(
                        fontWeight: FontWeight.w700, color: theme.colorScheme.primary)),
                    SizedBox(width: spacing.sm),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: spacing.xs, vertical: 2),
                      decoration: BoxDecoration(
                        color: reservation.paymentStatus == 'paid'
                            ? const Color(0xFF22C55E).withValues(alpha: 0.1)
                            : const Color(0xFFF59E0B).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(reservation.paymentStatus.toUpperCase(),
                        style: theme.textTheme.labelSmall?.copyWith(
                          fontWeight: FontWeight.w900, fontSize: 9,
                          color: reservation.paymentStatus == 'paid'
                              ? const Color(0xFF22C55E) : const Color(0xFFF59E0B),
                        )),
                    ),
                  ],
                ),
              ],
            ),
          ),
          if (reservation.qrCode != null)
            IconButton(
              onPressed: () {}, // QR display
              icon: Icon(Symbols.qr_code, color: theme.colorScheme.primary),
              tooltip: 'Show QR code',
            ),
        ],
      ),
    ).animate(delay: (index * 50).ms).fade(duration: 300.ms).slideX(begin: -0.02, end: 0);
  }
}
