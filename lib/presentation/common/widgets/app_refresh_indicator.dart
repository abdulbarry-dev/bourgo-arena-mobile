import 'package:flutter/material.dart';

class AppRefreshIndicator extends StatelessWidget {
  final Future<void> Function() onRefresh;
  final Widget child;
  final String? message;
  final double displacement;
  final double strokeWidth;

  const AppRefreshIndicator({
    super.key,
    required this.onRefresh,
    required this.child,
    this.message,
    this.displacement = 60.0,
    this.strokeWidth = 2.5,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return RefreshIndicator(
      onRefresh: onRefresh,
      color: theme.colorScheme.primary,
      backgroundColor: theme.colorScheme.surface,
      strokeWidth: strokeWidth,
      displacement: displacement,
      child: message != null
          ? CustomScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: [
                SliverFillRemaining(hasScrollBody: false, child: child),
              ],
            )
          : child,
    );
  }
}
