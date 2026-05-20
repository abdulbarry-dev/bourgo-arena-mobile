import 'package:bourgo_arena_mobile/core/theme/bourgo_theme.dart';
import 'package:flutter/material.dart';

/// Declarative action configuration for [AppModal].
class AppModalAction {
  const AppModalAction({
    required this.label,
    required this.onPressed,
    this.isPrimary = false,
    this.isDestructive = false,
  });

  final String label;
  final VoidCallback onPressed;
  final bool isPrimary;
  final bool isDestructive;
}

/// A consistent, theme-aware modal container used across the app.
class AppModal extends StatelessWidget {
  const AppModal({
    super.key,
    required this.title,
    required this.content,
    this.subtitle,
    this.icon,
    this.actions = const <AppModalAction>[],
    this.actionWidgets,
    this.showCloseButton = false,
  });

  final String title;
  final String? subtitle;
  final Widget content;
  final IconData? icon;
  final List<AppModalAction> actions;
  final List<Widget>? actionWidgets;
  final bool showCloseButton;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = context.spacing;
    final appColors = theme.extension<AppColors>();

    return AlertDialog(
      backgroundColor: appColors?.bgElevated,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      insetPadding: EdgeInsets.symmetric(horizontal: spacing.lg),
      titlePadding: EdgeInsets.fromLTRB(
        spacing.lg,
        spacing.lg,
        spacing.lg,
        spacing.sm,
      ),
      contentPadding: EdgeInsets.fromLTRB(
        spacing.lg,
        spacing.xs,
        spacing.lg,
        spacing.lg,
      ),
      actionsPadding: EdgeInsets.fromLTRB(
        spacing.lg,
        0,
        spacing.lg,
        spacing.lg,
      ),
      title: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (icon != null) ...[
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, size: 20, color: theme.colorScheme.primary),
            ),
            SizedBox(width: spacing.sm),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                if (subtitle != null) ...[
                  SizedBox(height: spacing.xs),
                  Text(
                    subtitle!,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (showCloseButton)
            IconButton(
              onPressed: () => Navigator.of(context).pop(),
              icon: const Icon(Icons.close),
              visualDensity: VisualDensity.compact,
              color: theme.colorScheme.onSurfaceVariant,
              tooltip: MaterialLocalizations.of(context).closeButtonTooltip,
            ),
        ],
      ),
      content: content,
      actions:
          actionWidgets ??
          (actions.isEmpty
              ? null
              : actions
                    .map(
                      (action) => action.isPrimary
                          ? ElevatedButton(
                              onPressed: action.onPressed,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: action.isDestructive
                                    ? theme.colorScheme.error
                                    : null,
                                foregroundColor: action.isDestructive
                                    ? theme.colorScheme.onError
                                    : null,
                                minimumSize: Size(120, spacing.xl),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: Text(action.label),
                            )
                          : TextButton(
                              onPressed: action.onPressed,
                              style: TextButton.styleFrom(
                                foregroundColor: action.isDestructive
                                    ? theme.colorScheme.error
                                    : null,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: Text(action.label),
                            ),
                    )
                    .toList()),
    );
  }
}
