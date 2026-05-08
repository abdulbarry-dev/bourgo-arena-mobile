import 'package:bourgo_arena_mobile/core/constants/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

/// A reusable widget to display the Bourgo Arena brand logo or icon.
class BrandLogo extends StatelessWidget {
  /// The height or width dimension of the logo.
  final double size;

  /// Whether to use a premium, glassmorphism-style background.
  final bool isPremium;

  /// Whether to use the vertical logo layout (brandmark).
  final bool useVertical;

  /// Optional Hero tag for animations.
  final String? heroTag;

  /// Creates a [BrandLogo].
  const BrandLogo({
    super.key,
    this.size = 64.0,
    this.useVertical = false,
    this.isPremium = false,
    this.heroTag,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Normalize asset path to avoid double 'assets/' prefix on some platforms (like Web engine issues)
    String assetPath = useVertical
        ? AppConstants.assetBrandmarkVertical
        : AppConstants.assetAppIcon;

    // Safety check: If path starts with assets/assets/, fix it.
    // However, the reported error is that the FETCH failed for assets/assets/...
    // which means the engine prepended it.
    // If we provide 'assets/icons/...', the engine prepends 'assets/' -> 'assets/assets/icons/...'
    // So we should provide 'icons/...' IF the engine prepends it.
    // But we don't know for sure if it will always happen.
    // A safer way is to check if we are on web and if the path starts with assets/.
    /*
    if (kIsWeb && assetPath.startsWith('assets/')) {
      assetPath = assetPath.substring(7);
    }
    */

    Widget image = Image.asset(
      assetPath,
      height: size,
      fit: BoxFit.contain,
      errorBuilder: (context, error, stackTrace) {
        // Fallback if the path failed with double assets/
        if (assetPath.startsWith('assets/')) {
          return Image.asset(
            assetPath.substring(7),
            height: size,
            fit: BoxFit.contain,
          );
        }
        return Icon(Symbols.broken_image, size: size);
      },
    );

    if (isPremium) {
      image = Container(
        padding: EdgeInsets.all(size * 0.25),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface.withValues(alpha: 0.1),
          shape: BoxShape.circle,
          border: Border.all(
            color: theme.colorScheme.primary.withValues(alpha: 0.2),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: theme.colorScheme.primary.withValues(alpha: 0.1),
              blurRadius: 20,
              spreadRadius: 5,
            ),
          ],
        ),
        child: image,
      );
    }

    if (heroTag != null) {
      return Hero(tag: heroTag!, child: image);
    }

    return image;
  }
}
