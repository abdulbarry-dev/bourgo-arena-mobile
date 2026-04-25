import 'package:flutter/material.dart';

/// A card widget representing a sports activity.
class ActivityCard extends StatelessWidget {
  final String title;
  final String imageUrl;
  final IconData? icon;
  final VoidCallback? onTap;
  final bool isFullWidth;

  const ActivityCard({
    super.key,
    required this.title,
    required this.imageUrl,
    this.icon,
    this.onTap,
    this.isFullWidth = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: isFullWidth ? double.infinity : 160,
        height: isFullWidth ? 180 : 200,
        margin: EdgeInsets.only(right: isFullWidth ? 0 : 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          image: DecorationImage(
            image: NetworkImage(imageUrl),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              Colors.black.withAlpha(120),
              BlendMode.darken,
            ),
          ),
          border: Border.all(color: Colors.white.withAlpha(20)),
        ),
        child: Stack(
          children: [
            if (icon != null)
              Center(
                child: Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: theme.colorScheme.primary.withAlpha(30),
                    border: Border.all(
                      color: theme.colorScheme.primary.withAlpha(100),
                      width: 1.5,
                    ),
                  ),
                  child: Icon(icon, size: 28, color: theme.colorScheme.primary),
                ),
              ),
            Positioned(
              bottom: 16,
              left: 16,
              right: 16,
              child: Text(
                title.toUpperCase(),
                style: theme.textTheme.headlineSmall?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                  fontFamily: 'BlackHanSans',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
