import 'package:bourgo_arena_mobile/presentation/common/widgets/brand_logo.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';

/// A shared header for authentication screens.
class AuthHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool? showBackButton;

  final Color? subtitleColor;

  const AuthHeader({
    super.key,
    required this.title,
    required this.subtitle,
    this.showBackButton,
    this.subtitleColor,
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
            icon: Icon(Symbols.arrow_back, color: theme.colorScheme.onSurface),
            padding: EdgeInsets.zero,
            alignment: Alignment.centerLeft,
          ),
          const SizedBox(height: 16),
        ],
        const BrandLogo(size: 48, heroTag: 'app_logo'),
        const SizedBox(height: 24),
        Text(
          title,
          style: theme.textTheme.headlineLarge?.copyWith(
            color: theme.colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          subtitle,
          style: theme.textTheme.bodyLarge?.copyWith(
            color: subtitleColor ?? theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}
