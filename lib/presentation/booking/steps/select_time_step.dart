import 'package:bourgo_arena_mobile/l10n/app_localizations.dart';
import 'package:bourgo_arena_mobile/presentation/booking/booking_view_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Step 2: Select Date and Time Slot.
class SelectTimeStep extends StatelessWidget {
  final BookingViewModel viewModel;

  const SelectTimeStep({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _DatePicker(viewModel: viewModel),
        const SizedBox(height: 24),
        Expanded(
          child: viewModel.isLoading
              ? const Center(child: CircularProgressIndicator())
              : _TimeGrid(viewModel: viewModel),
        ),
        _BottomActionBar(
          label: AppLocalizations.of(context)!.bookingConfirm,
          onPressed: viewModel.selectedSlot != null ? viewModel.nextStep : null,
          price: viewModel.selectedActivity?.price ?? 0,
        ),
      ],
    );
  }
}

class _DatePicker extends StatelessWidget {
  final BookingViewModel viewModel;

  const _DatePicker({required this.viewModel});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final now = DateTime.now();

    return Container(
      height: 90,
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: 7,
        itemBuilder: (context, index) {
          final date = now.add(Duration(days: index));
          final isSelected = viewModel.selectedDate.day == date.day;

          return GestureDetector(
            onTap: () => viewModel.selectDate(date),
            child: Container(
              width: 60,
              margin: const EdgeInsets.only(right: 12),
              decoration: BoxDecoration(
                color: isSelected
                    ? theme.colorScheme.primary
                    : theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isSelected
                      ? theme.colorScheme.primary
                      : Colors.white12,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    DateFormat(
                      'EEE',
                      Localizations.localeOf(context).toString(),
                    ).format(date).toUpperCase(),
                    style: TextStyle(
                      color: isSelected ? Colors.black : Colors.white70,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    date.day.toString(),
                    style: TextStyle(
                      color: isSelected ? Colors.black : Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _TimeGrid extends StatelessWidget {
  final BookingViewModel viewModel;

  const _TimeGrid({required this.viewModel});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (viewModel.availableSlots.isEmpty) {
      return Center(child: Text(AppLocalizations.of(context)!.bookingNoSlots));
    }

    return GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 2.5,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: viewModel.availableSlots.length,
      itemBuilder: (context, index) {
        final slot = viewModel.availableSlots[index];
        final isSelected = viewModel.selectedSlot?.time == slot.time;

        return GestureDetector(
          onTap: slot.available ? () => viewModel.selectSlot(slot) : null,
          child: Container(
            decoration: BoxDecoration(
              color: isSelected
                  ? theme.colorScheme.primary.withAlpha(40)
                  : theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isSelected
                    ? theme.colorScheme.primary
                    : slot.available
                    ? Colors.white12
                    : Colors.transparent,
              ),
            ),
            child: Center(
              child: Text(
                slot.time,
                style: TextStyle(
                  color: slot.available
                      ? (isSelected ? theme.colorScheme.primary : Colors.white)
                      : Colors.white24,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  decoration: slot.available
                      ? null
                      : TextDecoration.lineThrough,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _BottomActionBar extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final double price;

  const _BottomActionBar({
    required this.label,
    required this.onPressed,
    required this.price,
  });

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
        child: Row(
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppLocalizations.of(context)!.bookingTotal,
                  style: TextStyle(color: Colors.white54, fontSize: 10),
                ),
                Text(
                  '$price ${AppLocalizations.of(context)!.bookingCurrency}',
                  style: TextStyle(
                    color: theme.colorScheme.primary,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(width: 24),
            Expanded(
              child: ElevatedButton(
                onPressed: onPressed,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 52),
                ),
                child: Text(label),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
