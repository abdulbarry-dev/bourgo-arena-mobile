import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

/// Reusable shimmer skeleton with standardized colors.
///
/// Replaces all inline [Shimmer.fromColors] patterns across the app.
class AppShimmer extends StatelessWidget {
  final Widget child;

  const AppShimmer({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Shimmer.fromColors(
      baseColor: theme.colorScheme.surfaceContainerHighest,
      highlightColor:
          theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.4),
      child: SingleChildScrollView(child: child),
    );
  }

  /// Convenience: a rounded rectangle skeleton block.
  static Widget block({
    double? width,
    double height = 14,
    double borderRadius = 8,
  }) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
      ),
    );
  }

  /// Convenience: a row of skeleton blocks with configurable spacing.
  static Widget row({
    required List<double?> widths,
    double height = 14,
    double spacing = 12,
  }) {
    return Row(
      children: widths.map((w) {
        return Padding(
          padding: EdgeInsets.only(right: spacing),
          child: block(width: w, height: height),
        );
      }).toList(),
    );
  }

  /// Convenience: a large card skeleton (e.g., for profile, points cards).
  static Widget card({
    double height = 120,
    double width = double.infinity,
    double borderRadius = 24,
    EdgeInsetsGeometry padding = const EdgeInsets.all(24),
  }) {
    return Container(
      width: width,
      height: height,
      padding: padding,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          block(width: 80, height: 20, borderRadius: 8),
          const SizedBox(height: 16),
          block(width: 200, height: 40, borderRadius: 8),
        ],
      ),
    );
  }

  /// Convenience: a circular skeleton (avatar, icon).
  static Widget circle({double size = 44}) {
    return Container(
      width: size,
      height: size,
      decoration: const BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
      ),
    );
  }
}
