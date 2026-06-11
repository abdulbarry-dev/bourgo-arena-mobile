import 'package:flutter/material.dart';

/// Custom color tokens for Bourgo Arena.
class AppColors extends ThemeExtension<AppColors> {
  final Color brandPrimaryGhost;
  final Color brandPrimaryGlow;
  final Color bgSurface;
  final Color bgElevated;
  final Color bgBorder;

  final Color statusSuccess;
  final Color statusError;
  final Color statusWarning;

  final Color iconDefault;

  const AppColors({
    required this.brandPrimaryGhost,
    required this.brandPrimaryGlow,
    required this.bgSurface,
    required this.bgElevated,
    required this.bgBorder,
    required this.statusSuccess,
    required this.statusError,
    required this.statusWarning,
    required this.iconDefault,
  });

  @override
  ThemeExtension<AppColors> copyWith({
    Color? brandPrimaryGhost,
    Color? brandPrimaryGlow,
    Color? bgSurface,
    Color? bgElevated,
    Color? bgBorder,
    Color? statusSuccess,
    Color? statusError,
    Color? statusWarning,
    Color? iconDefault,
  }) {
    return AppColors(
      brandPrimaryGhost: brandPrimaryGhost ?? this.brandPrimaryGhost,
      brandPrimaryGlow: brandPrimaryGlow ?? this.brandPrimaryGlow,
      bgSurface: bgSurface ?? this.bgSurface,
      bgElevated: bgElevated ?? this.bgElevated,
      bgBorder: bgBorder ?? this.bgBorder,
      statusSuccess: statusSuccess ?? this.statusSuccess,
      statusError: statusError ?? this.statusError,
      statusWarning: statusWarning ?? this.statusWarning,
      iconDefault: iconDefault ?? this.iconDefault,
    );
  }

  @override
  ThemeExtension<AppColors> lerp(ThemeExtension<AppColors>? other, double t) {
    if (other is! AppColors) return this;
    return AppColors(
      brandPrimaryGhost:
          Color.lerp(brandPrimaryGhost, other.brandPrimaryGhost, t) ??
          brandPrimaryGhost,
      brandPrimaryGlow:
          Color.lerp(brandPrimaryGlow, other.brandPrimaryGlow, t) ??
          brandPrimaryGlow,
      bgSurface: Color.lerp(bgSurface, other.bgSurface, t) ?? bgSurface,
      bgElevated: Color.lerp(bgElevated, other.bgElevated, t) ?? bgElevated,
      bgBorder: Color.lerp(bgBorder, other.bgBorder, t) ?? bgBorder,
      statusSuccess:
          Color.lerp(statusSuccess, other.statusSuccess, t) ?? statusSuccess,
      statusError:
          Color.lerp(statusError, other.statusError, t) ?? statusError,
      statusWarning:
          Color.lerp(statusWarning, other.statusWarning, t) ?? statusWarning,
      iconDefault:
          Color.lerp(iconDefault, other.iconDefault, t) ?? iconDefault,
    );
  }
}
