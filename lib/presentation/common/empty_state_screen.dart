import 'package:bourgo_arena_mobile/core/theme/bourgo_theme.dart';
import 'package:bourgo_arena_mobile/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

/// A generic, high-fidelity empty state screen.
class EmptyStateScreen extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final String? actionLabel;
  final VoidCallback? onAction;

  const EmptyStateScreen({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    this.actionLabel,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = context.spacing;
    final minHeight =
        MediaQuery.sizeOf(context).height -
        MediaQuery.paddingOf(context).vertical;

    return Scaffold(
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
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: theme.colorScheme.surfaceContainer,
                      ),
                      child: Icon(
                        icon,
                        size: 56,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                    SizedBox(height: spacing.xl),
                    Text(
                      title,
                      textAlign: TextAlign.center,
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
                      ),
                    ),
                    SizedBox(height: spacing.sm),
                    Text(
                      subtitle,
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                        height: 1.5,
                      ),
                    ),
                    if (actionLabel != null && onAction != null) ...[
                      SizedBox(height: spacing.xxl),
                      ElevatedButton(
                        onPressed: onAction,
                        child: Text(actionLabel ?? ''),
                      ),
                    ],
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

/// Convenience screen for "No results found"
class NoResultsScreen extends StatelessWidget {
  const NoResultsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return EmptyStateScreen(
      title: AppLocalizations.of(context)!.commonNoResults,
      subtitle: AppLocalizations.of(context)!.commonNoResultsSubtitle,
      icon: Symbols.search_off,
    );
  }
}
