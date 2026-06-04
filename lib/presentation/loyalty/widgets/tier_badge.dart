import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

/// A badge component displaying the user's loyalty tier with an Indigo theme.
class TierBadge extends StatelessWidget {
  final String tierName;

  const TierBadge({super.key, required this.tierName});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Using Indigo-like color from the app's primary seed (if it's blue-based)
    // or falling back to a direct Indigo shade.
    final color = theme.colorScheme.primary;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withAlpha(20),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withAlpha(100)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Symbols.stars, size: 16, color: color),
          const SizedBox(width: 6),
          Text(
            tierName.toUpperCase(),
            style: theme.textTheme.labelSmall?.copyWith(
              color: color,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}
