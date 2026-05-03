import 'package:bourgo_arena_mobile/core/constants/app_constants.dart';
import 'package:bourgo_arena_mobile/l10n/app_localizations.dart';
import 'package:bourgo_arena_mobile/presentation/booking/viewmodels/booking_view_model.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:material_symbols_icons/symbols.dart';

/// Step 3: Payment and Confirmation Summary.
class PaymentStep extends StatelessWidget {
  final BookingViewModel viewModel;

  const PaymentStep({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _SectionTitle(
                  title: AppLocalizations.of(context)!.bookingSummaryTitle,
                ),
                _SummaryCard(viewModel: viewModel),
                const SizedBox(height: 32),
                _SectionTitle(
                  title: AppLocalizations.of(context)!.bookingPaymentTitle,
                ),
                _PaymentMethodSelector(viewModel: viewModel),
              ],
            ),
          ),
        ),
        _BottomPayButton(
          onPressed: () => context.push(
            '/booking-success',
            extra: viewModel.selectedActivity,
          ),
          price: viewModel.selectedActivity?.price ?? 0,
        ),
      ],
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;

  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.5,
          color: Colors.white54,
        ),
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final BookingViewModel viewModel;

  const _SummaryCard({required this.viewModel});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final activity = viewModel.selectedActivity;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.colorScheme.primary.withAlpha(50)),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            theme.colorScheme.surface,
            theme.colorScheme.primary.withAlpha(10),
          ],
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: theme.colorScheme.primary.withAlpha(30),
                ),
                child: Icon(
                  _getIcon(activity?.icon ?? ''),
                  color: theme.colorScheme.primary,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      activity?.title ?? '',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    Text(
                      activity?.category ?? '',
                      style: const TextStyle(
                        color: Colors.white54,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: Divider(color: Colors.white10),
          ),
          _SummaryRow(
            icon: Symbols.calendar_month,
            label: AppLocalizations.of(context)!.bookingDate,
            value: DateFormat(
              'dd MMMM yyyy',
              Localizations.localeOf(context).toString(),
            ).format(viewModel.selectedDate),
          ),
          const SizedBox(height: 12),
          _SummaryRow(
            icon: Symbols.schedule,
            label: AppLocalizations.of(context)!.bookingTime,
            value: viewModel.selectedSlot?.time ?? '',
          ),
          const SizedBox(height: 12),
          _SummaryRow(
            icon: Symbols.hourglass_bottom,
            label: AppLocalizations.of(context)!.bookingDuration,
            value: activity?.id == 'padel-1'
                ? AppLocalizations.of(context)!.bookingDurationPadel
                : AppLocalizations.of(context)!.bookingDurationStandard,
          ),
        ],
      ),
    );
  }

  IconData _getIcon(String name) {
    switch (name) {
      case 'sports_soccer':
        return Icons.sports_soccer;
      case 'sports_tennis':
        return Icons.sports_tennis;
      case 'sports_basketball':
        return Icons.sports_basketball;
      case 'fitness_center':
        return Icons.fitness_center;
      default:
        return Icons.sports;
    }
  }
}

class _SummaryRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _SummaryRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.white54),
        const SizedBox(width: 8),
        Text(
          label,
          style: const TextStyle(color: Colors.white54, fontSize: 14),
        ),
        const Spacer(),
        Text(
          value,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
        ),
      ],
    );
  }
}

class _PaymentMethodSelector extends StatelessWidget {
  final BookingViewModel viewModel;

  const _PaymentMethodSelector({required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _PaymentOption(
          icon: Symbols.credit_card,
          label: AppLocalizations.of(context)!.bookingMethodCard,
          isSelected:
              viewModel.paymentMethod == AppConstants.paymentMethodCardId,
          onTap: () =>
              viewModel.setPaymentMethod(AppConstants.paymentMethodCardId),
        ),
        const SizedBox(height: 12),
        _PaymentOption(
          icon: Symbols.account_balance_wallet,
          label: AppLocalizations.of(context)!.bookingMethodWallet,
          isSelected:
              viewModel.paymentMethod == AppConstants.paymentMethodWalletId,
          onTap: () =>
              viewModel.setPaymentMethod(AppConstants.paymentMethodWalletId),
        ),
      ],
    );
  }
}

class _PaymentOption extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _PaymentOption({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? theme.colorScheme.primary : Colors.white12,
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isSelected ? theme.colorScheme.primary : Colors.white54,
            ),
            const SizedBox(width: 16),
            Text(
              label,
              style: TextStyle(
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected ? Colors.white : Colors.white70,
              ),
            ),
            const Spacer(),
            if (isSelected)
              Icon(
                Symbols.check_circle,
                color: theme.colorScheme.primary,
                size: 20,
              ),
          ],
        ),
      ),
    );
  }
}

class _BottomPayButton extends StatelessWidget {
  final VoidCallback onPressed;
  final double price;

  const _BottomPayButton({required this.onPressed, required this.price});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: const Border(top: BorderSide(color: Colors.white10)),
      ),
      child: SafeArea(
        top: false,
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(double.infinity, 56),
          ),
          child: Text(
            '${AppLocalizations.of(context)!.bookingPay} — $price ${AppLocalizations.of(context)!.bookingCurrency}',
          ),
        ),
      ),
    );
  }
}
