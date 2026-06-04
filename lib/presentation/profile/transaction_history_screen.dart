import 'package:flutter/material.dart';
import 'package:bourgo_arena_mobile/domain/entities/payment.dart';
import 'package:bourgo_arena_mobile/core/theme/bourgo_theme.dart';
import 'package:bourgo_arena_mobile/presentation/profile/widgets/transaction_tile.dart';
import 'package:go_router/go_router.dart';

class TransactionHistoryScreen extends StatelessWidget {
  final List<Payment>? initialPayments; // Inject from ViewModel usually, doing static for now

  const TransactionHistoryScreen({super.key, this.initialPayments});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = AppSpacing.standard;

    // Static placeholder data if none provided (for UI demonstration purposes)
    final payments = initialPayments ?? [
      Payment(
        id: '1',
        type: 'subscription',
        amount: 29.99,
        currency: 'USD',
        status: 'success',
        gateway: 'stripe',
        paymentReference: 'TXN-1029384',
        createdAt: DateTime.now().subtract(const Duration(days: 2)),
      ),
      Payment(
        id: '2',
        type: 'subscription',
        amount: 29.99,
        currency: 'USD',
        status: 'failed',
        gateway: 'stripe',
        paymentReference: 'TXN-1029383',
        createdAt: DateTime.now().subtract(const Duration(days: 32)),
      ),
    ];

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        title: const Text('Transaction History'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: payments.isEmpty
          ? Center(
              child: Text(
                'No transactions found.',
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            )
          : ListView.builder(
              padding: spacing.screenPadding(context),
              itemCount: payments.length,
              itemBuilder: (context, index) {
                return TransactionTile(payment: payments[index]);
              },
            ),
    );
  }
}
