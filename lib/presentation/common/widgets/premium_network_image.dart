import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:bourgo_arena_mobile/core/theme/bourgo_theme.dart';

/// A premium wrapper around CachedNetworkImage that provides a modern skeleton loading state
/// and an elegant error state if the image fails to decode or load.
class PremiumNetworkImage extends StatelessWidget {
  final String imageUrl;
  final double? width;
  final double? height;
  final BoxFit fit;
  final Widget? errorIcon;

  const PremiumNetworkImage({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.errorIcon,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = theme.extension<AppColors>();

    return CachedNetworkImage(
      imageUrl: imageUrl,
      width: width,
      height: height,
      fit: fit,
      errorListener: (e) {
        debugPrint('Image load error: $e');
      },
      placeholder: (context, url) => Shimmer.fromColors(
        baseColor: theme.colorScheme.surfaceContainerHighest,
        highlightColor: theme.colorScheme.surfaceContainerHighest.withValues(
          alpha: 0.5,
        ),
        child: Container(
          width: width ?? double.infinity,
          height: height ?? double.infinity,
          color: theme.colorScheme.surfaceContainerHighest,
        ),
      ),
      errorWidget: (context, url, error) => Container(
        width: width ?? double.infinity,
        height: height ?? double.infinity,
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainerLowest,
          border: appColors != null
              ? Border.all(color: appColors.bgBorder, width: 1)
              : null,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            errorIcon ??
                Icon(
                  Symbols.imagesmode,
                  color: theme.colorScheme.onSurfaceVariant.withValues(
                    alpha: 0.5,
                  ),
                  size: 32,
                ),
            const SizedBox(height: 8),
            Text(
              'Image unavailable',
              style: theme.textTheme.labelSmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant.withValues(
                  alpha: 0.7,
                ),
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
