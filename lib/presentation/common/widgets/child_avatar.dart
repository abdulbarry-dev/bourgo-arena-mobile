import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

/// A gender-aware, brand-tinted circular avatar for children.
///
/// Provides a single, consistent visual identity for a child across the whole
/// family workflow (children list, profile header, etc.). When [heroTag] is
/// supplied the avatar participates in a shared-element transition, so tapping
/// a child in the list "flies" the avatar into the profile header.
///
/// Use a stable tag such as `child-avatar-<id>` on both the source and the
/// destination so Flutter can match them.
class ChildAvatar extends StatelessWidget {
  /// The child's gender (`'male'` / `'female'`), used to pick the glyph.
  final String? gender;

  /// Outer diameter of the avatar in logical pixels.
  final double size;

  /// Optional shared-element transition tag. When null the avatar is static.
  final Object? heroTag;

  /// Optional icon override (defaults to a gender-based child glyph).
  final IconData? icon;

  const ChildAvatar({
    super.key,
    this.gender,
    this.size = 64,
    this.heroTag,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;
    final isFemale = gender?.toLowerCase() == 'female';
    final glyph =
        icon ??
        (gender == null
            ? Symbols.child_care
            : (isFemale ? Symbols.girl : Symbols.boy));

    final avatar = Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            primary.withValues(alpha: 0.18),
            primary.withValues(alpha: 0.06),
          ],
        ),
        border: Border.all(color: primary.withValues(alpha: 0.22), width: 1.5),
      ),
      child: Center(
        child: Icon(glyph, color: primary, size: size * 0.5),
      ),
    );

    if (heroTag == null) return avatar;

    // Material wrapper keeps icon/glyph rendering correct mid-flight.
    return Hero(
      tag: heroTag!,
      child: Material(type: MaterialType.transparency, child: avatar),
    );
  }
}
