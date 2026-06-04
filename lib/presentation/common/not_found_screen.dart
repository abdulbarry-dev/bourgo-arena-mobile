import 'package:bourgo_arena_mobile/core/theme/bourgo_theme.dart';
import 'package:bourgo_arena_mobile/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';

/// Displayed by GoRouter's [errorBuilder] whenever an unknown or
/// invalid route is requested.
///
/// Provides a clear call-to-action that returns the user to [/home]
/// so they are never stranded on a dead end.
class NotFoundScreen extends StatelessWidget {
  /// The underlying [GoException] supplied by GoRouter (may be null).
  final Exception? error;

  /// Creates a [NotFoundScreen].
  const NotFoundScreen({super.key, this.error});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final spacing = context.spacing;
    final minHeight =
        MediaQuery.sizeOf(context).height -
        MediaQuery.paddingOf(context).vertical;

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: spacing.horizontalValueFor(context),
            vertical: spacing.screenVertical,
          ),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: minHeight),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 480),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _IconBadge(theme: theme),
                    SizedBox(height: spacing.xl),
                    Text(
                      l10n.errorNotFoundTitle,
                      textAlign: TextAlign.center,
                      style: theme.textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1.5,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                    SizedBox(height: spacing.md),
                    Text(
                      l10n.errorNotFoundSubtitle,
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant.withAlpha(
                          180,
                        ),
                        height: 1.6,
                      ),
                    ),
                    SizedBox(height: spacing.xxl),
                    FilledButton.icon(
                      onPressed: () {
                        try {
                          GoRouter.of(context).go('/home');
                        } catch (_) {
                          GoRouter.of(context).go('/');
                        }
                      },
                      icon: const Icon(Symbols.home, size: 20),
                      label: Text(l10n.errorNotFoundAction),
                      style: FilledButton.styleFrom(
                        padding: EdgeInsets.symmetric(
                          horizontal: spacing.xl,
                          vertical: spacing.md,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Animated icon badge shown on the [NotFoundScreen].
class _IconBadge extends StatelessWidget {
  final ThemeData theme;

  const _IconBadge({required this.theme});

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 700),
      curve: Curves.elasticOut,
      builder: (context, value, child) {
        return Transform.scale(scale: value, child: child);
      },
      child: Container(
        width: 120,
        height: 120,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: theme.colorScheme.errorContainer.withAlpha(60),
        ),
        child: Icon(
          Symbols.error_outline,
          size: 60,
          color: theme.colorScheme.error.withAlpha(180),
        ),
      ),
    );
  }
}
