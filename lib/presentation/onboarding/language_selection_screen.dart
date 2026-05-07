import 'package:bourgo_arena_mobile/l10n/app_localizations.dart';
import 'package:bourgo_arena_mobile/presentation/auth/widgets/auth_background.dart';
import 'package:bourgo_arena_mobile/presentation/settings/viewmodels/settings_view_model.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

/// Screen that prompts the user to select their preferred language.
class LanguageSelectionScreen extends StatefulWidget {
  /// The view model managing app settings.
  final SettingsViewModel viewModel;

  /// Creates a [LanguageSelectionScreen].
  const LanguageSelectionScreen({super.key, required this.viewModel});

  @override
  State<LanguageSelectionScreen> createState() =>
      _LanguageSelectionScreenState();
}

class _LanguageSelectionScreenState extends State<LanguageSelectionScreen> {
  late final ValueNotifier<Locale> _selectedLocale;

  @override
  void initState() {
    super.initState();
    _selectedLocale = ValueNotifier<Locale>(widget.viewModel.locale);
  }

  @override
  void dispose() {
    _selectedLocale.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      body: AuthBackground(
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const SizedBox(height: 40),

                        // Brand Header
                        Center(
                          child: Container(
                            padding: const EdgeInsets.all(24),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.primary.withValues(
                                alpha: 0.1,
                              ),
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: theme.colorScheme.primary.withValues(
                                    alpha: 0.1,
                                  ),
                                  blurRadius: 40,
                                  spreadRadius: 10,
                                ),
                              ],
                            ),
                            child: Icon(
                              Symbols.language,
                              size: 64,
                              color: theme.colorScheme.primary,
                            ),
                          ),
                        ),

                        const SizedBox(height: 48),

                        Text(
                          l10n.languageSelectionTitle,
                          textAlign: TextAlign.center,
                          style: theme.textTheme.displaySmall?.copyWith(
                            color: theme.colorScheme.onSurface,
                            fontWeight: FontWeight.w900,
                          ),
                        ),

                        const SizedBox(height: 16),

                        Text(
                          l10n.languageSelectionSubtitle,
                          textAlign: TextAlign.center,
                          style: theme.textTheme.bodyLarge?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),

                        const SizedBox(height: 48),

                        // Professional Selection UI
                        ValueListenableBuilder<Locale>(
                          valueListenable: _selectedLocale,
                          builder: (context, locale, child) {
                            return Column(
                              children: [
                                _LanguageOption(
                                  label: l10n.languageEnglish,
                                  code: 'EN',
                                  isSelected: locale.languageCode == 'en',
                                  onTap: () => _selectedLocale.value =
                                      const Locale('en'),
                                ),
                                const SizedBox(height: 12),
                                _LanguageOption(
                                  label: l10n.languageFrench,
                                  code: 'FR',
                                  isSelected: locale.languageCode == 'fr',
                                  onTap: () => _selectedLocale.value =
                                      const Locale('fr'),
                                ),
                              ],
                            );
                          },
                        ),

                        const SizedBox(height: 48),

                        // Continue Button
                        ValueListenableBuilder<Locale>(
                          valueListenable: _selectedLocale,
                          builder: (context, locale, child) {
                            return ElevatedButton(
                              onPressed: () async {
                                // Await the update to ensure persistence is done
                                await widget.viewModel.updateLocale(locale);
                                // Redirection is handled by the router automatically
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: theme.colorScheme.primary,
                                foregroundColor: theme.colorScheme.onPrimary,
                              ),
                              child: Text(l10n.commonStart),
                            );
                          },
                        ),

                        const SizedBox(height: 32),

                        // Brand Footer (Subtle)
                        Center(
                          child: Opacity(
                            opacity: 0.5,
                            child: Text(
                              'BOURGO ARENA',
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: theme.colorScheme.onSurface,
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
              );
            },
          ),
        ),
      ),
    );
  }
}

class _LanguageOption extends StatelessWidget {
  final String label;
  final String code;
  final bool isSelected;
  final VoidCallback onTap;

  const _LanguageOption({
    required this.label,
    required this.code,
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
                    child: Text(
                      code,
                      style: theme.textTheme.labelLarge?.copyWith(
                        color: isSelected
                            ? theme.colorScheme.onPrimary
                            : theme.colorScheme.onSurfaceVariant,
                        fontWeight: FontWeight.bold,
                      ),
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
