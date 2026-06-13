import 'package:bourgo_arena_mobile/core/constants/app_constants.dart';
import 'package:bourgo_arena_mobile/core/theme/bourgo_theme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:bourgo_arena_mobile/core/utils/haptic_utils.dart';
import 'package:bourgo_arena_mobile/core/config/app_config.dart';

/// A premium, professional error state widget.
/// Used to display a high-quality feedback when an operation fails.
class PremiumErrorState extends StatelessWidget {
  /// The main title of the error state.
  final String title;

  /// Detailed message explaining the failure or next steps.
  final String message;

  /// The icon to display above the text. Defaults to [Symbols.error].
  final IconData icon;

  /// Label for the retry button.
  final String actionLabel;

  /// Callback for the retry action.
  final VoidCallback onRetry;

  const PremiumErrorState({
    super.key,
    required this.title,
    required this.message,
    this.icon = Symbols.error,
    required this.actionLabel,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = context.spacing;

    return Center(
      child: Padding(
        padding: spacing.horizontalPadding(context),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Brand-Integrated Icon Container
            Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: theme.colorScheme.error.withValues(alpha: 0.05),
                      ),
                    ),
                    Container(
                      width: 90,
                      height: 90,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            theme.colorScheme.error.withValues(alpha: 0.15),
                            theme.colorScheme.error.withValues(alpha: 0.08),
                          ],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: theme.colorScheme.error.withValues(
                              alpha: 0.1,
                            ),
                            blurRadius: 30,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: Icon(
                        icon,
                        size: 36,
                        color: theme.colorScheme.error,
                      ),
                    ),
                  ],
                )
                .animate(
                  onPlay: AppConfig.isTest
                      ? null
                      : (controller) => controller.repeat(reverse: true),
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

            SizedBox(height: spacing.xl),
            // High-Impact Display Title
            Text(
                  title.toUpperCase(),
                  textAlign: TextAlign.center,
                  style: theme.textTheme.displaySmall?.copyWith(
                    fontFamily: AppConstants.displayFontFamily,
                    fontWeight: FontWeight.w900,
                    letterSpacing: -1.0,
                    fontSize: 24,
                    color: theme.colorScheme.onSurface,
                  ),
                )
                .animate()
                .fade(delay: 100.ms, duration: 400.ms)
                .slideY(begin: 0.1, curve: Curves.easeOutQuad),

            SizedBox(height: spacing.sm),
            // Technical Metadata Description
            ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 280),
                  child: Text(
                    message,
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant.withValues(
                        alpha: 0.6,
                      ),
                      height: 1.5,
                      fontFamily: GoogleFonts.lexend().fontFamily,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                )
                .animate()
                .fade(delay: 200.ms, duration: 400.ms)
                .slideY(begin: 0.1, curve: Curves.easeOutQuad),

            SizedBox(height: spacing.xxl),
            // Primary Brand Action Button
            SizedBox(
                  width: 220,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      AppHaptics.selection();
                      onRetry();
                    },
                    icon: const Icon(Symbols.refresh, size: 20),
                    label: Text(actionLabel.toUpperCase()),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.colorScheme.primary,
                      foregroundColor: theme.colorScheme.onPrimary,
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      elevation: 12,
                      shadowColor: theme.colorScheme.primary.withValues(
                        alpha: 0.4,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      textStyle: TextStyle(
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1.5,
                        fontSize: 13,
                        fontFamily: GoogleFonts.lexend().fontFamily,
                      ),
                    ),
                  ),
                )
                .animate()
                .fade(delay: 300.ms, duration: 400.ms)
                .slideY(begin: 0.1, curve: Curves.easeOutQuad),
          ],
        ),
      ),
    );
  }
}
