import 'package:bourgo_arena_mobile/core/constants/app_constants.dart';
import 'package:bourgo_arena_mobile/core/theme/bourgo_theme.dart';
import 'package:bourgo_arena_mobile/l10n/app_localizations.dart';
import 'package:bourgo_arena_mobile/presentation/auth/widgets/auth_text_field.dart';
import '../common/widgets/app_toast.dart';
import 'package:bourgo_arena_mobile/presentation/common/widgets/confirm_action_modal.dart';
import 'package:bourgo_arena_mobile/presentation/settings/viewmodels/settings_view_model.dart';
import 'package:bourgo_arena_mobile/presentation/settings/terms_of_service_screen.dart';
import 'package:bourgo_arena_mobile/presentation/settings/privacy_policy_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:google_fonts/google_fonts.dart';

/// A professional settings screen for application configuration.
class SettingsScreen extends StatelessWidget {
  final SettingsViewModel viewModel;

  const SettingsScreen({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final spacing = context.spacing;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => context.pop(),
          color: theme.colorScheme.onSurface,
        ),
        title: Text(
          l10n.settingsTitle.toUpperCase(),
          style: theme.textTheme.titleMedium?.copyWith(
            fontFamily: AppConstants.displayFontFamily,
            fontWeight: FontWeight.w900,
            letterSpacing: 1.5,
            color: theme.colorScheme.onSurface,
          ),
        ),
        backgroundColor: theme.scaffoldBackgroundColor,
      ),
      body: AnimatedBuilder(
        animation: viewModel,
        builder: (context, _) {
          return ListView(
            physics: const BouncingScrollPhysics(),
            padding: spacing.screenPadding(context),
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
                    isLast: true,
                  ),
                ],
              ),
              SizedBox(height: spacing.xl),
              _SettingsSection(
                title: l10n.settingsSectionPreferences,
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
              SizedBox(height: spacing.xl),
              _SettingsSection(
                title: l10n.settingsSectionLegal,
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
              SizedBox(height: spacing.xl),
              _SettingsSection(
                title: l10n.settingsSectionAbout,
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
              SizedBox(height: spacing.xxl),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: spacing.sm),
                child: OutlinedButton.icon(
                  onPressed: () => _showDeleteAccountModal(context, l10n),
                  icon: const Icon(Symbols.delete, size: 20),
                  label: Text(l10n.settingsDeleteAccount.toUpperCase()),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: theme.colorScheme.error,
                    side: BorderSide(
                      color: theme.colorScheme.error.withValues(alpha: 0.3),
                      width: 1.5,
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    textStyle: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.5,
                    ),
                  ),
                ),
              ),
              SizedBox(height: spacing.xxxl),
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
          borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.only(top: 12, bottom: 8),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurface.withValues(alpha: 0.1),
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
    final spacing = context.spacing;

    return Container(
      padding: EdgeInsets.all(
        spacing.lg,
      ).copyWith(bottom: MediaQuery.of(context).padding.bottom + spacing.lg),
      decoration: BoxDecoration(
        color: appColors.bgElevated,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
        border: Border.all(
          color: appColors.bgBorder.withValues(alpha: 0.5),
          width: 1,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.only(bottom: 32),
            decoration: BoxDecoration(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withValues(alpha: 0.08),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: theme.colorScheme.primary, size: 20),
              ),
              const SizedBox(width: 16),
              Text(
                title.toUpperCase(),
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.5,
                  fontFamily: GoogleFonts.lexend().fontFamily,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Container(
            decoration: BoxDecoration(
              color: theme.scaffoldBackgroundColor,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: appColors.bgBorder.withValues(alpha: 0.5),
              ),
            ),
            clipBehavior: Clip.antiAlias,
            child: Column(children: children),
          ),
        ],
      ),
    );
  }

  void _showDeleteAccountModal(BuildContext context, AppLocalizations l10n) {
    final passwordController = TextEditingController();

    ConfirmActionModal.show(
      context: context,
      icon: Symbols.warning,
      title: l10n.settingsConfirmDeleteTitle,
      message: l10n.settingsConfirmDeleteMessage,
      cancelLabel: l10n.settingsCancel,
      confirmLabel: l10n.settingsDelete,
      isDestructive: true,
      content: Padding(
        padding: const EdgeInsets.only(top: 12),
        child: AuthTextField(
          label: l10n.passwordCurrentLabel,
          hint: l10n.passwordCurrentHint,
          controller: passwordController,
          isPassword: true,
          leadingIcon: Symbols.lock,
        ),
      ),
      onConfirm: (dialogContext) async {
        final pwd = passwordController.text.trim();
        if (pwd.isEmpty) {
          AppToast.show(
            dialogContext,
            l10n.settingsEnterPasswordFirst,
            type: AppToastType.warning,
          );
          return false;
        }
        final success = await viewModel.deleteAccount(password: pwd);
        if (success && dialogContext.mounted) {
          context.go('/login');
          return true;
        }
        return false;
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
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: theme.textTheme.bodyLarge?.copyWith(
                fontWeight: isSelected ? FontWeight.w900 : FontWeight.w600,
                color: isSelected
                    ? theme.colorScheme.primary
                    : theme.colorScheme.onSurface,
                fontFamily: GoogleFonts.lexend().fontFamily,
              ),
            ),
            if (isSelected)
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Symbols.check,
                  color: theme.colorScheme.onPrimary,
                  size: 14,
                ),
              ),
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
    final theme = Theme.of(context);
    final appColors = theme.extension<AppColors>()!;
    final spacing = context.spacing;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: spacing.xs, bottom: spacing.sm),
          child: Text(
            title.toUpperCase(),
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
              fontWeight: FontWeight.w900,
              letterSpacing: 2.0,
              fontFamily: GoogleFonts.lexend().fontFamily,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: appColors.bgElevated.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: appColors.bgBorder.withValues(alpha: 0.5),
              width: 1,
            ),
          ),
          clipBehavior: Clip.antiAlias,
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
    final spacing = context.spacing;

    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(spacing.md),
        decoration: BoxDecoration(
          border: isLast
              ? null
              : Border(
                  bottom: BorderSide(
                    color: appColors.bgBorder.withValues(alpha: 0.5),
                    width: 1,
                  ),
                ),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withValues(alpha: 0.08),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 20, color: theme.colorScheme.primary),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: theme.textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: theme.colorScheme.onSurface,
                  fontFamily: GoogleFonts.lexend().fontFamily,
                ),
              ),
            ),
            if (trailingText != null)
              Text(
                trailingText!,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w900,
                  color: theme.colorScheme.primary,
                  fontFamily: AppConstants.displayFontFamily,
                ),
              ),
            if (showArrow) ...[
              const SizedBox(width: 12),
              Icon(
                Icons.chevron_right_rounded,
                size: 20,
                color: theme.colorScheme.onSurface.withValues(alpha: 0.2),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
