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
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (effectiveShowBackButton) ...[
          Align(
            alignment: Alignment.centerLeft,
            child: IconButton(
              onPressed: () => context.pop(),
              icon: Icon(
                Symbols.arrow_back,
                color: theme.colorScheme.onSurface,
              ),
              padding: EdgeInsets.zero,
            ),
          ),
          const SizedBox(height: 16),
        ],
        const Center(
          child: BrandLogo(
            size: 100,
            useVertical: true,
            isPremium: true,
            heroTag: 'app_logo',
          ),
        ),
        const SizedBox(height: 32),
        Text(
          title,
          textAlign: TextAlign.center,
          style: theme.textTheme.displaySmall?.copyWith(
            color: theme.colorScheme.onSurface,
            fontWeight: FontWeight.w900,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 12),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Text(
            subtitle,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: subtitleColor ?? theme.colorScheme.onSurfaceVariant,
              height: 1.5,
            ),
          ),
        ),
      ],
    );
  }
}
