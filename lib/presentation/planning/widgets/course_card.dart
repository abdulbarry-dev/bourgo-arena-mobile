import 'package:bourgo_arena_mobile/core/constants/app_constants.dart';
import 'package:bourgo_arena_mobile/data/models/course.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

/// A card widget representing a group course session.
class CourseCard extends StatelessWidget {
  final Course course;

  const CourseCard({super.key, required this.course});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.5),
        ),
      ),
      child: Row(
        children: [
          _TimeColumn(startTime: course.startTime, endTime: course.endTime),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        course.title.toUpperCase(),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
                    const SizedBox(width: 8),
                    _CategoryBadge(category: course.category),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(
                      Symbols.person,
                      size: 14,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                    const SizedBox(width: 4),
                    Flexible(
                      child: Text(
                        course.instructor,
                        style: TextStyle(
                          color: theme.colorScheme.onSurfaceVariant,
                          fontSize: 13,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Icon(
                      Symbols.groups,
                      size: 14,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${course.enrolled}/${course.capacity}',
                      style: TextStyle(
                        color: course.isFull
                            ? Colors.redAccent
                            : theme.colorScheme.onSurfaceVariant,
                        fontSize: 13,
                        fontWeight: course.isFull
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          _ActionButton(isFull: course.isFull),
        ],
      ),
    );
  }
}

class _TimeColumn extends StatelessWidget {
  final String startTime;
  final String endTime;

  const _TimeColumn({required this.startTime, required this.endTime});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        Text(
          startTime,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        Container(
          width: 2,
          height: 12,
          color: theme.colorScheme.outline,
          margin: const EdgeInsets.symmetric(vertical: 2),
        ),
        Text(
          endTime,
          style: TextStyle(
            color: theme.colorScheme.onSurfaceVariant,
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}

class _CategoryBadge extends StatelessWidget {
  final String category;

  const _CategoryBadge({required this.category});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = _getCategoryColor(category, theme);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withAlpha(30),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: color.withAlpha(50)),
      ),
      child: Text(
        category.toUpperCase(),
        style: TextStyle(
          color: color,
          fontSize: 9,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Color _getCategoryColor(String cat, ThemeData theme) {
    switch (cat) {
      case AppConstants.planningCategoryFitness:
        return theme.colorScheme.primary;
      case AppConstants.planningCategoryAcademy:
        return Colors.orangeAccent;
      case AppConstants.planningCategoryWellness:
        return Colors.lightBlueAccent;
      default:
        return theme.colorScheme.onSurfaceVariant;
    }
  }
}

class _ActionButton extends StatelessWidget {
  final bool isFull;

  const _ActionButton({required this.isFull});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isFull
            ? theme.colorScheme.onSurface.withValues(alpha: 0.1)
            : theme.colorScheme.primary.withValues(alpha: 0.15),
        border: Border.all(
          color: isFull
              ? theme.colorScheme.outline
              : theme.colorScheme.primary.withValues(alpha: 0.3),
        ),
      ),
      child: Icon(
        isFull ? Symbols.lock : Symbols.add,
        size: 20,
        color: isFull
            ? theme.colorScheme.onSurfaceVariant
            : theme.colorScheme.primary,
      ),
    );
  }
}
