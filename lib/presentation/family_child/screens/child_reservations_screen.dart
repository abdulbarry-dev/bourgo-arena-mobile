import 'package:bourgo_arena_mobile/l10n/app_localizations.dart';
import 'package:bourgo_arena_mobile/core/di/locator.dart';
import 'package:bourgo_arena_mobile/core/theme/bourgo_theme.dart';
import 'package:bourgo_arena_mobile/core/utils/haptic_utils.dart';
import 'package:bourgo_arena_mobile/domain/entities/reservation.dart';
import 'package:bourgo_arena_mobile/domain/usecases/family/get_child_reservations_use_case.dart';
import 'package:bourgo_arena_mobile/presentation/common/widgets/app_shimmer.dart';
import 'package:bourgo_arena_mobile/presentation/common/widgets/filter_pill.dart';
import 'package:bourgo_arena_mobile/presentation/common/widgets/pressable_card.dart';
import 'package:bourgo_arena_mobile/presentation/common/widgets/sub_screen_app_bar.dart';
import 'package:bourgo_arena_mobile/presentation/family_child/viewmodels/child_reservations_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:qr_flutter/qr_flutter.dart';

class ChildReservationsScreen extends StatefulWidget {
  final String childId;

  const ChildReservationsScreen({super.key, required this.childId});

  @override
  State<ChildReservationsScreen> createState() =>
      _ChildReservationsScreenState();
}

class _ChildReservationsScreenState extends State<ChildReservationsScreen> {
  late final ChildReservationsViewModel _viewModel;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _viewModel = ChildReservationsViewModel(
      getChildReservationsUseCase: locator<GetChildReservationsUseCase>(),
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
            title: AppLocalizations.of(context)!.familyChildReservationsTitle,
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
                      if (_viewModel.reservations.isEmpty)
                        SliverFillRemaining(
                          hasScrollBody: false,
                          child: _buildEmptyState(theme, spacing),
                        )
                      else ...[
                        SliverPadding(
                          padding: EdgeInsets.all(spacing.lg),
                          sliver: SliverList(
                            delegate: SliverChildBuilderDelegate((
                              context,
                              index,
                            ) {
                              final reservation =
                                  _viewModel.reservations[index];
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
                            }, childCount: _viewModel.reservations.length),
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
                  AppLocalizations.of(
                    context,
                  )!.familyChildReservationsEmptyTitle,
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
                  AppLocalizations.of(
                    context,
                  )!.familyChildReservationsEmptyMessage,
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

class _ReservationCard extends StatelessWidget {
  final Reservation reservation;
  final int index;
  final ThemeData theme;
  final AppSpacing spacing;
  final AppColors appColors;

  const _ReservationCard({
    required this.reservation,
    required this.index,
    required this.theme,
    required this.spacing,
    required this.appColors,
  });

  @override
  Widget build(BuildContext context) {
    final isPaid = reservation.paymentStatus == 'paid';
    final statusColor = isPaid
        ? appColors.statusSuccess
        : appColors.statusWarning;

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
                    color: const Color(0xFF8B5CF6).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Icon(
                      Symbols.sports,
                      color: const Color(0xFF8B5CF6),
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
                        reservation.activityTitle,
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
                            reservation.date,
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
                            reservation.time,
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: spacing.xxs),
                      Row(
                        children: [
                          Text(
                            '${reservation.price.toStringAsFixed(3)} TND',
                            style: theme.textTheme.labelSmall?.copyWith(
                              fontWeight: FontWeight.w700,
                              color: theme.colorScheme.primary,
                            ),
                          ),
                          SizedBox(width: spacing.sm),
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
                              reservation.paymentStatus.toUpperCase(),
                              style: theme.textTheme.labelSmall?.copyWith(
                                fontWeight: FontWeight.w900,
                                fontSize: 9,
                                color: statusColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                if (reservation.qrCode != null)
                  IconButton(
                    onPressed: () {
                      AppHaptics.light();
                    }, // QR display
                    icon: Icon(
                      Symbols.qr_code,
                      color: theme.colorScheme.primary,
                    ),
                    tooltip: AppLocalizations.of(
                      context,
                    )!.familyChildReservationsShowQrTooltip,
                  ),
              ],
            ),
          ),
        )
        .animate(delay: (index.clamp(0, 8) * 50).ms)
        .fadeIn(duration: 350.ms)
        .slideY(begin: 0.08, end: 0, curve: Curves.easeOutCubic);
  }

  static void _showQrCodeDialog(
    BuildContext context,
    Reservation reservation,
    ThemeData theme,
  ) {
    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        backgroundColor: theme.scaffoldBackgroundColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                reservation.activityTitle.toUpperCase(),
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.0,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                '${reservation.date} · ${reservation.time}',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 24),
              QrImageView(
                data: reservation.qrCode!,
                version: QrVersions.auto,
                size: 200,
                backgroundColor: Colors.white,
              ),
              const SizedBox(height: 12),
              Text(
                reservation.qrCode!,
                style: theme.textTheme.labelSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 20),
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: Text(
                  AppLocalizations.of(
                    context,
                  )!.familyChildReservationsCloseButton,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
