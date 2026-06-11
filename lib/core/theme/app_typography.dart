import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Semantic typography tokens for Bourgo Arena.
///
/// Each token maps to a specific Google Font and role:
/// - Display: Black Han Sans (hero numbers, large titles)
/// - Headlines: Lexend (section headings, modal titles)
/// - UI labels: Lexend (buttons, stats, badges)
/// - Body: DM Sans (paragraphs, descriptions)
class AppTypography extends ThemeExtension<AppTypography> {
  final TextStyle? displayHero;
  final TextStyle? displayTitle;
  final TextStyle? displaySubhead;
  final TextStyle? headline;
  final TextStyle? sectionTitle;
  final TextStyle? statValue;
  final TextStyle? buttonLabel;
  final TextStyle? bodyText;
  final TextStyle? caption;
  final TextStyle? overline;

  const AppTypography({
    required this.displayHero,
    required this.displayTitle,
    required this.displaySubhead,
    required this.headline,
    required this.sectionTitle,
    required this.statValue,
    required this.buttonLabel,
    required this.bodyText,
    required this.caption,
    required this.overline,
  });

  static AppTypography standard(Brightness brightness) {
    return AppTypography(
      displayHero: GoogleFonts.blackHanSans(
        fontSize: 52,
        fontWeight: FontWeight.w900,
        height: 1.0,
        letterSpacing: -1.0,
      ),
      displayTitle: GoogleFonts.blackHanSans(
        fontSize: 40,
        fontWeight: FontWeight.w900,
        height: 1.05,
        letterSpacing: -0.5,
      ),
      displaySubhead: GoogleFonts.lexend(
        fontSize: 28,
        fontWeight: FontWeight.w800,
        height: 1.1,
        letterSpacing: -0.3,
      ),
      headline: GoogleFonts.lexend(
        fontSize: 20,
        fontWeight: FontWeight.w700,
        height: 1.2,
      ),
      sectionTitle: GoogleFonts.lexend(
        fontSize: 14,
        fontWeight: FontWeight.w900,
        height: 1.2,
        letterSpacing: 1.5,
      ),
      statValue: GoogleFonts.lexend(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        height: 1.2,
      ),
      buttonLabel: GoogleFonts.lexend(
        fontSize: 12,
        fontWeight: FontWeight.w700,
        height: 1.2,
        letterSpacing: 1.5,
      ),
      bodyText: GoogleFonts.dmSans(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        height: 1.5,
      ),
      caption: GoogleFonts.dmSans(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        height: 1.4,
      ),
      overline: GoogleFonts.lexend(
        fontSize: 10,
        fontWeight: FontWeight.w700,
        height: 1.2,
        letterSpacing: 1.0,
      ),
    );
  }

  @override
  ThemeExtension<AppTypography> copyWith({
    TextStyle? displayHero,
    TextStyle? displayTitle,
    TextStyle? displaySubhead,
    TextStyle? headline,
    TextStyle? sectionTitle,
    TextStyle? statValue,
    TextStyle? buttonLabel,
    TextStyle? bodyText,
    TextStyle? caption,
    TextStyle? overline,
  }) {
    return AppTypography(
      displayHero: displayHero ?? this.displayHero,
      displayTitle: displayTitle ?? this.displayTitle,
      displaySubhead: displaySubhead ?? this.displaySubhead,
      headline: headline ?? this.headline,
      sectionTitle: sectionTitle ?? this.sectionTitle,
      statValue: statValue ?? this.statValue,
      buttonLabel: buttonLabel ?? this.buttonLabel,
      bodyText: bodyText ?? this.bodyText,
      caption: caption ?? this.caption,
      overline: overline ?? this.overline,
    );
  }

  @override
  ThemeExtension<AppTypography> lerp(
    ThemeExtension<AppTypography>? other,
    double t,
  ) {
    if (other is! AppTypography) return this;
    return AppTypography(
      displayHero: TextStyle.lerp(displayHero, other.displayHero, t),
      displayTitle: TextStyle.lerp(displayTitle, other.displayTitle, t),
      displaySubhead: TextStyle.lerp(displaySubhead, other.displaySubhead, t),
      headline: TextStyle.lerp(headline, other.headline, t),
      sectionTitle: TextStyle.lerp(sectionTitle, other.sectionTitle, t),
      statValue: TextStyle.lerp(statValue, other.statValue, t),
      buttonLabel: TextStyle.lerp(buttonLabel, other.buttonLabel, t),
      bodyText: TextStyle.lerp(bodyText, other.bodyText, t),
      caption: TextStyle.lerp(caption, other.caption, t),
      overline: TextStyle.lerp(overline, other.overline, t),
    );
  }
}

extension AppTypographyContext on BuildContext {
  AppTypography get typography =>
      Theme.of(this).extension<AppTypography>() ?? AppTypography.standard(Brightness.light);
}
