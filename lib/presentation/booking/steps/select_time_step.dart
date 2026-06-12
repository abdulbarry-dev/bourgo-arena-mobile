import 'package:bourgo_arena_mobile/core/constants/app_constants.dart';
import 'package:bourgo_arena_mobile/core/theme/bourgo_theme.dart';
import 'package:bourgo_arena_mobile/domain/entities/time_slot.dart';
import 'package:bourgo_arena_mobile/l10n/app_localizations.dart';
import 'package:bourgo_arena_mobile/presentation/booking/viewmodels/booking_view_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:material_symbols_icons/symbols.dart';

const _dayNames = <String>[
  'DIMANCHE',
  'LUNDI',
  'MARDI',
  'MERCREDI',
  'JEUDI',
  'VENDREDI',
  'SAMEDI',
];

class SelectTimeStep extends StatelessWidget {
  final BookingViewModel viewModel;

  const SelectTimeStep({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    if (viewModel.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    final selectedDow = viewModel.selectedDate.weekday % 7;
    final filteredSlots = viewModel.availableSlots
        .where((s) => s.dayOfWeek == selectedDow)
        .toList();

    if (filteredSlots.isEmpty) {
      return Column(
        children: [
          _DatePicker(viewModel: viewModel),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                Icon(
                  Symbols.event_busy,
                  size: 48,
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurfaceVariant.withValues(alpha: 0.4),
                ),
                const SizedBox(height: 12),
                Text(
                  l10n.bookingNoSlots,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          const Spacer(),
          _BottomActionBar(
            label: l10n.bookingConfirm,
            onPressed: null,
            price: viewModel.priceToPay,
          ),
        ],
      );
    }

    final groups = <int, List<TimeSlot>>{};
    for (final s in filteredSlots) {
      (groups[s.dayOfWeek!] ??= []).add(s);
    }

    return Column(
      children: [
        _DatePicker(viewModel: viewModel),
        const SizedBox(height: 16),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            children: [
              for (final entry in groups.entries)
                _DaySection(
                  dayLabel: _dayNames[entry.key],
                  slots: entry.value,
                  selectedSlotId: viewModel.selectedSlot?.id,
                  reservedSlotIds: viewModel.reservedSlotIds,
                  onSelectSlot: viewModel.selectSlot,
                ),
            ],
          ),
        ),
        _BottomActionBar(
          label: l10n.bookingConfirm,
          onPressed: viewModel.selectedSlot != null ? viewModel.nextStep : null,
          price: viewModel.priceToPay,
        ),
      ],
    );
  }
}

class _DatePicker extends StatelessWidget {
  final BookingViewModel viewModel;

  const _DatePicker({required this.viewModel});

  static final _dayFormat = DateFormat('d');
  static final _monthFormat = DateFormat('MMM');

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = theme.extension<AppColors>()!;
    final now = DateTime.now();

