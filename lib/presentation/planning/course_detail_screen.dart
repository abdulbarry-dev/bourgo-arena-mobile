import 'package:flutter/material.dart';
import 'package:bourgo_arena_mobile/domain/entities/course.dart';
import 'package:bourgo_arena_mobile/core/theme/bourgo_theme.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:bourgo_arena_mobile/presentation/planning/widgets/session_card.dart';

class CourseDetailScreen extends StatelessWidget {
  final Course? course;
  final String courseId;

  const CourseDetailScreen({super.key, this.course, required this.courseId});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = theme.extension<AppColors>()!;
    final spacing = AppSpacing.standard;

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        title: Text(course?.title ?? 'Course Details'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (course?.imageUrl != null)
              CachedNetworkImage(
                imageUrl: course!.imageUrl!,
                height: 250,
                fit: BoxFit.cover,
              )
            else
              Container(
                height: 250,
                color: appColors.bgElevated,
                child: const Icon(Icons.fitness_center, size: 64),
              ),
            Padding(
              padding: spacing.screenPadding(context),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    course?.title ?? 'Loading...',
                    style: theme.textTheme.headlineLarge,
                  ),
                  SizedBox(height: spacing.md),
                  Text(
                    'Instructor: ${course?.instructor ?? ''}',
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  SizedBox(height: spacing.lg),
                  Text(
                    'Upcoming Sessions',
                    style: theme.textTheme.titleLarge,
                  ),
                  SizedBox(height: spacing.md),
                  // Placeholder for dynamic sessions list
                  SessionCard(
                    title: 'Upcoming Session',
                    startTime: course?.startTime ?? '10:00 AM',
                    endTime: course?.endTime ?? '11:00 AM',
                    courseImageUrl: course?.imageUrl,
                  ),
                  SessionCard(
                    title: 'Next Week Session',
                    startTime: course?.startTime ?? '10:00 AM',
                    endTime: course?.endTime ?? '11:00 AM',
                    courseImageUrl: course?.imageUrl,
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
