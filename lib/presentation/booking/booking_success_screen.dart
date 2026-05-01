import 'package:bourgo_arena_mobile/core/constants.dart';
import 'package:bourgo_arena_mobile/data/models/activity.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';

/// Screen displayed after a successful booking.
class BookingSuccessScreen extends StatelessWidget {
  /// The activity that was booked.
  final Activity? activity;

  const BookingSuccessScreen({super.key, this.activity});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: theme.colorScheme.primary.withAlpha(40),
                  boxShadow: [
                    BoxShadow(
                      color: theme.colorScheme.primary.withAlpha(40),
                      blurRadius: 40,
                      spreadRadius: 10,
                    ),
                  ],
                ),
                child: Icon(
                  Symbols.check_circle,
                  size: 80,
                  color: theme.colorScheme.primary,
                  fill: 1,
                ),
              ),
              const SizedBox(height: 40),
              Text(
                AppConstants.bookingConfirmed,
                textAlign: TextAlign.center,
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontFamily: AppConstants.displayFontFamily,
                  letterSpacing: 1.5,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                '${AppConstants.bookingSuccessMessagePrefix}${activity?.title ?? AppConstants.bookingSportDefault}${AppConstants.bookingSuccessMessageSuffix}',
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white70, fontSize: 16),
              ),
              const SizedBox(height: 48),
              _DetailItem(
                icon: Symbols.calendar_month,
                label: AppConstants.bookingDateLabel,
                value: AppConstants.bookingTodayAt,
              ),
              const SizedBox(height: 16),
              _DetailItem(
                icon: Symbols.location_on,
                label: AppConstants.bookingLocationLabel,
                value: AppConstants.bookingLocationValue,
              ),
              const Spacer(),
              ElevatedButton(
                onPressed: () => context.go('/home'),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 56),
                ),
                child: const Text(AppConstants.bookingReturnHome),
              ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: () {}, // Navigate to reservation details
                child: Text(
                  AppConstants.bookingViewTicket,
                  style: TextStyle(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

class _DetailItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _DetailItem({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white10),
      ),
      child: Row(
        children: [
          Icon(icon, color: theme.colorScheme.primary, size: 24),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(color: Colors.white54, fontSize: 10),
              ),
              Text(
                value,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