    return Container(
      height: 100,
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        border: Border(bottom: BorderSide(color: appColors.bgBorder, width: 1)),
      ),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        itemCount: 7,
        itemBuilder: (context, index) {
          final date = DateTime(
            now.year,
            now.month,
            now.day,
          ).add(Duration(days: index));
          final isSelected =
              viewModel.selectedDate.day == date.day &&
              viewModel.selectedDate.month == date.month &&
              viewModel.selectedDate.year == date.year;
          final dayOfWeek = date.weekday % 7;

          return GestureDetector(
            onTap: () => viewModel.selectDate(date),
            child: Container(
              width: 64,
              margin: const EdgeInsets.only(right: 8),
              decoration: BoxDecoration(
                color: isSelected
                    ? theme.colorScheme.primary
                    : theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isSelected
                      ? theme.colorScheme.primary
                      : appColors.bgBorder,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _dayNames[dayOfWeek].substring(0, 3),
                    style: theme.textTheme.labelSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.8,
                      color: isSelected
                          ? theme.colorScheme.onPrimary
                          : theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _dayFormat.format(date),
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontFamily: AppConstants.displayFontFamily,
                      fontWeight: FontWeight.w900,
                      color: isSelected
                          ? theme.colorScheme.onPrimary
                          : theme.colorScheme.onSurface,
                    ),
                  ),
                  Text(
                    _monthFormat.format(date).toUpperCase(),
                    style: theme.textTheme.labelSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.6,
                      color: isSelected
                          ? theme.colorScheme.onPrimary.withValues(alpha: 0.8)
                          : theme.colorScheme.onSurfaceVariant.withValues(
                              alpha: 0.6,
                            ),
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

class _DaySection extends StatelessWidget {
  final String dayLabel;
  final List<TimeSlot> slots;
  final String? selectedSlotId;
  final Set<String> reservedSlotIds;
  final void Function(TimeSlot) onSelectSlot;

  const _DaySection({
    required this.dayLabel,
    required this.slots,
    required this.selectedSlotId,
    required this.reservedSlotIds,
    required this.onSelectSlot,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.only(left: 4),
          child: Text(
            dayLabel,
            style: theme.textTheme.labelMedium?.copyWith(
              fontWeight: FontWeight.w800,
              letterSpacing: 1.5,
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ),
        const SizedBox(height: 8),
        ...slots.map(
          (slot) => _SlotTile(
            key: ValueKey(slot.id ?? slot.time),
            slot: slot,
            isSelected: selectedSlotId == slot.id,
            isReservedByUser:
                slot.id != null && reservedSlotIds.contains(slot.id),
            onTap: () => onSelectSlot(slot),
          ),
        ),
        const SizedBox(height: 4),
      ],
    );
  }
}

class _SlotTile extends StatelessWidget {
  final TimeSlot slot;
  final bool isSelected;

  /// True when this slot is already reserved by the current user.
  final bool isReservedByUser;
  final VoidCallback onTap;

  const _SlotTile({
    super.key,
    required this.slot,
    required this.isSelected,
    required this.isReservedByUser,
    required this.onTap,
  });

  String _formatTime(String? time) {
    if (time == null) return '';
    return time.substring(0, 5);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = theme.extension<AppColors>()!;
    final startFormatted = _formatTime(slot.startTime);
    final endFormatted = _formatTime(slot.endTime);
    // A slot reserved by the current user is always treated as
    // unavailable for selection (even if capacity allows more bookings).
    final isFullyBooked =
        !isReservedByUser && (slot.isFullyBooked || !slot.available);
    final isDisabled = isReservedByUser || isFullyBooked;

    // Amber tint for "reserved by you", muted grey for fully booked.
    final reservedByUserColor = theme.brightness == Brightness.dark
        ? const Color(0xFFFFF8E1)
        : const Color(0xFFFFF3E0);

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: GestureDetector(
        onTap: isDisabled ? null : onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isSelected
                ? theme.colorScheme.primary.withValues(alpha: 0.12)
                : isReservedByUser
                ? reservedByUserColor.withValues(alpha: 0.45)
                : isFullyBooked
                ? theme.colorScheme.surfaceContainerHighest.withValues(
                    alpha: 0.4,
                  )
                : theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isSelected
                  ? theme.colorScheme.primary
                  : isReservedByUser
                  ? const Color(0xFFFFB300).withValues(alpha: 0.5)
                  : isFullyBooked
                  ? appColors.bgBorder.withValues(alpha: 0.5)
                  : appColors.bgBorder,
              width: isSelected ? 1.5 : 1,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: isSelected
                      ? theme.colorScheme.primary
                      : isReservedByUser
                      ? const Color(0xFFFFB300).withValues(alpha: 0.18)
                      : isFullyBooked
                      ? theme.colorScheme.surfaceContainerHighest
                      : theme.colorScheme.primaryContainer.withValues(
                          alpha: 0.3,
                        ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  isSelected
                      ? Symbols.check_circle
                      : isReservedByUser
                      ? Symbols.lock
                      : isFullyBooked
                      ? Symbols.event_busy
                      : Symbols.schedule,
                  size: 20,
                  color: isSelected
                      ? theme.colorScheme.onPrimary
                      : isReservedByUser
                      ? const Color(0xFFFFB300)
                      : isFullyBooked
                      ? theme.colorScheme.onSurfaceVariant.withValues(
                          alpha: 0.4,
                        )
                      : theme.colorScheme.primary,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '$startFormatted - $endFormatted',
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: isReservedByUser
                            ? theme.colorScheme.onSurfaceVariant.withValues(
                                alpha: 0.6,
                              )
                            : isFullyBooked
                            ? theme.colorScheme.onSurfaceVariant.withValues(
                                alpha: 0.5,
                              )
                            : theme.colorScheme.onSurface,
                      ),
                    ),
                    if (slot.durationMinutes != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        '${slot.durationMinutes} min',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: isDisabled
                              ? theme.colorScheme.onSurfaceVariant.withValues(
                                  alpha: 0.35,
                                )
                              : theme.colorScheme.onSurfaceVariant.withValues(
                                  alpha: 0.6,
                                ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              if (isReservedByUser)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFB300).withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'RÉSERVÉ',
                    style: theme.textTheme.labelSmall?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFFFFB300),
                      letterSpacing: 0.8,
                    ),
                  ),
                )
              else if (slot.capacity != null && slot.bookedCount != null)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? theme.colorScheme.primary.withValues(alpha: 0.15)
                        : theme.colorScheme.surfaceContainerHighest.withValues(
                            alpha: 0.5,
                          ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '${slot.bookedCount}/${slot.capacity}',
                    style: theme.textTheme.labelSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: isFullyBooked
                          ? theme.colorScheme.onSurfaceVariant.withValues(
                              alpha: 0.4,
                            )
                          : theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                )
              else if (isFullyBooked)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surfaceContainerHighest.withValues(
                      alpha: 0.5,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'COMPLET',
                    style: theme.textTheme.labelSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: theme.colorScheme.error.withValues(alpha: 0.6),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
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
    final l10n = AppLocalizations.of(context)!;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border(
          top: BorderSide(
            color: theme.colorScheme.outline.withValues(alpha: 0.1),
          ),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            Flexible(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.bookingTotal,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                      letterSpacing: 0.5,
                    ),
                  ),
                  Text(
                    '$price ${l10n.bookingCurrency}',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontFamily: AppConstants.displayFontFamily,
                      fontWeight: FontWeight.w900,
                      color: theme.colorScheme.primary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 24),
            Expanded(
              child: ElevatedButton(
                onPressed: onPressed,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 52),
                  backgroundColor: theme.colorScheme.primary,
                  foregroundColor: theme.colorScheme.onPrimary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: Text(
                  label,
                  style: const TextStyle(
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.2,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
