import 'package:bourgo_arena_mobile/core/constants/app_constants.dart';
import 'package:bourgo_arena_mobile/core/theme/bourgo_theme.dart';
import 'package:bourgo_arena_mobile/domain/entities/course.dart';
import 'package:bourgo_arena_mobile/presentation/common/widgets/premium_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:bourgo_arena_mobile/l10n/app_localizations.dart';

class CourseCard extends StatelessWidget {
  final Course course;
  final VoidCallback? onTap;

  const CourseCard({super.key, required this.course, this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = theme.extension<AppColors>()!;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: appColors.bgElevated,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: appColors.bgBorder),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [_buildImageSection(theme), _buildContentSection(theme)],
        ),
      ),
    );
  }

  Widget _buildImageSection(ThemeData theme) {
    final hasImage = course.images.isNotEmpty;

    return SizedBox(
      height: 180,
      child: Stack(
        fit: StackFit.expand,
        children: [
          if (hasImage)
            PremiumNetworkImage(
              imageUrl: course.images.first,
              fit: BoxFit.cover,
            )
          else
            Container(
              color: theme.colorScheme.surfaceContainerHighest,
              child: Icon(
                Symbols.school,
                size: 48,
                color: theme.colorScheme.primary.withValues(alpha: 0.3),
              ),
            ),
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withValues(alpha: 0.6),
                  ],
                  stops: const [0.6, 1.0],
                ),
              ),
            ),
          ),
          if (course.status != null)
            Positioned(
              left: 16,
              bottom: 16,
              child: _StatusBadge(status: course.status!, theme: theme),
            ),
        ],
      ),
    );
  }

  Widget _buildContentSection(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            course.name.toUpperCase(),
            style: theme.textTheme.titleLarge?.copyWith(
              fontFamily: AppConstants.displayFontFamily,
              fontWeight: FontWeight.w900,
              fontSize: 18,
              letterSpacing: 0.5,
              color: theme.colorScheme.onSurface,
              height: 1.1,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          if (course.description != null && course.description!.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              course.description!,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                height: 1.4,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
          const SizedBox(height: 12),
          _ActionLabel(theme: theme),
        ],
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final String status;
  final ThemeData theme;

  const _StatusBadge({required this.status, required this.theme});

  @override
  Widget build(BuildContext context) {
    final isActive = status == 'active';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isActive
            ? theme.colorScheme.primary
            : theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        status.toUpperCase(),
        style: TextStyle(
          color: theme.colorScheme.onPrimary,
          fontWeight: FontWeight.w900,
          fontSize: 12,
          fontFamily: GoogleFonts.lexend().fontFamily,
          letterSpacing: 1,
        ),
      ),
    );
  }
}

class _ActionLabel extends StatelessWidget {
  final ThemeData theme;

  const _ActionLabel({required this.theme});

  @override
  Widget build(BuildContext context) {
    return Text(
      AppLocalizations.of(context)!.viewDetailsLabel,
      style: theme.textTheme.labelSmall?.copyWith(
        color: theme.colorScheme.primary,
        fontWeight: FontWeight.w900,
        letterSpacing: 2,
        fontFamily: GoogleFonts.lexend().fontFamily,
      ),
    );
  }
}
