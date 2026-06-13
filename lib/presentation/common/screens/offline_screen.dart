import 'package:bourgo_arena_mobile/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class OfflineScreen extends StatefulWidget {
  const OfflineScreen({super.key});

  @override
  State<OfflineScreen> createState() => _OfflineScreenState();
}

class _OfflineScreenState extends State<OfflineScreen> {
  bool _isChecking = false;

  Future<void> _checkConnection() async {
    setState(() {
      _isChecking = true;
    });

    // Simulate a brief delay for UI feedback
    await Future.delayed(const Duration(milliseconds: 800));

    await Connectivity().checkConnectivity();

    if (mounted) {
      setState(() {
        _isChecking = false;
      });

      // The wrapper will automatically hide this screen if the connection is restored,
      // but we update the state here just to end the checking animation.
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Animated Icon
                Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: colorScheme.errorContainer.withValues(alpha: 0.3),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Symbols.wifi_off_rounded,
                        size: 80,
                        color: colorScheme.error,
                      ),
                    )
                    .animate(
                      onPlay: (controller) => controller.repeat(reverse: true),
                    )
                    .scale(
                      duration: 2.seconds,
                      begin: const Offset(0.95, 0.95),
                      end: const Offset(1.05, 1.05),
                      curve: Curves.easeInOut,
                    )
                    .fade(duration: 1.seconds),
                const SizedBox(height: 40),

                // Title
                Text(
                  l10n.offlineTitle,
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                  ),
                  textAlign: TextAlign.center,
                ).animate().slideY(begin: 0.2, duration: 400.ms).fadeIn(),

                const SizedBox(height: 16),

                // Subtitle
                Text(
                      l10n.offlineSubtitle,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                        height: 1.5,
                      ),
                      textAlign: TextAlign.center,
                    )
                    .animate()
                    .slideY(begin: 0.2, delay: 100.ms, duration: 400.ms)
                    .fadeIn(),

                const SizedBox(height: 48),

                // Retry Button
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: FilledButton.icon(
                    onPressed: _isChecking ? null : _checkConnection,
                    icon: _isChecking
                        ? SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.5,
                              color: colorScheme.onPrimary,
                            ),
                          )
                        : const Icon(Symbols.refresh_rounded),
                    label: Text(
                      _isChecking ? '' : l10n.offlineRetryButton,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: FilledButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  ),
                ).animate().scale(
                  delay: 200.ms,
                  duration: 400.ms,
                  curve: Curves.easeOutBack,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
