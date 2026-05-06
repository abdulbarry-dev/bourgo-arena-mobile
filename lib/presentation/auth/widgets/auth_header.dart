import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';

/// A shared header for authentication screens.
class AuthHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool? showBackButton;

  const AuthHeader({
    super.key,
    required this.title,
    required this.subtitle,
    this.showBackButton,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bool effectiveShowBackButton =
        showBackButton ?? Navigator.of(context).canPop();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (effectiveShowBackButton) ...[
          IconButton(
            onPressed: () => context.pop(),
            icon: const Icon(Symbols.arrow_back, color: Colors.white),
            padding: EdgeInsets.zero,
            alignment: Alignment.centerLeft,
          ),
          const SizedBox(height: 24),
        ],
        Text(
          title,
          style: theme.textTheme.headlineLarge?.copyWith(color: Colors.white),
        ),
        const SizedBox(height: 8),
        Text(
          subtitle,
          style: theme.textTheme.bodyLarge?.copyWith(
            color: theme.colorScheme.onSurface.withAlpha((0.65 * 255).round()),
          ),
        ),
      ],
    );
  }
}
