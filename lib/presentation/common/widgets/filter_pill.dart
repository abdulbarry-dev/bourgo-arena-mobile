import 'package:bourgo_arena_mobile/core/theme/bourgo_theme.dart';
import 'package:bourgo_arena_mobile/core/utils/haptic_utils.dart';
import 'package:flutter/material.dart';

class FilterPill extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final IconData? icon;
  final bool hapticFeedback;

  const FilterPill({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onTap,
    this.icon,
    this.hapticFeedback = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = theme.extension<AppColors>()!;

    return InkWell(
      onTap: () {
        if (hapticFeedback) AppHaptics.selection();
        onTap();
      },
      borderRadius: BorderRadius.circular(30),
      child: AnimatedContainer(
        duration: context.anim.normal,
        curve: Curves.easeOutCubic,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? theme.colorScheme.primary : appColors.bgElevated,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            color: isSelected ? theme.colorScheme.primary : appColors.bgBorder,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(
                icon,
                size: 16,
                color: isSelected
                    ? theme.colorScheme.onPrimary
                    : theme.colorScheme.onSurface,
              ),
              const SizedBox(width: 6),
            ],
            Text(
              label,
              style: context.typography.sectionTitle?.copyWith(
                color: isSelected
                    ? theme.colorScheme.onPrimary
                    : theme.colorScheme.onSurface,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
