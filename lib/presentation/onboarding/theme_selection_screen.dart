import 'package:bourgo_arena_mobile/l10n/app_localizations.dart';
import 'package:bourgo_arena_mobile/presentation/auth/widgets/auth_background.dart';
import 'package:bourgo_arena_mobile/presentation/common/widgets/brand_logo.dart';
import 'package:bourgo_arena_mobile/presentation/settings/viewmodels/settings_view_model.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

/// Screen that prompts the user to select their preferred theme.
class ThemeSelectionScreen extends StatefulWidget {
  /// The view model managing app settings.
  final SettingsViewModel viewModel;

  /// Creates a [ThemeSelectionScreen].
  const ThemeSelectionScreen({super.key, required this.viewModel});

  @override
  State<ThemeSelectionScreen> createState() => _ThemeSelectionScreenState();
}

class _ThemeSelectionScreenState extends State<ThemeSelectionScreen> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      body: ListenableBuilder(
        listenable: widget.viewModel,
        builder: (context, _) {
          final currentTheme = widget.viewModel.themeMode;

          return AuthBackground(
            child: SafeArea(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return SingleChildScrollView(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: constraints.maxHeight,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const SizedBox(height: 40),

                            // Brand Header
                            const Center(
                              child: BrandLogo(
                                size: 100,
                                useVertical: true,
                                isPremium: true,
                                heroTag: 'app_logo',
                              ),
                            ),

                            const SizedBox(height: 48),

                            Text(
                              l10n.themeSelectionTitle,
                              textAlign: TextAlign.center,
                              style: theme.textTheme.displaySmall?.copyWith(
                                color: theme.colorScheme.onSurface,
                                fontWeight: FontWeight.w900,
                              ),
                            ),

                            const SizedBox(height: 16),

                            Text(
                              l10n.themeSelectionSubtitle,
                              textAlign: TextAlign.center,
                              style: theme.textTheme.bodyLarge?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ),

                            const SizedBox(height: 48),

                            // Professional Selection UI
                            Column(
                              children: [
                                _ThemeOption(
                                  label: l10n.settingsThemeLight,
                                  icon: Symbols.light_mode,
                                  isSelected: currentTheme == ThemeMode.light,
                                  onTap: () => widget.viewModel.updateThemeMode(
                                    ThemeMode.light,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                _ThemeOption(
                                  label: l10n.settingsThemeDark,
                                  icon: Symbols.dark_mode,
                                  isSelected: currentTheme == ThemeMode.dark,
                                  onTap: () => widget.viewModel.updateThemeMode(
                                    ThemeMode.dark,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                _ThemeOption(
                                  label: l10n.settingsThemeSystem,
                                  icon: Symbols.settings_suggest,
                                  isSelected: currentTheme == ThemeMode.system,
                                  onTap: () => widget.viewModel.updateThemeMode(
                                    ThemeMode.system,
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 48),

                            // Continue Button
                            ElevatedButton(
                              onPressed: () =>
                                  widget.viewModel.confirmThemeSelection(),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: theme.colorScheme.primary,
                                foregroundColor: theme.colorScheme.onPrimary,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                ),
                              ),
                              child: Text(l10n.commonStart),
                            ),

                            const SizedBox(height: 48),

                            // Brand Footer (Official Logo)
                            const Center(
                              child: BrandLogo(size: 32, useVertical: true),
                            ),
                            const SizedBox(height: 24),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}

class _ThemeOption extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _ThemeOption({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      decoration: BoxDecoration(
        color: isSelected
            ? theme.colorScheme.primary.withValues(alpha: 0.1)
            : theme.colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isSelected
              ? theme.colorScheme.primary
              : theme.colorScheme.outline,
          width: 2,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(18),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? theme.colorScheme.primary
                        : theme.colorScheme.surfaceContainerHigh,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Icon(
                      icon,
                      color: isSelected
                          ? theme.colorScheme.onPrimary
                          : theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Text(
                    label,
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: isSelected
                          ? theme.colorScheme.primary
                          : theme.colorScheme.onSurface,
                      fontWeight: isSelected
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                  ),
                ),
                if (isSelected)
                  Icon(Symbols.check_circle, color: theme.colorScheme.primary),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
