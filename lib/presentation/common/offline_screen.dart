import 'package:bourgo_arena_mobile/core/theme/bourgo_theme.dart';
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
    final spacing = context.spacing;

    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: spacing.horizontalValueFor(context),
                vertical: spacing.screenVertical,
              ),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 480),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 160,
                          height: 160,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: theme.colorScheme.errorContainer,
                          ),
                          child: Icon(
                            Symbols.wifi_off,
                            size: 80,
                            color: theme.colorScheme.error,
                          ),
                        ),
                        SizedBox(height: spacing.xxl),
                        Text(
                          AppLocalizations.of(context)!.commonOfflineTitle,
                          style: theme.textTheme.headlineSmall?.copyWith(
                            fontFamily: AppConstants.displayFontFamily,
                            letterSpacing: 2,
                            color: theme.colorScheme.onSurface,
                          ),
                        ),
                        SizedBox(height: spacing.md),
                        Text(
                          AppLocalizations.of(context)!.commonOfflineSubtitle,
                          textAlign: TextAlign.center,
                          style: theme.textTheme.bodyLarge?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                            height: 1.5,
                          ),
                        ),
                        SizedBox(height: spacing.xxl),
                        ElevatedButton(
                          onPressed: () {}, // Retry logic would go here
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size(double.infinity, 56),
                          ),
                          child: Text(
                            AppLocalizations.of(context)!.commonRetry,
                          ),
                        ),
                        SizedBox(height: spacing.sm),
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
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
