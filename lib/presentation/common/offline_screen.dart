import 'package:bourgo_arena_mobile/core/constants/app_constants.dart';
import 'package:bourgo_arena_mobile/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

/// High-fidelity screen displayed when the device is offline.
class OfflineScreen extends StatelessWidget {
  const OfflineScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 48),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              Container(
                width: 160,
                height: 160,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.redAccent.withAlpha(20),
                ),
                child: const Icon(
                  Symbols.wifi_off,
                  size: 80,
                  color: Colors.redAccent,
                ),
              ),
              const SizedBox(height: 48),
              Text(
                AppLocalizations.of(context)!.commonOfflineTitle,
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontFamily: AppConstants.displayFontFamily,
                  letterSpacing: 2,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                AppLocalizations.of(context)!.commonOfflineSubtitle,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white54,
                  fontSize: 16,
                  height: 1.5,
                ),
              ),
              const Spacer(),
              ElevatedButton(
                onPressed: () {}, // Retry logic would go here
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 56),
                ),
                child: Text(AppLocalizations.of(context)!.commonRetry),
              ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: () {},
                child: Text(
                  AppLocalizations.of(context)!.commonOfflineAccess,
                  style: TextStyle(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                    fontSize: 12,
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
