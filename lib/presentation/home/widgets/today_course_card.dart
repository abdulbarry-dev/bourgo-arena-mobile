import 'package:bourgo_arena_mobile/domain/entities/course.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

/// A sleek, professional card for displaying today's courses on the home screen.
class TodayCourseCard extends StatelessWidget {
  final Course course;
  final VoidCallback onTap;

  const TodayCourseCard({super.key, required this.course, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainerHighest.withAlpha(80),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: theme.colorScheme.outline.withAlpha(30)),
        ),
        child: Row(
          children: [
            // Time Section
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  course.startTime,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.primary,
                  ),
                ),
                Text(
                  course.endTime,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant.withAlpha(150),
                  ),
                ),
              ],
            ),
            const SizedBox(width: 20),
            // Divider
            Container(
              width: 1,
              height: 40,
              color: theme.colorScheme.outline.withAlpha(50),
            ),
            const SizedBox(width: 20),
            // Info Section
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    course.category.toUpperCase(),
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: theme.colorScheme.secondary,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    course.title,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(
                        Symbols.person,
                        size: 14,
                        color: theme.colorScheme.onSurfaceVariant.withAlpha(
                          180,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        course.instructor,
                        style: theme.textTheme.labelMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Status Section
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: course.isFull
                    ? theme.colorScheme.error.withAlpha(30)
                    : theme.colorScheme.primary.withAlpha(30),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                course.isFull ? 'FULL' : '${course.remainingSpots} LEFT',
                style: theme.textTheme.labelSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: course.isFull
                      ? theme.colorScheme.error
                      : theme.colorScheme.primary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
