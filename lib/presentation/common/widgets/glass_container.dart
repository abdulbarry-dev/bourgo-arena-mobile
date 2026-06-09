import 'dart:ui';
import 'package:flutter/material.dart';

class GlassContainer extends StatelessWidget {
  final Widget child;
  final double blur;
  final BorderRadiusGeometry? borderRadius;
  final Color? tintColor;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final AlignmentGeometry gradientBegin;
  final AlignmentGeometry gradientEnd;

  const GlassContainer({
    super.key,
    required this.child,
    this.blur = 5.0,
    this.borderRadius,
    this.tintColor,
    this.height,
    this.padding,
    this.gradientBegin = Alignment.topLeft,
    this.gradientEnd = Alignment.bottomRight,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final effectiveRadius = borderRadius ?? BorderRadius.circular(24);

    return ClipRRect(
      borderRadius: effectiveRadius,
      child: Stack(
        children: [
          child,
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
              child: Container(
                height: height,
                padding: padding,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: gradientBegin,
                    end: gradientEnd,
                    colors: [
                      (tintColor ?? theme.colorScheme.surface)
                          .withValues(alpha: 0.85),
                      (tintColor ?? theme.colorScheme.surface)
                          .withValues(alpha: 0.95),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
