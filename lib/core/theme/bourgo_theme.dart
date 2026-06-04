import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Custom design tokens for Bourgo Arena.
class AppColors extends ThemeExtension<AppColors> {
  final Color brandPrimaryGhost;
  final Color brandPrimaryGlow;
  final Color bgSurface;
  final Color bgElevated;
  final Color bgBorder;

  const AppColors({
    required this.brandPrimaryGhost,
    required this.brandPrimaryGlow,
    required this.bgSurface,
    required this.bgElevated,
    required this.bgBorder,
  });

  @override
  ThemeExtension<AppColors> copyWith({
    Color? brandPrimaryGhost,
    Color? brandPrimaryGlow,
    Color? bgSurface,
    Color? bgElevated,
    Color? bgBorder,
  }) {
    return AppColors(
      brandPrimaryGhost: brandPrimaryGhost ?? this.brandPrimaryGhost,
      brandPrimaryGlow: brandPrimaryGlow ?? this.brandPrimaryGlow,
      bgSurface: bgSurface ?? this.bgSurface,
      bgElevated: bgElevated ?? this.bgElevated,
      bgBorder: bgBorder ?? this.bgBorder,
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
    );
  }
}

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

/// Theming configuration for Bourgo Arena.
class BourgoTheme {
  static const Color primaryNeon = Color(0xFFAAFF00);
  static const Color primaryNeonDim = Color(0xFF88CC00);
  static const Color bgBase = Color(0xFF0A0A0A);

  static ThemeData get lightTheme {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: primaryNeon,
      brightness: Brightness.light,
      primary: const Color(0xFF558800),
      onPrimary: Colors.white,
      surface: Colors.white,
      onSurface: const Color(0xFF1A1A1A),
      onSurfaceVariant: const Color(0xFF5A5A5A),
      outline: const Color(0xFFE0E0E0),
      outlineVariant: const Color(0xFFF0F0F0),
      surfaceContainer: const Color(0xFFF7F9FC),
      surfaceContainerLow: const Color(0xFFFDFDFD),
      surfaceContainerHigh: const Color(0xFFF1F4F8),
      surfaceContainerHighest: const Color(0xFFE9EDF2),
      error: const Color(0xFFD32F2F),
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: colorScheme.surface,
      textTheme: _getTextTheme(Brightness.light),
      extensions: [
        AppColors(
          brandPrimaryGhost: const Color(0xFF558800).withValues(alpha: 0.08),
          brandPrimaryGlow: const Color(0xFF558800).withValues(alpha: 0.2),
          bgSurface: Colors.white,
          bgElevated: const Color(0xFFF8F9FA),
          bgBorder: const Color(0xFFE9ECEF),
        ),
        AppSpacing.standard,
      ],
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
          minimumSize: const Size(double.infinity, 52),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.5,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: colorScheme.primary,
          minimumSize: const Size(double.infinity, 52),
          side: BorderSide(color: colorScheme.outline, width: 2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.5,
          ),
        ),
      ),
    );
  }

  static ThemeData get darkTheme {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: primaryNeon,
      brightness: Brightness.dark,
      primary: primaryNeon,
      onPrimary: Colors.black,
      surface: const Color(0xFF0F0F0F),
      onSurface: Colors.white,
      onSurfaceVariant: const Color(0xFFB0B0B0),
      outline: const Color(0xFF242424),
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: bgBase,
      colorScheme: colorScheme,
      textTheme: _getTextTheme(Brightness.dark),
      extensions: [
        AppColors(
          brandPrimaryGhost: primaryNeon.withValues(alpha: 0.08),
          brandPrimaryGlow: primaryNeon.withValues(alpha: 0.25),
          bgSurface: const Color(0xFF111111),
          bgElevated: const Color(0xFF1A1A1A),
          bgBorder: const Color(0xFF242424),
        ),
        AppSpacing.standard,
      ],
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
          minimumSize: const Size(double.infinity, 52),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.5,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: colorScheme.primary,
          minimumSize: const Size(double.infinity, 52),
          side: BorderSide(
            color: colorScheme.primary.withValues(alpha: 0.5),
            width: 2,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.5,
          ),
        ),
      ),
    );
  }

  static TextTheme _getTextTheme(Brightness brightness) {
    final baseTextTheme = brightness == Brightness.dark
        ? ThemeData.dark().textTheme
        : ThemeData.light().textTheme;

    final baseTheme = GoogleFonts.dmSansTextTheme(baseTextTheme);

    return baseTheme.copyWith(
      displayLarge: GoogleFonts.blackHanSans(
        textStyle: baseTheme.displayLarge?.copyWith(
          fontSize: 52,
          fontWeight: FontWeight.w900,
          height: 1.0,
          letterSpacing: -1.0,
        ),
      ),
      displayMedium: GoogleFonts.blackHanSans(
        textStyle: baseTheme.displayMedium?.copyWith(
          fontSize: 40,
          fontWeight: FontWeight.w900,
          height: 1.05,
          letterSpacing: -0.5,
        ),
      ),
      headlineLarge: GoogleFonts.lexend(
        textStyle: baseTheme.headlineLarge?.copyWith(
          fontSize: 32,
          fontWeight: FontWeight.w800,
          height: 1.1,
          letterSpacing: -0.3,
        ),
      ),
    );
  }
}
