import 'package:bourgo_arena_mobile/l10n/app_localizations.dart';
import 'package:bourgo_arena_mobile/core/constants/app_constants.dart';
import 'package:bourgo_arena_mobile/core/theme/bourgo_theme.dart';
import 'package:bourgo_arena_mobile/domain/entities/activity.dart';
import 'package:bourgo_arena_mobile/presentation/common/widgets/premium_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_symbols_icons/symbols.dart';

class ActivityCard extends StatelessWidget {
  final Activity activity;
  final VoidCallback? onTap;
  final bool isFullWidth;

  const ActivityCard({
    super.key,
    required this.activity,
    this.onTap,
    this.isFullWidth = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = theme.extension<AppColors>()!;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: isFullWidth ? double.infinity : null,
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
          children: [
            _ImageSection(activity: activity),
            _ContentSection(activity: activity),
          ],
        ),
      ),
    );
  }
}

class _ImageSection extends StatelessWidget {
  final Activity activity;

  const _ImageSection({required this.activity});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SizedBox(
      height: 180,
      child: Stack(
        fit: StackFit.expand,
        children: [
          if (activity.imageUrl.isNotEmpty)
            PremiumNetworkImage(imageUrl: activity.imageUrl, fit: BoxFit.cover)
          else
            Container(
              color: theme.colorScheme.surfaceContainerHighest,
              child: Icon(
                Icons.sports,
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
          Positioned(
            left: 16,
            bottom: 16,
            child: _PriceBadge(price: activity.basePrice, theme: theme),
          ),
        ],
      ),
    );
  }
}

class _ContentSection extends StatelessWidget {
  final Activity activity;

  const _ContentSection({required this.activity});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = theme.extension<AppColors>()!;
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            activity.title.toUpperCase(),
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
          if (activity.description.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              activity.description,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                height: 1.4,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
          if (activity.features.isNotEmpty) ...[
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 6,
              children: activity.features
                  .take(4)
                  .map(
                    (f) => _FeatureChip(
                      label: f,
                      theme: theme,
                      appColors: appColors,
                    ),
                  )
                  .toList(),
            ),
          ],
          const SizedBox(height: 12),
          Row(
            children: [
              _ActionLabel(theme: theme),
              const Spacer(),
              if (activity.capacity != null)
                _CapacityBadge(count: activity.capacity!, theme: theme),
            ],
          ),
        ],
      ),
    );
  }
}

class _PriceBadge extends StatelessWidget {
  final double price;
  final ThemeData theme;

  const _PriceBadge({required this.price, required this.theme});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        '${price.toStringAsFixed(0)} TND',
        style: TextStyle(
          color: theme.colorScheme.onPrimary,
          fontWeight: FontWeight.w900,
          fontSize: 14,
          fontFamily: GoogleFonts.lexend().fontFamily,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}

class _FeatureChip extends StatelessWidget {
  final String label;
  final ThemeData theme;
  final AppColors appColors;

  const _FeatureChip({
    required this.label,
    required this.theme,
    required this.appColors,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: theme.colorScheme.primary.withValues(alpha: 0.15),
        ),
      ),
      child: Text(
        label.replaceAll('-', ' '),
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: theme.colorScheme.primary,
          letterSpacing: 0.3,
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
      AppLocalizations.of(context)!.homeActivityExploreButton,
      style: theme.textTheme.labelSmall?.copyWith(
        color: theme.colorScheme.primary,
        fontWeight: FontWeight.w900,
        letterSpacing: 2,
        fontFamily: GoogleFonts.lexend().fontFamily,
      ),
    );
  }
}

class _CapacityBadge extends StatelessWidget {
  final int count;
  final ThemeData theme;

  const _CapacityBadge({required this.count, required this.theme});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Symbols.group,
          size: 14,
          color: theme.colorScheme.onSurfaceVariant,
        ),
        const SizedBox(width: 4),
        Text(
          '$count',
          style: theme.textTheme.labelSmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
