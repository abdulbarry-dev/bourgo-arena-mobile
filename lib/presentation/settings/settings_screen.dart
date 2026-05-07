import 'package:bourgo_arena_mobile/l10n/app_localizations.dart';
import 'package:bourgo_arena_mobile/presentation/settings/viewmodels/settings_view_model.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';

/// A professional settings screen for application configuration.
class SettingsScreen extends StatelessWidget {
  final SettingsViewModel viewModel;

  const SettingsScreen({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          l10n.settingsTitle,
          style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 20),
        ),
        centerTitle: true,
      ),
      body: AnimatedBuilder(
        animation: viewModel,
        builder: (context, _) {
          return ListView(
            padding: const EdgeInsets.symmetric(vertical: 16),
            children: [
              _SettingsSection(
                title: l10n.settingsSectionAccount,
                children: [
                  _SettingsTile(
                    icon: Symbols.person,
                    title: l10n.settingsEditProfile,
                    onTap: () => context.push('/edit-profile'),
                  ),
                  _SettingsTile(
                    icon: Symbols.lock,
                    title: l10n.settingsChangePassword,
                    onTap: () => context.push('/change-password'),
                  ),
                  _SettingsTile(
                    icon: Symbols.family_restroom,
                    title: l10n.settingsManageFamily,
                    onTap: () => context.push('/family-management'),
                  ),
                ],
              ),
              const Divider(height: 32, indent: 16, endIndent: 16),
              _SettingsSection(
                title: l10n.settingsSectionPreferences,
                children: [
                  _SettingsTile(
                    icon: Symbols.language,
                    title: l10n.settingsLanguage,
                    trailing: Text(
                      viewModel.locale.languageCode.toUpperCase(),
                      style: TextStyle(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onTap: () => _showLanguageDialog(context, l10n),
                  ),
                  _SettingsTile(
                    icon: Symbols.dark_mode,
                    title: l10n.settingsTheme,
                    trailing: Text(
                      _getThemeName(viewModel.themeMode, l10n),
                      style: TextStyle(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onTap: () => _showThemeDialog(context, l10n),
                  ),
                  _SettingsSwitchTile(
                    icon: Symbols.notifications,
                    title: l10n.settingsPushNotifications,
                    value: viewModel.notificationsEnabled,
                    onChanged: viewModel.toggleNotifications,
                  ),
                ],
              ),
              const Divider(height: 32, indent: 16, endIndent: 16),
              _SettingsSection(
                title: l10n.settingsSectionLegal,
                children: [
                  _SettingsTile(
                    icon: Symbols.description,
                    title: l10n.settingsTerms,
                    onTap: () => context.push('/terms'),
                  ),
                  _SettingsTile(
                    icon: Symbols.policy,
                    title: l10n.settingsPrivacy,
                    onTap: () => context.push('/privacy'),
                  ),
                ],
              ),
              const Divider(height: 32, indent: 16, endIndent: 16),
              _SettingsSection(
                title: l10n.settingsSectionAbout,
                children: [
                  _SettingsTile(
                    icon: Symbols.info,
                    title: l10n.settingsAppVersion,
                    trailing: Text(
                      '1.0.0 (1)',
                      style: TextStyle(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    showArrow: false,
                  ),
                ],
              ),
              const SizedBox(height: 32),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: OutlinedButton.icon(
                  onPressed: () => _showDeleteAccountDialog(context, l10n),
                  icon: const Icon(Symbols.delete, size: 20),
                  label: Text(l10n.settingsDeleteAccount),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: theme.colorScheme.error,
                    side: BorderSide(color: theme.colorScheme.error),
                    padding: const EdgeInsets.all(16),
                  ),
                ),
              ),
              const SizedBox(height: 40),
            ],
          );
        },
      ),
    );
  }

  String _getThemeName(ThemeMode mode, AppLocalizations l10n) {
    switch (mode) {
      case ThemeMode.system:
        return l10n.settingsThemeSystem;
      case ThemeMode.light:
        return l10n.settingsThemeLight;
      case ThemeMode.dark:
        return l10n.settingsThemeDark;
    }
  }

  void _showLanguageDialog(BuildContext context, AppLocalizations l10n) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.settingsLanguage),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<String>(
              title: const Text('English'),
              value: 'en',
              // ignore: deprecated_member_use
              groupValue: viewModel.locale.languageCode,
              // ignore: deprecated_member_use
              onChanged: (val) {
                if (val != null) {
                  viewModel.updateLocale(Locale(val));
                  Navigator.pop(context);
                }
              },
            ),
            RadioListTile<String>(
              title: const Text('Français'),
              value: 'fr',
              // ignore: deprecated_member_use
              groupValue: viewModel.locale.languageCode,
              // ignore: deprecated_member_use
              onChanged: (val) {
                if (val != null) {
                  viewModel.updateLocale(Locale(val));
                  Navigator.pop(context);
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showThemeDialog(BuildContext context, AppLocalizations l10n) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.settingsTheme),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<ThemeMode>(
              title: Text(l10n.settingsThemeSystem),
              value: ThemeMode.system,
              // ignore: deprecated_member_use
              groupValue: viewModel.themeMode,
              // ignore: deprecated_member_use
              onChanged: (val) {
                if (val != null) {
                  viewModel.updateThemeMode(val);
                  Navigator.pop(context);
                }
              },
            ),
            RadioListTile<ThemeMode>(
              title: Text(l10n.settingsThemeLight),
              value: ThemeMode.light,
              // ignore: deprecated_member_use
              groupValue: viewModel.themeMode,
              // ignore: deprecated_member_use
              onChanged: (val) {
                if (val != null) {
                  viewModel.updateThemeMode(val);
                  Navigator.pop(context);
                }
              },
            ),
            RadioListTile<ThemeMode>(
              title: Text(l10n.settingsThemeDark),
              value: ThemeMode.dark,
              // ignore: deprecated_member_use
              groupValue: viewModel.themeMode,
              // ignore: deprecated_member_use
              onChanged: (val) {
                if (val != null) {
                  viewModel.updateThemeMode(val);
                  Navigator.pop(context);
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteAccountDialog(BuildContext context, AppLocalizations l10n) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.settingsConfirmDeleteTitle),
        content: Text(l10n.settingsConfirmDeleteMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.settingsCancel),
          ),
          TextButton(
            onPressed: () {
              // Handle account deletion
              Navigator.pop(context);
            },
            child: Text(
              l10n.settingsDelete,
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          ),
        ],
      ),
    );
  }
}

class _SettingsSection extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const _SettingsSection({required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Theme.of(
                context,
              ).colorScheme.primary.withValues(alpha: 0.7),
              letterSpacing: 1.2,
            ),
          ),
        ),
        ...children,
      ],
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final Widget? trailing;
  final VoidCallback? onTap;
  final bool showArrow;
  const _SettingsTile({
    required this.icon,
    required this.title,
    this.trailing,
    this.onTap,
    this.showArrow = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final Widget? trailingWidget = trailing;

    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: theme.colorScheme.onSurface.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, size: 20, color: theme.colorScheme.onSurfaceVariant),
      ),
      title: Text(
        title,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          ?trailingWidget,
          if (showArrow) ...[
            const SizedBox(width: 8),
            Icon(
              Symbols.chevron_right,
              size: 20,
              color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.3),
            ),
          ],
        ],
      ),
      onTap: onTap,
    );
  }
}

class _SettingsSwitchTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _SettingsSwitchTile({
    required this.icon,
    required this.title,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: theme.colorScheme.onSurface.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, size: 20, color: theme.colorScheme.onSurfaceVariant),
      ),
      title: Text(
        title,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
      ),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeTrackColor: theme.colorScheme.primary,
      ),
    );
  }
}
