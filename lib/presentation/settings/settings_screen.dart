import 'package:bourgo_arena_mobile/core/constants/app_constants.dart';
import 'package:bourgo_arena_mobile/core/theme/bourgo_theme.dart';
import 'package:bourgo_arena_mobile/l10n/app_localizations.dart';
import 'package:bourgo_arena_mobile/presentation/auth/widgets/auth_text_field.dart';
import 'package:bourgo_arena_mobile/presentation/settings/viewmodels/settings_view_model.dart';
import 'package:bourgo_arena_mobile/presentation/settings/terms_of_service_screen.dart';
import 'package:bourgo_arena_mobile/presentation/settings/privacy_policy_screen.dart';
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
    final appColors = theme.extension<AppColors>()!;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: theme.colorScheme.primaryContainer.withValues(
                  alpha: 0.5,
                ),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(
                Symbols.settings,
                color: theme.colorScheme.primary,
                size: 22,
              ),
            ),
            const SizedBox(width: 16),
            Text(
              l10n.settingsTitle,
              style: theme.textTheme.headlineSmall?.copyWith(
                fontFamily: AppConstants.displayFontFamily,
                fontWeight: FontWeight.w900,
                letterSpacing: 0.5,
                color: theme.colorScheme.onSurface,
              ),
            ),
          ],
        ),
        backgroundColor: appColors.bgSurface.withValues(alpha: 0.9),
      ),
      body: AnimatedBuilder(
        animation: viewModel,
        builder: (context, _) {
          return ListView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
            children: [
              _SettingsSection(
                title: l10n.settingsSectionAccount.toUpperCase(),
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
                    isLast: true,
                  ),
                ],
              ),
              const SizedBox(height: 32),
              _SettingsSection(
                title: l10n.settingsSectionPreferences.toUpperCase(),
                children: [
                  _SettingsTile(
                    icon: Symbols.language,
                    title: l10n.settingsLanguage,
                    trailingText: viewModel.locale.languageCode.toUpperCase(),
                    onTap: () => _showLanguageModal(context, l10n),
                  ),
                  _SettingsTile(
                    icon: Symbols.dark_mode,
                    title: l10n.settingsTheme,
                    trailingText: _getThemeName(viewModel.themeMode, l10n),
                    onTap: () => _showThemeModal(context, l10n),
                  ),
                  _SettingsTile(
                    icon: Symbols.notifications,
                    title: l10n.settingsPushNotifications,
                    onTap: () => context.push('/notifications-preferences'),
                    isLast: true,
                  ),
                ],
              ),
              const SizedBox(height: 32),
              _SettingsSection(
                title: l10n.settingsSectionLegal.toUpperCase(),
                children: [
                  _SettingsTile(
                    icon: Symbols.description,
                    title: l10n.settingsTerms,
                    onTap: () =>
                        _showModalSheet(context, const TermsOfServiceScreen()),
                  ),
                  _SettingsTile(
                    icon: Symbols.policy,
                    title: l10n.settingsPrivacy,
                    onTap: () =>
                        _showModalSheet(context, const PrivacyPolicyScreen()),
                    isLast: true,
                  ),
                ],
              ),
              const SizedBox(height: 32),
              _SettingsSection(
                title: l10n.settingsSectionAbout.toUpperCase(),
                children: [
                  _SettingsTile(
                    icon: Symbols.info,
                    title: l10n.settingsAppVersion,
                    trailingText: viewModel.appVersion,
                    showArrow: false,
                    isLast: true,
                  ),
                ],
              ),
              const SizedBox(height: 48),
              OutlinedButton.icon(
                onPressed: () => _showDeleteAccountModal(context, l10n),
                icon: const Icon(Symbols.delete, size: 20),
                label: Text(l10n.settingsDeleteAccount.toUpperCase()),
                style: OutlinedButton.styleFrom(
                  foregroundColor: theme.colorScheme.error,
                  side: BorderSide(
                    color: theme.colorScheme.error.withValues(alpha: 0.5),
                    width: 1.5,
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  textStyle: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.2,
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

  void _showModalSheet(BuildContext context, Widget child) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.85,
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.only(top: 12, bottom: 8),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Expanded(child: child),
            ],
          ),
        ),
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

  void _showLanguageModal(BuildContext context, AppLocalizations l10n) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildSelectionModal(
        context: context,
        title: l10n.settingsLanguage,
        icon: Symbols.language,
        children: [
          _SelectionTile<String>(
            title: l10n.languageEnglish,
            value: 'en',
            groupValue: viewModel.locale.languageCode,
            onChanged: (val) {
              viewModel.updateLocale(Locale(val));
              Navigator.pop(context);
            },
          ),
          _SelectionTile<String>(
            title: l10n.languageFrench,
            value: 'fr',
            groupValue: viewModel.locale.languageCode,
            onChanged: (val) {
              viewModel.updateLocale(Locale(val));
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  void _showThemeModal(BuildContext context, AppLocalizations l10n) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildSelectionModal(
        context: context,
        title: l10n.settingsTheme,
        icon: Symbols.dark_mode,
        children: [
          _SelectionTile<ThemeMode>(
            title: l10n.settingsThemeSystem,
            value: ThemeMode.system,
            groupValue: viewModel.themeMode,
            onChanged: (val) {
              viewModel.updateThemeMode(val);
              Navigator.pop(context);
            },
          ),
          _SelectionTile<ThemeMode>(
            title: l10n.settingsThemeLight,
            value: ThemeMode.light,
            groupValue: viewModel.themeMode,
            onChanged: (val) {
              viewModel.updateThemeMode(val);
              Navigator.pop(context);
            },
          ),
          _SelectionTile<ThemeMode>(
            title: l10n.settingsThemeDark,
            value: ThemeMode.dark,
            groupValue: viewModel.themeMode,
            onChanged: (val) {
              viewModel.updateThemeMode(val);
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSelectionModal({
    required BuildContext context,
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    final theme = Theme.of(context);
    final appColors = theme.extension<AppColors>()!;

    return Container(
      padding: const EdgeInsets.all(
        24,
      ).copyWith(bottom: MediaQuery.of(context).padding.bottom + 24),
      decoration: BoxDecoration(
        color: appColors.bgElevated,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
        border: Border.all(color: appColors.bgBorder, width: 1),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 48,
            height: 4,
            margin: const EdgeInsets.only(bottom: 24),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: appColors.brandPrimaryGhost,
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: theme.colorScheme.primary, size: 20),
              ),
              const SizedBox(width: 16),
              Text(
                title.toUpperCase(),
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.0,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Container(
            decoration: BoxDecoration(
              color: appColors.bgSurface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: appColors.bgBorder),
            ),
            child: Column(children: children),
          ),
        ],
      ),
    );
  }

  void _showDeleteAccountModal(BuildContext context, AppLocalizations l10n) {
    final passwordController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (dialogContext) {
        final theme = Theme.of(context);
        final appColors = theme.extension<AppColors>()!;

        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(dialogContext).viewInsets.bottom,
          ),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: appColors.bgElevated,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(32),
              ),
              border: Border.all(
                color: theme.colorScheme.error.withValues(alpha: 0.3),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 48,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 24),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.error.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Symbols.warning,
                    color: theme.colorScheme.error,
                    size: 32,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  l10n.settingsConfirmDeleteTitle.toUpperCase(),
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w900,
                    color: theme.colorScheme.error,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  l10n.settingsConfirmDeleteMessage,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: Colors.white.withValues(alpha: 0.7),
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 24),
                AuthTextField(
                  label: l10n.passwordCurrentLabel,
                  hint: l10n.passwordCurrentHint,
                  controller: passwordController,
                  isPassword: true,
                  leadingIcon: Symbols.lock,
                ),
                const SizedBox(height: 32),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(dialogContext),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          side: BorderSide(color: appColors.bgBorder),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          l10n.settingsCancel.toUpperCase(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () async {
                          final pwd = passwordController.text.trim();
                          if (pwd.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(l10n.settingsEnterPasswordFirst),
                              ),
                            );
                            return;
                          }

                          final success = await viewModel.deleteAccount(
                            password: pwd,
                          );
                          if (success && context.mounted) {
                            Navigator.pop(dialogContext);
                            context.go('/login');
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: theme.colorScheme.error,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          l10n.settingsDelete.toUpperCase(),
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _SelectionTile<T> extends StatelessWidget {
  final String title;
  final T value;
  final T groupValue;
  final ValueChanged<T> onChanged;

  const _SelectionTile({
    required this.title,
    required this.value,
    required this.groupValue,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isSelected = value == groupValue;

    return InkWell(
      onTap: () => onChanged(value),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: theme.textTheme.bodyLarge?.copyWith(
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected ? theme.colorScheme.primary : Colors.white,
              ),
            ),
            if (isSelected)
              Icon(Symbols.check, color: theme.colorScheme.primary, size: 20),
          ],
        ),
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
    final appColors = Theme.of(context).extension<AppColors>()!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16, bottom: 12),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w900,
              color: Colors.white.withValues(alpha: 0.4),
              letterSpacing: 1.5,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: appColors.bgElevated,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: appColors.bgBorder, width: 1),
          ),
          child: Column(children: children),
        ),
      ],
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? trailingText;
  final VoidCallback? onTap;
  final bool showArrow;
  final bool isLast;

  const _SettingsTile({
    required this.icon,
    required this.title,
    this.trailingText,
    this.onTap,
    this.showArrow = true,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = theme.extension<AppColors>()!;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.vertical(
        top: isLast ? Radius.zero : const Radius.circular(20),
        bottom: isLast ? const Radius.circular(20) : Radius.zero,
      ),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: isLast
              ? null
              : Border(bottom: BorderSide(color: appColors.bgBorder, width: 1)),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: appColors.brandPrimaryGhost,
                shape: BoxShape.circle,
                border: Border.all(
                  color: theme.colorScheme.primary.withValues(alpha: 0.2),
                ),
              ),
              child: Icon(icon, size: 20, color: theme.colorScheme.primary),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
            if (trailingText != null)
              Text(
                trailingText!,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.primary,
                ),
              ),
            if (showArrow) ...[
              const SizedBox(width: 8),
              Icon(
                Symbols.chevron_right,
                size: 20,
                color: Colors.white.withValues(alpha: 0.3),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _SettingsSwitchTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final bool value;
  final ValueChanged<bool> onChanged;
  final bool isLast;

  const _SettingsSwitchTile({
    required this.icon,
    required this.title,
    required this.value,
    required this.onChanged,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = theme.extension<AppColors>()!;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: isLast
            ? null
            : Border(bottom: BorderSide(color: appColors.bgBorder, width: 1)),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: appColors.brandPrimaryGhost,
              shape: BoxShape.circle,
              border: Border.all(
                color: theme.colorScheme.primary.withValues(alpha: 0.2),
              ),
            ),
            child: Icon(icon, size: 20, color: theme.colorScheme.primary),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeTrackColor: theme.colorScheme.primary,
            activeThumbColor: theme.colorScheme.surface,
            inactiveTrackColor: appColors.bgSurface,
            inactiveThumbColor: Colors.white.withValues(alpha: 0.6),
          ),
        ],
      ),
    );
  }
}
