import 'package:bourgo_arena_mobile/core/theme/bourgo_theme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// A standardized list item row with icon, title, subtitle, and optional
/// trailing widget or chevron.
///
/// Replaces inline [Container] + [Row] list tile patterns across the app
/// (Profile menu items, Settings tiles, transaction rows, etc.).
class AppListItem extends StatelessWidget {
  final IconData leadingIcon;
  final String title;
  final String? subtitle;
  final String? trailingText;
  final Widget? trailing;
  final VoidCallback? onTap;
  final bool isDestructive;
  final bool showChevron;
  final bool showDivider;

  const AppListItem({
    super.key,
    required this.leadingIcon,
    required this.title,
    this.subtitle,
    this.trailingText,
    this.trailing,
    this.onTap,
    this.isDestructive = false,
    this.showChevron = true,
    this.showDivider = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = theme.extension<AppColors>()!;
    final spacing = context.spacing;

    final baseColor =
        isDestructive ? theme.colorScheme.error : theme.colorScheme.onSurface;

    final row = Container(
      padding: EdgeInsets.all(spacing.md),
      decoration: BoxDecoration(
        color: appColors.bgElevated.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDestructive
              ? theme.colorScheme.error.withValues(alpha: 0.1)
              : appColors.bgBorder.withValues(alpha: 0.5),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(spacing.sm),
            decoration: BoxDecoration(
              color: isDestructive
                  ? theme.colorScheme.error.withValues(alpha: 0.1)
                  : theme.colorScheme.primary.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              leadingIcon,
              color: isDestructive
                  ? theme.colorScheme.error
                  : theme.colorScheme.primary,
              size: 20,
            ),
          ),
          SizedBox(width: spacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: baseColor,
                    fontFamily: GoogleFonts.lexend().fontFamily,
                  ),
                ),
                if (subtitle != null) ...[
                  SizedBox(height: spacing.xxs),
                  Text(
                    subtitle!,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant
                          .withValues(alpha: 0.7),
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (trailingText != null)
            Text(
              trailingText!,
              style: theme.textTheme.labelMedium?.copyWith(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.w700,
              ),
            ),
          trailing ??
              (showChevron
                  ? Icon(
                      Icons.chevron_right_rounded,
                      color: theme.colorScheme.onSurface
                          .withValues(alpha: 0.2),
                      size: 20,
                    )
                  : const SizedBox.shrink()),
        ],
      ),
    );

    if (onTap != null) {
      return Padding(
        padding: EdgeInsets.symmetric(vertical: spacing.xs),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: row,
        ),
      );
    }

    return Padding(
      padding: EdgeInsets.symmetric(vertical: spacing.xs),
      child: row,
    );
  }
}
