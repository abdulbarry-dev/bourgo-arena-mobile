import 'package:bourgo_arena_mobile/core/constants/app_constants.dart';
import 'package:bourgo_arena_mobile/core/theme/bourgo_theme.dart';
import 'package:flutter/material.dart';

/// A reusable section header with an optional icon, accent color, and
/// trailing action button.
///
/// Replaces all inline section title / `_SectionHeader` patterns across
/// the app.
class AppSectionHeader extends StatelessWidget {
  final String title;
  final IconData? icon;
  final Color? accentColor;
  final String? actionLabel;
  final VoidCallback? onActionTap;

  const AppSectionHeader({
    super.key,
    required this.title,
    this.icon,
    this.accentColor,
    this.actionLabel,
    this.onActionTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = context.spacing;

    return Row(
      children: [
        if (icon != null) ...[
          Icon(icon, size: 18, color: accentColor ?? theme.colorScheme.primary),
          SizedBox(width: spacing.xs),
        ],
        Expanded(
          child: Text(
            title.toUpperCase(),
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
              fontFamily: AppConstants.displayFontFamily,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.5,
            ),
          ),
        ),
        if (onActionTap != null && actionLabel != null)
          InkWell(
            onTap: onActionTap,
            borderRadius: BorderRadius.circular(8),
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: spacing.sm,
                vertical: spacing.xxs,
              ),
              child: Text(
                actionLabel!,
                style: theme.textTheme.labelSmall?.copyWith(
                  color: accentColor ?? theme.colorScheme.primary,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.0,
                ),
              ),
            ),
          ),
      ],
    );
  }
}

/// A minimal label-only section title — used when no icon or action is
/// needed.
///
/// Replaces the `_buildSectionTitle` pattern from the Loyalty Dashboard.
class AppSectionLabel extends StatelessWidget {
  final String title;

  const AppSectionLabel({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Text(
      title.toUpperCase(),
      style: theme.textTheme.labelSmall?.copyWith(
        color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
        fontWeight: FontWeight.bold,
        letterSpacing: 1.5,
      ),
    );
  }
}
