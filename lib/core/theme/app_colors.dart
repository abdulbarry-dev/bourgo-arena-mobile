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

  final Color accentActivity;
  final Color accentEvent;
  final Color accentCourse;
  final Color accentService;
  final Color genderMale;
  final Color genderFemale;

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
    required this.accentActivity,
    required this.accentEvent,
    required this.accentCourse,
    required this.accentService,
    required this.genderMale,
    required this.genderFemale,
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
    Color? accentActivity,
    Color? accentEvent,
    Color? accentCourse,
    Color? accentService,
    Color? genderMale,
    Color? genderFemale,
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
      accentActivity: accentActivity ?? this.accentActivity,
      accentEvent: accentEvent ?? this.accentEvent,
      accentCourse: accentCourse ?? this.accentCourse,
      accentService: accentService ?? this.accentService,
      genderMale: genderMale ?? this.genderMale,
      genderFemale: genderFemale ?? this.genderFemale,
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
      statusError: Color.lerp(statusError, other.statusError, t) ?? statusError,
      statusWarning:
          Color.lerp(statusWarning, other.statusWarning, t) ?? statusWarning,
      iconDefault: Color.lerp(iconDefault, other.iconDefault, t) ?? iconDefault,
      accentActivity:
          Color.lerp(accentActivity, other.accentActivity, t) ?? accentActivity,
      accentEvent: Color.lerp(accentEvent, other.accentEvent, t) ?? accentEvent,
      accentCourse:
          Color.lerp(accentCourse, other.accentCourse, t) ?? accentCourse,
      accentService:
          Color.lerp(accentService, other.accentService, t) ?? accentService,
      genderMale: Color.lerp(genderMale, other.genderMale, t) ?? genderMale,
      genderFemale:
          Color.lerp(genderFemale, other.genderFemale, t) ?? genderFemale,
    );
  }
}
