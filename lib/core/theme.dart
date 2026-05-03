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

/// Theming configuration for Bourgo Arena.
class BourgoTheme {
  static const Color primaryNeon = Color(0xFFAAFF00);
  static const Color primaryNeonDim = Color(0xFF88CC00);
  static const Color bgBase = Color(0xFF0A0A0A);

  static ThemeData get lightTheme {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: primaryNeon,
      brightness: Brightness.light,
      primary: const Color(0xFF558800), // Slightly deeper for light mode
      onPrimary: Colors.white,
      surface: const Color(0xFFFCFCFC),
      onSurface: const Color(0xFF1A1A1A),
      onSurfaceVariant: const Color(0xFF454545),
      outline: const Color(0xFFE0E0E0),
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: colorScheme.surface,
      textTheme: _getTextTheme(Brightness.light),
      extensions: [
        AppColors(
          brandPrimaryGhost: const Color(0xFF558800).withValues(alpha: 0.1),
          brandPrimaryGlow: const Color(0xFF558800).withValues(alpha: 0.25),
          bgSurface: Colors.white,
          bgElevated: const Color(0xFFF2F2F2),
          bgBorder: const Color(0xFFE5E5E5),
        ),
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
