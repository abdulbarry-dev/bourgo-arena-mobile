import 'package:bourgo_arena_mobile/core/theme/bourgo_theme.dart';
import 'package:bourgo_arena_mobile/presentation/settings/viewmodels/settings_view_model.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Screen that prompts the user to select their preferred language.
class LanguageSelectionScreen extends StatelessWidget {
  /// The view model managing app settings.
  final SettingsViewModel viewModel;

  /// Creates a [LanguageSelectionScreen].
  const LanguageSelectionScreen({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: Stack(
        children: [
          // Background Gradient
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF1A1F00), // Very dark olive
                  BourgoTheme.bgBase,
                ],
              ),
            ),
          ),

          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Spacer(flex: 2),

                  // Header
                  Text(
                    'Choose Your Language',
                    style: theme.textTheme.displaySmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Choisissez votre langue',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: theme.colorScheme.primary.withValues(alpha: 0.8),
                    ),
                    textAlign: TextAlign.center,
                  ),

                  const Spacer(flex: 1),

                  // Language Options
                  _LanguageCard(
                    title: 'English',
                    subtitle: 'Continue in English',
                    icon: '🇬🇧',
                    isSelected: viewModel.locale.languageCode == 'en',
                    onTap: () => _selectLanguage(context, const Locale('en')),
                  ),

                  const SizedBox(height: 20),

                  _LanguageCard(
                    title: 'Français',
                    subtitle: 'Continuer en Français',
                    icon: '🇫🇷',
                    isSelected: viewModel.locale.languageCode == 'fr',
                    onTap: () => _selectLanguage(context, const Locale('fr')),
                  ),

                  const Spacer(flex: 3),

                  // Brand Footer (Subtle)
                  Center(
                    child: Opacity(
                      opacity: 0.5,
                      child: Text(
                        'BOURGO ARENA',
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: Colors.white,
                          letterSpacing: 4.0,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _selectLanguage(BuildContext context, Locale locale) async {
    await viewModel.updateLocale(locale);
    if (context.mounted) {
      context.go('/'); // Redirect to onboarding
    }
  }
}

class _LanguageCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _LanguageCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      decoration: BoxDecoration(
        color: isSelected
            ? theme.colorScheme.primary.withValues(alpha: 0.1)
            : Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isSelected
              ? theme.colorScheme.primary
              : Colors.white.withValues(alpha: 0.1),
          width: 2,
        ),
        boxShadow: isSelected
            ? [
                BoxShadow(
                  color: theme.colorScheme.primary.withValues(alpha: 0.2),
                  blurRadius: 20,
                  spreadRadius: -5,
                ),
              ]
            : [],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(24),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Row(
              children: [
                // Flag Circle
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(icon, style: const TextStyle(fontSize: 32)),
                  ),
                ),
                const SizedBox(width: 20),

                // Text
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: theme.textTheme.titleLarge?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ),

                // Selection Indicator
                if (isSelected)
                  Icon(
                    Icons.check_circle,
                    color: theme.colorScheme.primary,
                    size: 28,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
