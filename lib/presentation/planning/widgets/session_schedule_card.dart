import 'package:bourgo_arena_mobile/core/constants/app_constants.dart';
import 'package:bourgo_arena_mobile/core/theme/bourgo_theme.dart';
import 'package:bourgo_arena_mobile/presentation/common/widgets/premium_network_image.dart';
import 'package:bourgo_arena_mobile/presentation/planning/planning_view_model.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:bourgo_arena_mobile/l10n/app_localizations.dart';

class SessionScheduleCard extends StatelessWidget {
  final PlanningEntry entry;
  final VoidCallback? onTap;
  final VoidCallback? onReserve;
  final bool isBooked;

  const SessionScheduleCard({
    super.key,
    required this.entry,
    this.onTap,
    this.onReserve,
    this.isBooked = false,
  });

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
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildImage(theme),
              Expanded(child: _buildContent(theme, appColors)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImage(ThemeData theme) {
    final hasImage = entry.imageUrl != null && entry.imageUrl!.isNotEmpty;

    return SizedBox(
      width: 88,
      child: hasImage
          ? PremiumNetworkImage(imageUrl: entry.imageUrl!, fit: BoxFit.cover)
          : Container(
              color: theme.colorScheme.surfaceContainerHighest,
              child: Icon(
                Symbols.school,
                size: 32,
                color: theme.colorScheme.primary.withValues(alpha: 0.3),
              ),
            ),
    );
  }

  Widget _buildContent(ThemeData theme, AppColors appColors) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            entry.title.toUpperCase(),
            style: theme.textTheme.titleMedium?.copyWith(
              fontFamily: AppConstants.displayFontFamily,
              fontWeight: FontWeight.w900,
              fontSize: 15,
              letterSpacing: 0.5,
              color: theme.colorScheme.onSurface,
              height: 1.1,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 6),
          Text(
            entry.formattedTime,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(child: _buildCapacityBar(theme)),
              const SizedBox(width: 12),
              _buildActionButton(theme),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCapacityBar(ThemeData theme) {
    final ratio = entry.capacity > 0 ? entry.enrolled / entry.capacity : 0.0;
    final remaining = entry.capacity - entry.enrolled;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: SizedBox(
            height: 4,
            child: Row(
              children: [
                Flexible(
                  flex: (ratio * 100).round().clamp(1, 100),
                  child: Container(
                    color: entry.isFull
                        ? theme.colorScheme.error
                        : theme.colorScheme.primary,
                  ),
                ),
                Flexible(
                  flex: ((1 - ratio) * 100).round().clamp(1, 100),
                  child: Container(color: theme.colorScheme.outlineVariant),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          isBooked
              ? AppLocalizations.of(context)!.statusBooked
              : entry.isFull
              ? AppLocalizations.of(context)!.statusFull
              : AppLocalizations.of(context)!.remainingPlaces(remaining),
          style: theme.textTheme.labelSmall?.copyWith(
            color: isBooked
                ? theme.colorScheme.primary
                : entry.isFull
                ? theme.colorScheme.error
                : theme.colorScheme.onSurfaceVariant,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.5,
            fontFamily: GoogleFonts.lexend().fontFamily,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton(ThemeData theme) {
    if (isBooked) {
      return SizedBox(
        height: 32,
        child: OutlinedButton.icon(
          onPressed: null,
          icon: Icon(Symbols.check, size: 14),
          label: Text(AppLocalizations.of(context)!.statusBooked),
          style: OutlinedButton.styleFrom(
            disabledForegroundColor: theme.colorScheme.primary,
            side: BorderSide(
              color: theme.colorScheme.primary.withValues(alpha: 0.4),
              width: 1.5,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 12),
            minimumSize: Size.zero,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            textStyle: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.8,
              fontFamily: GoogleFonts.lexend().fontFamily,
            ),
          ),
        ),
      );
    }

    return SizedBox(
      height: 32,
      child: ElevatedButton(
        onPressed: entry.isFull ? null : onReserve,
        style: ElevatedButton.styleFrom(
          backgroundColor: theme.colorScheme.primary,
          foregroundColor: theme.colorScheme.onPrimary,
          disabledBackgroundColor: theme.colorScheme.surfaceContainerHighest,
          disabledForegroundColor: theme.colorScheme.onSurfaceVariant,
          padding: const EdgeInsets.symmetric(horizontal: 14),
          minimumSize: Size.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          textStyle: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w800,
            letterSpacing: 0.8,
            fontFamily: GoogleFonts.lexend().fontFamily,
          ),
        ),
        child: Text(
          entry.isFull
              ? AppLocalizations.of(context)!.statusFull
              : AppLocalizations.of(context)!.reserveAction,
        ),
      ),
    );
  }
}
