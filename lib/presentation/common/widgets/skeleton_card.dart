import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

enum SkeletonCardType { activity, event, plan, course, transaction }

/// A shimmer-animated placeholder card that mirrors the real card's layout.
///
/// Each [SkeletonCardType] reproduces the exact structure of its matching
/// real card widget so the transition from loading → loaded is seamless.
class SkeletonCard extends StatelessWidget {
  final SkeletonCardType type;

  const SkeletonCard({super.key, required this.type});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final baseColor = theme.colorScheme.onSurface.withValues(alpha: 0.06);
    final highlightColor = theme.colorScheme.onSurface.withValues(alpha: 0.13);

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Shimmer.fromColors(
        baseColor: baseColor,
        highlightColor: highlightColor,
        child: switch (type) {
          SkeletonCardType.activity => _buildActivitySkeleton(theme),
          SkeletonCardType.event => _buildEventSkeleton(theme),
          SkeletonCardType.plan => _buildPlanSkeleton(theme),
          SkeletonCardType.course => _buildCourseSkeleton(theme),
          SkeletonCardType.transaction => _buildTransactionSkeleton(theme),
        },
      ),
    );
  }

  /// A simple rectangular bone element.
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
        color: Colors.white,
        borderRadius: radius ?? BorderRadius.circular(6),
      ),
    );
  }

  // ─── Activity ────────────────────────────────────────────────────────────

  Widget _buildActivitySkeleton(ThemeData theme) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(24),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(height: 180, color: Colors.white),
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

  // ─── Event ───────────────────────────────────────────────────────────────

  Widget _buildEventSkeleton(ThemeData theme) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(24),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(height: 160, color: Colors.white),
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

  // ─── Plan ─────────────────────────────────────────────────────────────────

  Widget _buildPlanSkeleton(ThemeData theme) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(24),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(height: 160, color: Colors.white),
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

  // ─── Course ───────────────────────────────────────────────────────────────
  // Mirrors CourseCard: borderRadius 24 + shadow, 180 px image with gradient
  // overlay badge area, then padding(16) with title (2 lines) + description
  // (2 lines) + "VIEW DETAILS" action label.

  Widget _buildCourseSkeleton(ThemeData theme) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(24),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Image section — mirrors SizedBox(height:180) in CourseCard
          Stack(
            children: [
              Container(height: 180, color: Colors.white),
              // Gradient overlay area (bottom of image)
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.3),
                  ),
                ),
              ),
              // Status badge bone at bottom-left
              Positioned(
                left: 16,
                bottom: 16,
                child: _bone(
                  theme,
                  width: 56,
                  height: 22,
                  radius: BorderRadius.circular(12),
                ),
              ),
            ],
          ),
          // Content section — mirrors _buildContentSection padding(16)
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Course name — titleLarge, up to 2 lines
                _bone(
                  theme,
                  width: double.infinity,
                  height: 18,
                  radius: BorderRadius.circular(6),
                ),
                const SizedBox(height: 6),
                _bone(
                  theme,
                  width: 200,
                  height: 18,
                  radius: BorderRadius.circular(6),
                ),
                const SizedBox(height: 10),
                // Description — bodySmall, up to 2 lines
                _bone(
                  theme,
                  width: double.infinity,
                  height: 12,
                  radius: BorderRadius.circular(5),
                ),
                const SizedBox(height: 5),
                _bone(
                  theme,
                  width: 180,
                  height: 12,
                  radius: BorderRadius.circular(5),
                ),
                const SizedBox(height: 14),
                // Action label — "VIEW DETAILS"
                _bone(
                  theme,
                  width: 90,
                  height: 10,
                  radius: BorderRadius.circular(4),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ─── Transaction ─────────────────────────────────────────────────────────

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
