import 'package:bourgo_arena_mobile/core/theme/bourgo_theme.dart';
import 'package:bourgo_arena_mobile/domain/entities/payment.dart';
import 'package:bourgo_arena_mobile/presentation/profile/viewmodels/transaction_history_view_model.dart';
import 'package:bourgo_arena_mobile/presentation/profile/widgets/transaction_tile.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:url_launcher/url_launcher.dart';

class PaymentHistoryScreen extends StatefulWidget {
  final PaymentHistoryViewModel viewModel;

  const PaymentHistoryScreen({super.key, required this.viewModel});

  @override
  State<PaymentHistoryScreen> createState() => _PaymentHistoryScreenState();
}

class _PaymentHistoryScreenState extends State<PaymentHistoryScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    widget.viewModel.loadTransactions();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = context.spacing;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        title: Text(
          'HISTORIQUE DES PAIEMENTS',
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w900,
            letterSpacing: 1.5,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => Navigator.pop(context),
          color: theme.colorScheme.onSurface,
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
            letterSpacing: 0.5,
            fontSize: 12,
          ),
          tabs: const [
            Tab(text: 'TOUT'),
            Tab(text: 'RÉSERVATIONS'),
            Tab(text: 'ABONNEMENTS'),
          ],
        ),
      ),
      body: ListenableBuilder(
        listenable: widget.viewModel,
        builder: (context, _) {
          if (widget.viewModel.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (widget.viewModel.errorMessage != null &&
              widget.viewModel.payments.isEmpty) {
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
                      widget.viewModel.errorMessage!,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: spacing.xl),
                    FilledButton.icon(
                      onPressed: widget.viewModel.loadTransactions,
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

          return TabBarView(
            controller: _tabController,
            children: [
              _PaymentListView(
                payments: widget.viewModel.payments,
                emptyMessage: 'Aucun paiement pour le moment.',
              ),
              _PaymentListView(
                payments: widget.viewModel.reservationPayments,
                emptyMessage: 'Aucun paiement de réservation.',
              ),
              _PaymentListView(
                payments: widget.viewModel.subscriptionPayments,
                emptyMessage: 'Aucun paiement d\'abonnement.',
              ),
            ],
          );
        },
      ),
    );
  }
}

class _PaymentListView extends StatelessWidget {
  final List<Payment> payments;
  final String emptyMessage;

  const _PaymentListView({required this.payments, required this.emptyMessage});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = context.spacing;

    if (payments.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Symbols.payments,
              size: 64,
              color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.3),
            ),
            SizedBox(height: spacing.lg),
            Text(
              emptyMessage,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w800,
                color: theme.colorScheme.onSurface,
              ),
            ),
            SizedBox(height: spacing.sm),
            Text(
              'Les paiements effectués apparaîtront ici.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: spacing.screenPadding(context),
      itemCount: payments.length,
      itemBuilder: (context, index) {
        final payment = payments[index];
        return TransactionTile(
          payment: payment,
          onTapReceipt: payment.receiptUrl != null
              ? () => _openReceipt(context, payment.receiptUrl!)
              : null,
        );
      },
    );
  }

  Future<void> _openReceipt(BuildContext context, String url) async {
    final uri = Uri.tryParse(url);
    if (uri != null && await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}
