import 'package:bourgo_arena_mobile/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:bourgo_arena_mobile/core/constants/app_constants.dart';
import 'package:bourgo_arena_mobile/core/utils/haptic_utils.dart';
import 'dart:ui';

/// Shows a high-fidelity modal indicating authentication is required to proceed.
Future<void> showAuthRequiredModal(BuildContext context) async {
  final l10n = AppLocalizations.of(context)!;
  final theme = Theme.of(context);

  await showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    barrierColor: theme.colorScheme.scrim.withValues(alpha: 0.6),
    builder: (context) {
      return BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: Container(
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
            boxShadow: [
              BoxShadow(
                color: theme.colorScheme.shadow.withValues(alpha: 0.1),
                blurRadius: 20,
                offset: const Offset(0, -5),
              ),
            ],
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 48,
                    height: 4,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.onSurfaceVariant.withValues(
                        alpha: 0.2,
                      ),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Icon
                  Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primary.withValues(
                            alpha: 0.1,
                          ),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Symbols.lock,
                          size: 40,
                          color: theme.colorScheme.primary,
                        ),
                      )
                      .animate(
                        onPlay: (controller) =>
                            controller.repeat(reverse: true),
                      )
                      .scale(
                        begin: const Offset(1, 1),
                        end: const Offset(1.05, 1.05),
                        duration: 2.seconds,
                        curve: Curves.easeInOut,
                      )
                      .animate()
                      .fade(duration: 400.ms)
                      .scale(
                        begin: const Offset(0.8, 0.8),
                        curve: Curves.easeOutBack,
                      ),

                  const SizedBox(height: 24),

                  // Title
                  Text(
                        l10n.authLoginTitle.toUpperCase(),
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontFamily: AppConstants.displayFontFamily,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 1,
                          color: theme.colorScheme.onSurface,
                        ),
                        textAlign: TextAlign.center,
                      )
                      .animate()
                      .fade(delay: 100.ms, duration: 400.ms)
                      .slideY(begin: 0.1, curve: Curves.easeOutQuad),

                  const SizedBox(height: 12),

                  // Subtitle
                  Text(
                        l10n.authLoginSubtitle,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                          height: 1.5,
                        ),
                        textAlign: TextAlign.center,
                      )
                      .animate()
                      .fade(delay: 200.ms, duration: 400.ms)
                      .slideY(begin: 0.1, curve: Curves.easeOutQuad),

                  const SizedBox(height: 32),

                  // Login Button
                  SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton(
                          onPressed: () {
                            AppHaptics.selection();
                            Navigator.pop(context);
                            context.push('/login');
                          },
                          style: ElevatedButton.styleFrom(
                            elevation: 0,
                            backgroundColor: theme.colorScheme.primary,
                            foregroundColor: theme.colorScheme.onPrimary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: Text(
                            l10n.authLogin.toUpperCase(),
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 1.2,
                            ),
                          ),
                        ),
                      )
                      .animate()
                      .fade(delay: 300.ms, duration: 400.ms)
                      .slideY(begin: 0.1, curve: Curves.easeOutQuad),

                  const SizedBox(height: 16),

                  // Register Button
                  SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: OutlinedButton(
                          onPressed: () {
                            AppHaptics.selection();
                            Navigator.pop(context);
                            context.push('/register');
                          },
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(
                              color: theme.colorScheme.primary.withValues(
                                alpha: 0.5,
                              ),
                              width: 2,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: Text(
                            l10n.authRegister.toUpperCase(),
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 1.2,
                              color: theme.colorScheme.primary,
                            ),
                          ),
                        ),
                      )
                      .animate()
                      .fade(delay: 400.ms, duration: 400.ms)
                      .slideY(begin: 0.1, curve: Curves.easeOutQuad),

                  const SizedBox(height: 24),

                  // Do It Later
                  TextButton(
                    onPressed: () {
                      AppHaptics.light();
                      Navigator.pop(context);
                    },
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                    ),
                    child: Text(
                      l10n.authDoItLater,
                      style: TextStyle(
                        color: theme.colorScheme.onSurfaceVariant,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ).animate().fade(delay: 500.ms, duration: 400.ms),
                ],
              ),
            ),
          ),
        ),
      );
    },
  );
}
