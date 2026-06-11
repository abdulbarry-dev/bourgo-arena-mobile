import 'dart:ui';

import 'package:flutter/material.dart';

/// Spacing tokens for Bourgo Arena.
class AppSpacing extends ThemeExtension<AppSpacing> {
  final double xxs;
  final double xs;
  final double sm;
  final double md;
  final double lg;
  final double xl;
  final double xxl;
  final double xxxl;
  final double screenHorizontal;
  final double screenHorizontalCompact;
  final double screenVertical;

  const AppSpacing({
    required this.xxs,
    required this.xs,
    required this.sm,
    required this.md,
    required this.lg,
    required this.xl,
    required this.xxl,
    required this.xxxl,
    required this.screenHorizontal,
    required this.screenHorizontalCompact,
    required this.screenVertical,
  });

  static const AppSpacing standard = AppSpacing(
    xxs: 4,
    xs: 8,
    sm: 12,
    md: 16,
    lg: 24,
    xl: 32,
    xxl: 40,
    xxxl: 48,
    screenHorizontal: 24,
    screenHorizontalCompact: 16,
    screenVertical: 24,
  );

  double horizontalValueFor(BuildContext context) {
    return MediaQuery.sizeOf(context).width < 360
        ? screenHorizontalCompact
        : screenHorizontal;
  }

  EdgeInsets screenPadding(BuildContext context) {
    final horizontal = horizontalValueFor(context);
    final bottomInset = MediaQuery.viewInsetsOf(context).bottom;

    return EdgeInsets.fromLTRB(
      horizontal,
      screenVertical,
      horizontal,
      screenVertical + bottomInset,
    );
  }

  EdgeInsets horizontalPadding(BuildContext context) {
    return EdgeInsets.symmetric(horizontal: horizontalValueFor(context));
  }

  EdgeInsets all(double value) => EdgeInsets.all(value);

  EdgeInsets symmetric({double horizontal = 0, double vertical = 0}) {
    return EdgeInsets.symmetric(horizontal: horizontal, vertical: vertical);
  }

  @override
  ThemeExtension<AppSpacing> copyWith({
    double? xxs,
    double? xs,
    double? sm,
    double? md,
    double? lg,
    double? xl,
    double? xxl,
    double? xxxl,
    double? screenHorizontal,
    double? screenHorizontalCompact,
    double? screenVertical,
  }) {
    return AppSpacing(
      xxs: xxs ?? this.xxs,
      xs: xs ?? this.xs,
      sm: sm ?? this.sm,
      md: md ?? this.md,
      lg: lg ?? this.lg,
      xl: xl ?? this.xl,
      xxl: xxl ?? this.xxl,
      xxxl: xxxl ?? this.xxxl,
      screenHorizontal: screenHorizontal ?? this.screenHorizontal,
      screenHorizontalCompact:
          screenHorizontalCompact ?? this.screenHorizontalCompact,
      screenVertical: screenVertical ?? this.screenVertical,
    );
  }

  @override
  ThemeExtension<AppSpacing> lerp(ThemeExtension<AppSpacing>? other, double t) {
    if (other is! AppSpacing) return this;
    return AppSpacing(
      xxs: lerpDouble(xxs, other.xxs, t) ?? xxs,
      xs: lerpDouble(xs, other.xs, t) ?? xs,
      sm: lerpDouble(sm, other.sm, t) ?? sm,
      md: lerpDouble(md, other.md, t) ?? md,
      lg: lerpDouble(lg, other.lg, t) ?? lg,
      xl: lerpDouble(xl, other.xl, t) ?? xl,
      xxl: lerpDouble(xxl, other.xxl, t) ?? xxl,
      xxxl: lerpDouble(xxxl, other.xxxl, t) ?? xxxl,
      screenHorizontal:
          lerpDouble(screenHorizontal, other.screenHorizontal, t) ??
          screenHorizontal,
      screenHorizontalCompact:
          lerpDouble(
            screenHorizontalCompact,
            other.screenHorizontalCompact,
            t,
          ) ??
          screenHorizontalCompact,
      screenVertical:
          lerpDouble(screenVertical, other.screenVertical, t) ?? screenVertical,
    );
  }
}

extension AppSpacingContext on BuildContext {
  AppSpacing get spacing =>
      Theme.of(this).extension<AppSpacing>() ?? AppSpacing.standard;
}
