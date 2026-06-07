import 'package:bourgo_arena_mobile/core/di/locator.dart';
import 'package:bourgo_arena_mobile/core/theme/bourgo_theme.dart';
import 'package:bourgo_arena_mobile/domain/entities/reservation.dart';
import 'package:bourgo_arena_mobile/domain/usecases/booking/get_ongoing_reservations_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/booking/get_reservation_history_use_case.dart';
import 'package:bourgo_arena_mobile/presentation/activities/widgets/reservation_card.dart';
import 'package:bourgo_arena_mobile/presentation/common/empty_state.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

enum _TabState { loading, loaded, error }

class ReservationsScreen extends StatefulWidget {
  const ReservationsScreen({super.key});

  @override
  State<ReservationsScreen> createState() => _ReservationsScreenState();
}

class _ReservationsScreenState extends State<ReservationsScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  final _ongoingUseCase = locator<GetOngoingReservationsUseCase>();
  final _historyUseCase = locator<GetReservationHistoryUseCase>();

  List<Reservation> _ongoing = [];
  List<Reservation> _history = [];
  _TabState _ongoingState = _TabState.loading;
  _TabState _historyState = _TabState.loading;
  String _ongoingError = '';
  String _historyError = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _fetchOngoing();
    _fetchHistory();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _fetchOngoing() async {
    setState(() => _ongoingState = _TabState.loading);
    final result = await _ongoingUseCase.call();
    result.when(
      success: (data) => setState(() {
        _ongoing = data;
        _ongoingState = _TabState.loaded;
      }),
      failure: (f) => setState(() {
        _ongoingError = f.message;
        _ongoingState = _TabState.error;
      }),
    );
  }

  Future<void> _fetchHistory() async {
    setState(() => _historyState = _TabState.loading);
    final result = await _historyUseCase.call();
    result.when(
      success: (data) => setState(() {
        _history = data;
        _historyState = _TabState.loaded;
      }),
      failure: (f) => setState(() {
        _historyError = f.message;
        _historyState = _TabState.error;
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => Navigator.pop(context),
          color: theme.colorScheme.onSurface,
        ),
        title: Text(
          'MES RÉSERVATIONS',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w900,
            letterSpacing: 1.5,
          ),
        ),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: theme.colorScheme.primary,
          indicatorWeight: 3,
          labelColor: theme.colorScheme.primary,
          unselectedLabelColor: theme.colorScheme.onSurface.withValues(
            alpha: 0.4,
          ),
          labelStyle: const TextStyle(
            fontWeight: FontWeight.w900,
            letterSpacing: 1,
            fontSize: 12,
          ),
          tabs: const [
            Tab(text: 'À VENIR'),
            Tab(text: 'HISTORIQUE'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _TabContent(
            state: _ongoingState,
            reservations: _ongoing,
            errorMessage: _ongoingError,
            emptyTitle: 'AUCUNE RÉSERVATION À VENIR',
            emptyMessage: "Vous n'avez pas encore de réservations à venir.",
            onRetry: _fetchOngoing,
            onRefresh: _fetchOngoing,
          ),
          _TabContent(
            state: _historyState,
            reservations: _history,
            errorMessage: _historyError,
            emptyTitle: 'HISTORIQUE VIDE',
            emptyMessage: "Vous n'avez pas encore de réservations passées.",
            onRetry: _fetchHistory,
            onRefresh: _fetchHistory,
          ),
        ],
      ),
    );
  }
}

class _TabContent extends StatelessWidget {
  final _TabState state;
  final List<Reservation> reservations;
  final String errorMessage;
  final String emptyTitle;
  final String emptyMessage;
  final VoidCallback? onRetry;
  final Future<void> Function() onRefresh;

  const _TabContent({
    required this.state,
    required this.reservations,
    required this.errorMessage,
    required this.emptyTitle,
    required this.emptyMessage,
    this.onRetry,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    switch (state) {
      case _TabState.loading:
        return const _SkeletonList();
      case _TabState.error:
        return _ErrorView(message: errorMessage, onRetry: onRetry);
      case _TabState.loaded:
        if (reservations.isEmpty) {
          return Center(
            child: EmptyState(
              title: emptyTitle,
              message: emptyMessage,
              icon: Symbols.calendar_today,
            ),
          );
        }
        return RefreshIndicator(
          onRefresh: onRefresh,
          child: ListView.builder(
            padding: const EdgeInsets.all(24),
            physics: const AlwaysScrollableScrollPhysics(),
            itemCount: reservations.length,
            itemBuilder: (context, index) =>
                ReservationCard(reservation: reservations[index]),
          ),
        );
    }
  }
}

class _SkeletonList extends StatelessWidget {
  const _SkeletonList();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ListView.builder(
      padding: const EdgeInsets.all(24),
      itemCount: 4,
      itemBuilder: (context, index) => Container(
        margin: const EdgeInsets.only(bottom: 20),
        height: 140,
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainerHighest.withValues(
            alpha: 0.5,
          ),
          borderRadius: BorderRadius.circular(24),
        ),
        child: Center(
          child: SizedBox(
            width: 24,
            height: 24,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: theme.colorScheme.primary.withValues(alpha: 0.3),
            ),
          ),
        ),
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback? onRetry;

  const _ErrorView({required this.message, this.onRetry});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = context.spacing;

    return Center(
      child: Padding(
        padding: spacing.screenPadding(context),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(spacing.lg),
              decoration: BoxDecoration(
                color: theme.colorScheme.error.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Symbols.wifi_off,
                size: 48,
                color: theme.colorScheme.error,
              ),
            ),
            SizedBox(height: spacing.lg),
            Text(
              'Chargement échoué',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w900,
                color: theme.colorScheme.onSurface,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: spacing.sm),
            Text(
              message,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: spacing.xl),
            FilledButton.icon(
              onPressed: onRetry,
              icon: const Icon(Symbols.refresh, size: 20),
              label: const Text('Réessayer'),
              style: FilledButton.styleFrom(
                padding: EdgeInsets.symmetric(
                  horizontal: spacing.xl,
                  vertical: spacing.md,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
