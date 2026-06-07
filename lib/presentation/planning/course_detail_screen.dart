import 'package:bourgo_arena_mobile/core/di/locator.dart';
import 'package:bourgo_arena_mobile/domain/core/failure.dart';
import 'package:bourgo_arena_mobile/domain/entities/course.dart';
import 'package:bourgo_arena_mobile/domain/repositories/course_repository.dart';
import 'package:flutter/material.dart';
import 'package:bourgo_arena_mobile/core/theme/bourgo_theme.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:bourgo_arena_mobile/presentation/planning/widgets/session_card.dart';
import 'dart:developer' as developer;

/// Screen showing details and upcoming sessions for a specific course.
class CourseDetailScreen extends StatefulWidget {
  final Course? course;
  final String courseId;

  const CourseDetailScreen({super.key, this.course, required this.courseId});

  @override
  State<CourseDetailScreen> createState() => _CourseDetailScreenState();
}

class _CourseDetailScreenState extends State<CourseDetailScreen> {
  late final CourseRepository _courseRepository;
  List<Course> _sessions = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _courseRepository = locator<CourseRepository>();
    _loadSessions();
  }

  Future<void> _loadSessions() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final result = await _courseRepository.getCourseSessions(widget.courseId);

    result.when(
      success: (sessions) {
        if (mounted) {
          setState(() {
            _sessions = sessions;
            _isLoading = false;
          });
        }
      },
      failure: (Failure failure) {
        developer.log(
          'CourseDetailScreen: Failed to load sessions - ${failure.message}',
        );
        if (mounted) {
          setState(() {
            if (failure is AuthFailure) {
              _errorMessage =
                  'Access Restricted: You need an active subscription plan that covers this course.';
            } else {
              _errorMessage = failure.message;
            }
            _isLoading = false;
          });
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = AppSpacing.standard;
    final course = widget.course;

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          course?.title.toUpperCase() ?? 'COURSE DETAILS',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w900,
            letterSpacing: 1.5,
            color: theme.colorScheme.primary,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _loadSessions,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
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
                    SizedBox(height: spacing.sm),
                    if (course?.category != null)
                      _CategoryChip(category: course!.category),
                    SizedBox(height: spacing.md),
                    if (course?.instructor != null &&
                        course!.instructor.isNotEmpty)
                      Row(
                        children: [
                          Icon(
                            Icons.person,
                            size: 16,
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            course.instructor,
                            style: theme.textTheme.bodyLarge?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    SizedBox(height: spacing.lg),
                    Text(
                      'Upcoming Sessions',
                      style: theme.textTheme.titleLarge,
                    ),
                    SizedBox(height: spacing.md),
                    _SessionsSection(
                      isLoading: _isLoading,
                      errorMessage: _errorMessage,
                      sessions: _sessions,
                      fallbackCourse: course,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CategoryChip extends StatelessWidget {
  final String category;

  const _CategoryChip({required this.category});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: theme.colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        category.toUpperCase(),
        style: theme.textTheme.labelSmall?.copyWith(
          color: theme.colorScheme.onPrimaryContainer,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class _SessionsSection extends StatelessWidget {
  final bool isLoading;
  final String? errorMessage;
  final List<Course> sessions;
  final Course? fallbackCourse;

  const _SessionsSection({
    required this.isLoading,
    required this.errorMessage,
    required this.sessions,
    this.fallbackCourse,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (isLoading) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(32),
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (errorMessage != null) {
      return Center(
        child: Column(
          children: [
            Text(
              errorMessage!,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.error,
              ),
              textAlign: TextAlign.center,
            ),
            if (errorMessage!.contains('Access Restricted:')) ...[
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => context.push('/subscription'),
                child: const Text('View Plans'),
              ),
            ],
          ],
        ),
      );
    }

    if (sessions.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 32),
        child: Center(
          child: Text(
            'No upcoming sessions found.',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ),
      );
    }

    return Column(
      children: sessions
          .map(
            (session) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: SessionCard(
                title: session.title,
                startTime: session.startTime,
                endTime: session.endTime,
                courseImageUrl: session.imageUrl ?? fallbackCourse?.imageUrl,
              ),
            ),
          )
          .toList(),
    );
  }
}
