import 'package:bourgo_arena_mobile/core/theme/bourgo_theme.dart';
import 'package:flutter/material.dart';

/// Border radius tokens used across all cards.
enum AppCardRadius {
  /// 24px — standard card (profiles, sections, dashboards).
  standard(24),

  /// 16px — compact card (transaction items, list tiles).
  compact(16),

  /// 12px — small card (badges, chips, inline elements).
  small(12);

  final double value;
  const AppCardRadius(this.value);
}

/// A foundational card component with enforced design tokens.
///
/// Replaces all inline [Container] + [appColors.bgElevated] /
/// [appColors.bgBorder] patterns across the app.
class AppCard extends StatelessWidget {
  final Widget child;
  final AppCardRadius radius;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry margin;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final Gradient? gradient;
  final bool hasBorder;
  final bool hasShadow;
  final Color? color;
  final Color? borderColor;

  const AppCard({
    super.key,
    required this.child,
    this.radius = AppCardRadius.standard,
    this.padding = const EdgeInsets.all(24),
    this.margin = EdgeInsets.zero,
    this.onTap,
    this.onLongPress,
    this.gradient,
    this.hasBorder = true,
    this.hasShadow = false,
    this.color,
    this.borderColor,
  });

  /// Gradient variant — used for hero/promotional cards.
  factory AppCard.gradient({
    Key? key,
    required Widget child,
    required Gradient gradient,
    VoidCallback? onTap,
    EdgeInsetsGeometry padding = const EdgeInsets.all(24),
  }) {
    return AppCard(
      key: key,
      gradient: gradient,
      hasBorder: false,
      padding: padding,
      onTap: onTap,
      child: child,
    );
  }

  /// Compact variant — used for transaction items, list rows.
  factory AppCard.compact({
    Key? key,
    required Widget child,
    VoidCallback? onTap,
    EdgeInsetsGeometry padding = const EdgeInsets.all(16),
    EdgeInsetsGeometry margin = EdgeInsets.zero,
  }) {
    return AppCard(
      key: key,
      radius: AppCardRadius.compact,
      padding: padding,
      margin: margin,
      onTap: onTap,
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = theme.extension<AppColors>()!;

    final effectiveColor = color ?? appColors.bgElevated;
    final effectiveBorderColor = borderColor ?? appColors.bgBorder;

    final card = Container(
      margin: margin,
      padding: padding,
      decoration: BoxDecoration(
        gradient: gradient,
        color: gradient != null ? null : effectiveColor,
        border: hasBorder && gradient == null
            ? Border.all(color: effectiveBorderColor)
            : null,
        borderRadius: BorderRadius.circular(radius.value),
        boxShadow: hasShadow
            ? [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.08),
                  blurRadius: 20,
                  offset: const Offset(0, 4),
                ),
              ]
            : null,
      ),
      child: child,
    );

    if (onTap != null || onLongPress != null) {
      return GestureDetector(
        onTap: onTap,
        onLongPress: onLongPress,
        child: card,
      );
    }
    return card;
  }
}
