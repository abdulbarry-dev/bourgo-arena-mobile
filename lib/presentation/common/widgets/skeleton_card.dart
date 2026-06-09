import 'package:flutter/material.dart';

enum SkeletonCardType { activity, event, plan, course, transaction }

class SkeletonCard extends StatelessWidget {
  final SkeletonCardType type;

  const SkeletonCard({super.key, required this.type});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: switch (type) {
        SkeletonCardType.activity => _buildActivitySkeleton(theme),
        SkeletonCardType.event => _buildEventSkeleton(theme),
        SkeletonCardType.plan => _buildPlanSkeleton(theme),
        SkeletonCardType.course => _buildCourseSkeleton(theme),
        SkeletonCardType.transaction => _buildTransactionSkeleton(theme),
      },
    );
  }

  Widget _bone(
    ThemeData theme, {
    double? width,
    double? height,
    BorderRadiusGeometry? radius,
  }) {
    return Container(
      width: width,
      height: height ?? 14,
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: radius ?? BorderRadius.circular(6),
      ),
    );
  }

  Widget _buildActivitySkeleton(ThemeData theme) {
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(24),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            height: 180,
            color: theme.colorScheme.surfaceContainerHighest,
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _bone(
                  theme,
                  width: 180,
                  height: 18,
                  radius: BorderRadius.circular(6),
                ),
                const SizedBox(height: 8),
                _bone(theme, height: 14),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  children: List.generate(
                    3,
                    (_) => Padding(
                      padding: const EdgeInsets.only(bottom: 6),
                      child: _bone(
                        theme,
                        width: 72,
                        height: 22,
                        radius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEventSkeleton(ThemeData theme) {
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(24),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            height: 160,
            color: theme.colorScheme.surfaceContainerHighest,
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _bone(
                  theme,
                  width: 200,
                  height: 16,
                  radius: BorderRadius.circular(6),
                ),
                const SizedBox(height: 10),
                _bone(theme, width: 140, height: 12),
                const SizedBox(height: 8),
                _bone(
                  theme,
                  width: double.infinity,
                  height: 4,
                  radius: BorderRadius.circular(2),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlanSkeleton(ThemeData theme) {
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(24),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            height: 160,
            color: theme.colorScheme.surfaceContainerHighest,
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _bone(
                  theme,
                  width: 120,
                  height: 18,
                  radius: BorderRadius.circular(6),
                ),
                const SizedBox(height: 8),
                _bone(
                  theme,
                  width: 80,
                  height: 24,
                  radius: BorderRadius.circular(6),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    _bone(
                      theme,
                      width: 64,
                      height: 22,
                      radius: BorderRadius.circular(8),
                    ),
                    const SizedBox(width: 8),
                    _bone(
                      theme,
                      width: 80,
                      height: 22,
                      radius: BorderRadius.circular(8),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCourseSkeleton(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          _bone(
            theme,
            width: 64,
            height: 64,
            radius: BorderRadius.circular(16),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _bone(
                  theme,
                  width: 140,
                  height: 16,
                  radius: BorderRadius.circular(6),
                ),
                const SizedBox(height: 8),
                _bone(theme, width: 100, height: 12),
                const SizedBox(height: 8),
                _bone(theme, width: 80, height: 12),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionSkeleton(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          _bone(
            theme,
            width: 48,
            height: 48,
            radius: BorderRadius.circular(24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _bone(
                  theme,
                  width: 120,
                  height: 14,
                  radius: BorderRadius.circular(6),
                ),
                const SizedBox(height: 6),
                _bone(theme, width: 80, height: 12),
              ],
            ),
          ),
          _bone(theme, width: 60, height: 16, radius: BorderRadius.circular(6)),
        ],
      ),
    );
  }
}
