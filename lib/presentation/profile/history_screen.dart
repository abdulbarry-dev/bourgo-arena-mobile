import 'package:bourgo_arena_mobile/core/constants.dart';
import 'package:bourgo_arena_mobile/data/services/data_service.dart';
import 'package:bourgo_arena_mobile/presentation/activities/activities_view_model.dart';
import 'package:bourgo_arena_mobile/presentation/activities/widgets/reservation_card.dart';
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
        title: const Text(AppConstants.profileHistoryTitle),
        backgroundColor: theme.colorScheme.surface,
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: AppConstants.profileTabCheckin),
            Tab(text: AppConstants.profileTabHistory),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _CheckInTab(),
          _HistoryTab(viewModel: _viewModel),
        ],
      ),
    );
  }
}

class _CheckInTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          AppConstants.profileQrSubtitle,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            letterSpacing: 1.5,
            fontSize: 12,
            color: Colors.white54,
          ),
        ),
        const SizedBox(height: 32),
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: theme.colorScheme.primary.withAlpha(50),
                blurRadius: 40,
                spreadRadius: 5,
              ),
            ],
          ),
          child: Column(
            children: [
              // Mock QR Code placeholder
              Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black, width: 2),
                ),
                child: const Icon(
                  Symbols.qr_code_2,
                  size: 180,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                AppConstants.profileQrPlaceholder,
                style: TextStyle(
                  color: Colors.black54,
                  fontFamily: 'monospace',
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 48),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 48),
          child: Text(
            AppConstants.profileQrScanInstruction,
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white54, fontSize: 14),
          ),
        ),
      ],
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
          return const Center(child: Text(AppConstants.profileNoHistory));
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
