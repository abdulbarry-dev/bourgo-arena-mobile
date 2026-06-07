import 'package:flutter/material.dart';
import 'package:bourgo_arena_mobile/presentation/home/models/unified_offering.dart';
import 'package:bourgo_arena_mobile/core/theme/bourgo_theme.dart';
import 'package:bourgo_arena_mobile/presentation/common/widgets/premium_network_image.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:bourgo_arena_mobile/core/constants/app_constants.dart';

class UnifiedOfferingCard extends StatelessWidget {
  final UnifiedOffering offering;
  final VoidCallback onTap;

  const UnifiedOfferingCard({
    super.key,
    required this.offering,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = theme.extension<AppColors>()!;
    final typeColor = offering.getTypeColor(theme);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: appColors.bgElevated,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: appColors.bgBorder, width: 1.5),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.2),
              blurRadius: 16,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Image Area
            SizedBox(
              height: 160,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  if (offering.imageUrl != null &&
                      offering.imageUrl!.isNotEmpty)
                    PremiumNetworkImage(
                      imageUrl: offering.imageUrl!,
                      fit: BoxFit.cover,
                    )
                  else
                    Container(
                      color: typeColor.withValues(alpha: 0.1),
                      child: Icon(
                        Symbols.sports_gymnastics,
                        size: 48,
                        color: typeColor.withValues(alpha: 0.4),
                      ),
                    ),
                  // Type Badge
                  Positioned(
                    top: 12,
                    left: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: typeColor,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        offering.typeName,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 1.0,
                        ),
                      ),
                    ),
                  ),
                  // Status Badge
                  if (offering.statusBadge != null)
                    Positioned(
                      top: 12,
                      right: 12,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color:
                              offering.statusColor ?? theme.colorScheme.primary,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          offering.statusBadge!,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 1.0,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            // Content Area
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    offering.title.toUpperCase(),
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontFamily: AppConstants.displayFontFamily,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.0,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (offering.description != null &&
                      offering.description!.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Text(
                      offering.description!,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                        height: 1.4,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                  if (offering.tags.isNotEmpty ||
                      offering.timeInfo != null) ...[
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        if (offering.tags.isNotEmpty)
                          ...offering.tags.map(
                            (tag) => Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: theme.colorScheme.primary.withValues(
                                    alpha: 0.1,
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  tag.toUpperCase(),
                                  style: TextStyle(
                                    color: theme.colorScheme.primary,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        if (offering.timeInfo != null) ...[
                          const Spacer(),
                          Icon(
                            Symbols.schedule,
                            size: 14,
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            offering.timeInfo!,
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
