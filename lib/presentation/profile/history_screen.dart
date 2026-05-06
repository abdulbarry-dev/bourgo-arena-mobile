import 'package:bourgo_arena_mobile/data/services/data_service.dart';
import 'package:bourgo_arena_mobile/l10n/app_localizations.dart';
import 'package:bourgo_arena_mobile/presentation/activities/viewmodels/activities_view_model.dart';
import 'package:bourgo_arena_mobile/presentation/activities/widgets/reservation_card.dart';
import 'package:bourgo_arena_mobile/presentation/common/empty_state.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

/// Screen for Check-in (QR) and Full History.
class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  late final ActivitiesViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _viewModel = ActivitiesViewModel(dataService: DataService());
    _viewModel.loadData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.profileHistoryTitle),
        backgroundColor: theme.colorScheme.surface,
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: AppLocalizations.of(context)!.profileTabCheckin),
            Tab(text: AppLocalizations.of(context)!.profileTabHistory),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          const _AccessTab(),
          _HistoryTab(viewModel: _viewModel),
        ],
      ),
    );
  }
}

class _AccessTab extends StatelessWidget {
  const _AccessTab();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Access Methods Section
          Text(
            l10n.profileAccessMethods,
            style: theme.textTheme.labelLarge?.copyWith(
              color: theme.colorScheme.primary,
              letterSpacing: 2,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          _AccessMethodTile(
            icon: Symbols.pin,
            label: l10n.profileAccessPin,
            isSet: true,
          ),
          const SizedBox(height: 12),
          _AccessMethodTile(
            icon: Symbols.fingerprint,
            label: l10n.profileAccessFingerprint,
            isSet: false,
          ),
          const SizedBox(height: 12),
          _AccessMethodTile(
            icon: Symbols.contactless,
            label: l10n.profileAccessNfc,
            isSet: true,
          ),

          const SizedBox(height: 40),

          // Check-in History Section
          Text(
            l10n.profileCheckinHistory,
            style: theme.textTheme.labelLarge?.copyWith(
              color: theme.colorScheme.primary,
              letterSpacing: 2,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          _CheckinHistoryList(),
        ],
      ),
    );
  }
}

class _AccessMethodTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSet;

  const _AccessMethodTile({
    required this.icon,
    required this.label,
    required this.isSet,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.5),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: theme.colorScheme.primary, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Text(
                  isSet
                      ? l10n.profileStatusConfigured
                      : l10n.profileStatusNotConfigured,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: isSet
                        ? theme.colorScheme.primary
                        : theme.colorScheme.onSurfaceVariant.withValues(
                            alpha: 0.6,
                          ),
                  ),
                ),
              ],
            ),
          ),
          if (!isSet) TextButton(onPressed: () {}, child: const Text('SET UP')),
          if (isSet)
            Icon(
              Symbols.check_circle,
              color: theme.colorScheme.primary.withValues(alpha: 0.5),
              size: 20,
            ),
        ],
      ),
    );
  }
}

class _CheckinHistoryList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    // Mock data for check-in history
    final history = [
      {'date': 'Today', 'time': '09:42', 'location': 'Main Entrance'},
      {'date': 'Yesterday', 'time': '17:15', 'location': 'Gym Gate'},
      {'date': '01 May', 'time': '08:30', 'location': 'Main Entrance'},
      {'date': '30 April', 'time': '18:00', 'location': 'Gym Gate'},
    ];

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: history.length,
      itemBuilder: (context, index) {
        final item = history[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainerHighest,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Symbols.login,
                  size: 20,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.profileCheckinEntry,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '${item['location']}',
                      style: TextStyle(
                        fontSize: 12,
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${item['date']}',
                    style: theme.textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    '${item['time']}',
                    style: TextStyle(
                      fontSize: 12,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

class _HistoryTab extends StatelessWidget {
  final ActivitiesViewModel viewModel;

  const _HistoryTab({required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: viewModel,
      builder: (context, _) {
        if (viewModel.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        final reservations = viewModel.reservations;
        if (reservations.isEmpty) {
          return EmptyState(
            title: AppLocalizations.of(context)!.profileNoHistory,
            message: AppLocalizations.of(context)!.profileNoHistorySubtitle,
            icon: Symbols.history,
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(24),
          itemCount: reservations.length,
          itemBuilder: (context, index) {
            final reservation = reservations[index];
            return Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: ReservationCard(reservation: reservation),
            );
          },
        );
      },
    );
  }
}
