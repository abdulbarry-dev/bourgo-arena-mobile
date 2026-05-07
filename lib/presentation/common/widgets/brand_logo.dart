import 'package:bourgo_arena_mobile/core/constants/app_constants.dart';
import 'package:flutter/material.dart';

/// A reusable widget to display the Bourgo Arena brand logo or icon.
class BrandLogo extends StatelessWidget {
  /// The height or width dimension of the logo.
  final double size;

  /// Whether to use the full vertical brandmark or just the app icon.
  final bool useVertical;

  /// Optional Hero tag for transitions.
  final String? heroTag;

  /// Creates a [BrandLogo].
  const BrandLogo({
    super.key,
    this.size = 64.0,
    this.useVertical = false,
    this.heroTag,
  });

  @override
  Widget build(BuildContext context) {
    final String assetPath = useVertical
        ? AppConstants.assetBrandmarkVertical
        : AppConstants.assetAppIcon;

    final Widget image = Image.asset(
      assetPath,
      height: size,
      fit: BoxFit.contain,
    );

    if (heroTag != null) {
      return Hero(tag: heroTag!, child: image);
    }

    return image;
  }
}
