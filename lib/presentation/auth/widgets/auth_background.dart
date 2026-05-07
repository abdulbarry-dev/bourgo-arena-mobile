import 'package:flutter/material.dart';

/// A premium background widget for authentication and onboarding screens.
///
/// Provides a consistent linear gradient and a subtle grid pattern overlay.
class AuthBackground extends StatelessWidget {
  /// The content to display on top of the background.
  final Widget child;

  /// Whether to show the grid pattern.
  final bool showGrid;

  /// Creates an [AuthBackground].
  const AuthBackground({super.key, required this.child, this.showGrid = true});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Stack(
      children: [
        // Background Gradient
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                theme.colorScheme.surfaceContainerLow,
                theme.colorScheme.surfaceContainerHigh,
              ],
            ),
          ),
        ),

        // Grid Pattern Overlay
        if (showGrid)
          Opacity(
            opacity: theme.brightness == Brightness.light ? 0.05 : 0.03,
            child: CustomPaint(
              size: Size.infinite,
              painter: _GridPainter(color: theme.colorScheme.onSurface),
            ),
          ),

        // Content
        child,
      ],
    );
  }
}

class _GridPainter extends CustomPainter {
  final Color color;

  _GridPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.0;

    const spacing = 40.0;

    for (var i = 0.0; i < size.width; i += spacing) {
      canvas.drawLine(Offset(i, 0), Offset(i, size.height), paint);
    }

    for (var i = 0.0; i < size.height; i += spacing) {
      canvas.drawLine(Offset(0, i), Offset(size.width, i), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
