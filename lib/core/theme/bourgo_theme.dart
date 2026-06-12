import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';
import 'app_spacing.dart';
import 'app_typography.dart';

export 'app_colors.dart';
export 'app_spacing.dart';
export 'app_typography.dart';

/// Animation duration and curve tokens for Bourgo Arena.
class AppAnimation extends ThemeExtension<AppAnimation> {
  final Duration fast;
  final Duration normal;
  final Duration smooth;
  final Duration generous;
  final Duration luxurious;
  final Duration staggerInterval;

  final Curve press;
  final Curve entrance;
  final Curve bounce;
  final Curve elastic;

  const AppAnimation({
    required this.fast,
    required this.normal,
    required this.smooth,
    required this.generous,
    required this.luxurious,
    required this.staggerInterval,
    required this.press,
    required this.entrance,
    required this.bounce,
    required this.elastic,
  });

  static const AppAnimation standard = AppAnimation(
    fast: Duration(milliseconds: 150),
    normal: Duration(milliseconds: 300),
    smooth: Duration(milliseconds: 400),
    generous: Duration(milliseconds: 600),
    luxurious: Duration(milliseconds: 1000),
    staggerInterval: Duration(milliseconds: 50),
    press: Curves.easeOutCubic,
    entrance: Curves.easeOutQuad,
    bounce: Curves.easeOutBack,
    elastic: Curves.elasticOut,
  );

  @override
  ThemeExtension<AppAnimation> copyWith({
    Duration? fast,
    Duration? normal,
    Duration? smooth,
    Duration? generous,
    Duration? luxurious,
    Duration? staggerInterval,
    Curve? press,
    Curve? entrance,
    Curve? bounce,
    Curve? elastic,
  }) {
    return AppAnimation(
      fast: fast ?? this.fast,
      normal: normal ?? this.normal,
      smooth: smooth ?? this.smooth,
      generous: generous ?? this.generous,
      luxurious: luxurious ?? this.luxurious,
      staggerInterval: staggerInterval ?? this.staggerInterval,
      press: press ?? this.press,
      entrance: entrance ?? this.entrance,
      bounce: bounce ?? this.bounce,
      elastic: elastic ?? this.elastic,
    );
  }

  @override
  ThemeExtension<AppAnimation> lerp(
    ThemeExtension<AppAnimation>? other,
    double t,
  ) {
    if (other is! AppAnimation) return this;
    return AppAnimation(
      fast: lerpDuration(fast, other.fast, t),
      normal: lerpDuration(normal, other.normal, t),
      smooth: lerpDuration(smooth, other.smooth, t),
      generous: lerpDuration(generous, other.generous, t),
      luxurious: lerpDuration(luxurious, other.luxurious, t),
      staggerInterval: lerpDuration(staggerInterval, other.staggerInterval, t),
      press: other.press,
      entrance: other.entrance,
      bounce: other.bounce,
      elastic: other.elastic,
    );
  }

  static Duration lerpDuration(Duration a, Duration b, double t) {
    return Duration(
      microseconds: lerpDouble(a.inMicroseconds, b.inMicroseconds, t)!.round(),
    );
  }
}

extension AppAnimationContext on BuildContext {
  AppAnimation get anim =>
      Theme.of(this).extension<AppAnimation>() ?? AppAnimation.standard;
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
          statusSuccess: const Color(0xFF2E7D32),
          statusError: const Color(0xFFD32F2F),
          statusWarning: const Color(0xFFF9A825),
          iconDefault: const Color(0xFF1A1A1A).withValues(alpha: 0.4),
          accentActivity: const Color(0xFF7C3AED),
          accentEvent: const Color(0xFFC026D3),
          accentCourse: const Color(0xFFEA580C),
          accentService: const Color(0xFF0D9488),
          genderMale: const Color(0xFF0284C7),
          genderFemale: const Color(0xFFDB2777),
        ),
        AppSpacing.standard,
        AppAnimation.standard,
        AppTypography.standard(Brightness.light),
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
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size(double.infinity, 52),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.5,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
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
          statusSuccess: const Color(0xFF4CAF50),
          statusError: const Color(0xFFEF5350),
          statusWarning: const Color(0xFFFFD54F),
          iconDefault: Colors.white.withValues(alpha: 0.4),
          accentActivity: const Color(0xFFA78BFA),
          accentEvent: const Color(0xFFE879F9),
          accentCourse: const Color(0xFFFB923C),
          accentService: const Color(0xFF2DD4BF),
          genderMale: const Color(0xFF38BDF8),
          genderFemale: const Color(0xFFF472B6),
        ),
        AppSpacing.standard,
        AppAnimation.standard,
        AppTypography.standard(Brightness.dark),
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
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size(double.infinity, 52),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.5,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        ),
      ),
    );
  }

  static TextTheme _getTextTheme(Brightness brightness) {
    final baseTextTheme = GoogleFonts.dmSansTextTheme();
    final isDark = brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : const Color(0xFF1A1A1A);

    return baseTextTheme
        .copyWith(
          displayLarge: GoogleFonts.blackHanSans(
            textStyle: baseTextTheme.displayLarge?.copyWith(
              fontSize: 52,
              fontWeight: FontWeight.w900,
              height: 1.0,
              letterSpacing: -1.0,
            ),
          ),
          displayMedium: GoogleFonts.blackHanSans(
            textStyle: baseTextTheme.displayMedium?.copyWith(
              fontSize: 40,
              fontWeight: FontWeight.w900,
              height: 1.05,
              letterSpacing: -0.5,
            ),
          ),
          headlineLarge: GoogleFonts.lexend(
            textStyle: baseTextTheme.headlineLarge?.copyWith(
              fontSize: 28,
              fontWeight: FontWeight.w800,
              height: 1.1,
              letterSpacing: -0.3,
            ),
          ),
        )
        .apply(displayColor: textColor, bodyColor: textColor);
  }
}
