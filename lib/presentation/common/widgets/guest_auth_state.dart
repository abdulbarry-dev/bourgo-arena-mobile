import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:bourgo_arena_mobile/l10n/app_localizations.dart';
import 'package:bourgo_arena_mobile/core/constants/app_constants.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:bourgo_arena_mobile/core/utils/haptic_utils.dart';

class GuestAuthState extends StatelessWidget {
  final IconData icon;
  final String? subtitle;

  const GuestAuthState({super.key, this.icon = Symbols.person, this.subtitle});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final displaySubtitle = subtitle ?? l10n.authLoginSubtitle;

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icon with glowing effect
            Container(
                  width: 140,
                  height: 140,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: theme.colorScheme.primary.withValues(alpha: 0.05),
                    boxShadow: [
                      BoxShadow(
                        color: theme.colorScheme.primary.withValues(alpha: 0.1),
                        blurRadius: 40,
                        spreadRadius: 10,
                      ),
                    ],
                    border: Border.all(
                      color: theme.colorScheme.primary.withValues(alpha: 0.2),
                      width: 2,
                    ),
                  ),
                  child: Center(
                    child: Icon(
                      icon,
                      size: 64,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                )
                .animate(
                  onPlay: (controller) => controller.repeat(reverse: true),
                )
                .scale(
                  begin: const Offset(1, 1),
                  end: const Offset(1.05, 1.05),
                  duration: 2.seconds,
                  curve: Curves.easeInOut,
                )
                .animate()
                .fade(duration: 600.ms)
                .slideY(begin: 0.1, curve: Curves.easeOutQuad),

            const SizedBox(height: 40),

            Text(
                  l10n.authLoginTitle.toUpperCase(),
                  textAlign: TextAlign.center,
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontFamily: AppConstants.displayFontFamily,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.5,
                    color: theme.colorScheme.onSurface,
                  ),
                )
                .animate()
                .fade(delay: 200.ms, duration: 600.ms)
                .slideY(begin: 0.1, curve: Curves.easeOutQuad),

            const SizedBox(height: 16),

            Text(
                  displaySubtitle,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                    height: 1.5,
                  ),
                )
                .animate()
                .fade(delay: 300.ms, duration: 600.ms)
                .slideY(begin: 0.1, curve: Curves.easeOutQuad),

            const SizedBox(height: 48),

            SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: () {
                      AppHaptics.selection();
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
                .fade(delay: 400.ms, duration: 600.ms)
                .slideY(begin: 0.1, curve: Curves.easeOutQuad),

            const SizedBox(height: 16),

            SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: OutlinedButton(
                    onPressed: () {
                      AppHaptics.selection();
                      context.push('/register');
                    },
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(
                        color: theme.colorScheme.primary.withValues(alpha: 0.5),
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
                .fade(delay: 500.ms, duration: 600.ms)
                .slideY(begin: 0.1, curve: Curves.easeOutQuad),
          ],
        ),
      ),
    );
  }
}
