import 'package:flutter/material.dart';
import 'package:bourgo_arena_mobile/core/theme/bourgo_theme.dart';
import 'package:cached_network_image/cached_network_image.dart';

class SessionCard extends StatelessWidget {
  final String title;
  final String startTime;
  final String endTime;
  final String? courseImageUrl;
  final VoidCallback? onTap;

  const SessionCard({
    super.key,
    required this.title,
    required this.startTime,
    required this.endTime,
    this.courseImageUrl,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = theme.extension<AppColors>()!;
    final spacing = AppSpacing.standard;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: spacing.sm),
        padding: spacing.all(spacing.sm),
        decoration: BoxDecoration(
          color: appColors.bgElevated,
          borderRadius: BorderRadius.circular(spacing.md),
          border: Border.all(color: appColors.bgBorder),
        ),
        child: Row(
          children: [
            if (courseImageUrl != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(spacing.sm),
                child: CachedNetworkImage(
                  imageUrl: courseImageUrl!,
                  width: 60,
                  height: 60,
                  fit: BoxFit.cover,
                ),
              )
            else
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: appColors.bgSurface,
                  borderRadius: BorderRadius.circular(spacing.sm),
                ),
                child: Icon(
                  Icons.fitness_center,
                  color: theme.colorScheme.primary,
                ),
              ),
            SizedBox(width: spacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: spacing.xxs),
                  Text(
                    '$startTime - $endTime',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
