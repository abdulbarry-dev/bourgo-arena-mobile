import 'package:flutter/material.dart';
import 'package:bourgo_arena_mobile/core/constants/app_constants.dart';
import 'package:bourgo_arena_mobile/core/theme/bourgo_theme.dart';
import 'package:cached_network_image/cached_network_image.dart';

/// A foundational UI component for displaying rich imagery cards.
/// Adheres strictly to Phase 1 UI System Alignment (typography, radii, shadows).
class BourgoImageCard extends StatelessWidget {
  final String title;
  final String? imageUrl;
  final VoidCallback? onTap;
  final bool isFullWidth;
  final Widget? overlayWidget;

  const BourgoImageCard({
    super.key,
    required this.title,
    this.imageUrl,
    this.onTap,
    this.isFullWidth = false,
    this.overlayWidget,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = theme.extension<AppColors>()!;
    final spacing = AppSpacing.standard;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: isFullWidth ? double.infinity : 160,
        height: isFullWidth ? 180 : 200,
        margin: EdgeInsets.only(right: isFullWidth ? 0 : spacing.md),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(spacing.md),
          color: appColors.bgElevated,
          border: Border.all(color: appColors.bgBorder),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(50),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          fit: StackFit.expand,
          children: [
            if (imageUrl != null && imageUrl!.isNotEmpty)
              CachedNetworkImage(
                imageUrl: imageUrl!,
                fit: BoxFit.cover,
                placeholder: (context, url) => Center(
                  child: CircularProgressIndicator(
                    color: appColors.brandPrimaryGlow,
                  ),
                ),
                errorWidget: (context, url, error) => Container(
                  color: appColors.bgSurface,
                  child: Icon(
                    Icons.broken_image,
                    color: theme.colorScheme.error,
                  ),
                ),
              ),
            // Gradient overlay for text readability
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Colors.black.withAlpha(200)],
                  stops: const [0.4, 1.0],
                ),
              ),
            ),
            ?overlayWidget,
            Positioned(
              bottom: spacing.md,
              left: spacing.md,
              right: spacing.md,
              child: Text(
                title.toUpperCase(),
                style: theme.textTheme.titleMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                  fontFamily: AppConstants.displayFontFamily,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
