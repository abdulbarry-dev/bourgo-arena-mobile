import 'package:bourgo_arena_mobile/core/theme/bourgo_theme.dart';
import 'package:bourgo_arena_mobile/l10n/app_localizations.dart';
import 'package:bourgo_arena_mobile/presentation/settings/viewmodels/settings_view_model.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

/// Screen for managing notification preferences.
class NotificationsPreferencesScreen extends StatelessWidget {
  final SettingsViewModel viewModel;

  const NotificationsPreferencesScreen({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => Navigator.pop(context),
          color: theme.colorScheme.onSurface,
        ),
        title: Text(
          l10n.settingsPushNotifications.toUpperCase(),
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w900,
            letterSpacing: 1.5,
          ),
        ),
      ),
      body: AnimatedBuilder(
        animation: viewModel,
        builder: (context, _) {
          return ListView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
            children: [
              _buildSection(
                context: context,
                title: l10n.notifGlobalTitle
                    .toUpperCase(), // Could be localized
                children: [
                  _NotificationSwitchTile(
                    icon: Symbols.notifications_active,
                    title: l10n.notifEnablePush,
                    subtitle: l10n.notifEnablePushSub,
                    value: viewModel.notificationsEnabled,
                    onChanged: viewModel.toggleNotifications,
                    isLast: true,
                  ),
                ],
              ),
              const SizedBox(height: 32),
              AnimatedOpacity(
                duration: const Duration(milliseconds: 300),
                opacity: viewModel.notificationsEnabled ? 1.0 : 0.5,
                child: AbsorbPointer(
                  absorbing: !viewModel.notificationsEnabled,
                  child: Column(
                    children: [
                      _buildSection(
                        context: context,
                        title: l10n.notifPlanningTitle.toUpperCase(),
                        children: [
                          _NotificationSwitchTile(
                            icon: Symbols.calendar_month,
                            title: l10n.notifReservations,
                            subtitle: l10n.notifReservationsSub,
                            value: viewModel.reservationsNotificationsEnabled,
                            onChanged:
                                viewModel.toggleReservationsNotifications,
                          ),
                          _NotificationSwitchTile(
                            icon: Symbols.school,
                            title: l10n.notifCourses,
                            subtitle: l10n.notifCoursesSub,
                            value: viewModel.coursesNotificationsEnabled,
                            onChanged: viewModel.toggleCoursesNotifications,
                            isLast: true,
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      _buildSection(
                        context: context,
                        title: l10n.notifAccountTitle.toUpperCase(),
                        children: [
                          _NotificationSwitchTile(
                            icon: Symbols.card_membership,
                            title: l10n.notifSubscriptions,
                            subtitle: l10n.notifSubscriptionsSub,
                            value: viewModel.subscriptionsNotificationsEnabled,
                            onChanged:
                                viewModel.toggleSubscriptionsNotifications,
                          ),
                          _NotificationSwitchTile(
                            icon: Symbols.warning,
                            title: l10n.notifSecurity,
                            subtitle: l10n.notifSecuritySub,
                            value: viewModel.accountNotificationsEnabled,
                            onChanged: viewModel.toggleAccountNotifications,
                            isLast: true,
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      _buildSection(
                        context: context,
                        title: l10n.notifCommunityTitle.toUpperCase(),
                        children: [
                          if (viewModel.showFamilyManagement)
                            _NotificationSwitchTile(
                              icon: Symbols.family_restroom,
                              title: l10n.notifFamily,
                              subtitle: l10n.notifFamilySub,
                              value: viewModel.familyNotificationsEnabled,
                              onChanged: viewModel.toggleFamilyNotifications,
                            ),
                          _NotificationSwitchTile(
                            icon: Symbols.star,
                            title: l10n.notifLoyalty,
                            subtitle: l10n.notifLoyaltySub,
                            value: viewModel.loyaltyNotificationsEnabled,
                            onChanged: viewModel.toggleLoyaltyNotifications,
                          ),
                          _NotificationSwitchTile(
                            icon: Symbols.campaign,
                            title: l10n.notifPromo,
                            subtitle: l10n.notifPromoSub,
                            value: viewModel.promoNotificationsEnabled,
                            onChanged: viewModel.togglePromoNotifications,
                            isLast: true,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSection({
    required BuildContext context,
    required String title,
    required List<Widget> children,
  }) {
    final appColors = Theme.of(context).extension<AppColors>()!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16, bottom: 12),
          child: Text(
            title.toUpperCase(),
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w900,
              color: Theme.of(
                context,
              ).colorScheme.onSurface.withValues(alpha: 0.4),
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

class _NotificationSwitchTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;
  final bool isLast;

  const _NotificationSwitchTile({
    required this.icon,
    required this.title,
    required this.subtitle,
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
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: appColors.brandPrimaryGhost,
              shape: BoxShape.circle,
              border: Border.all(
                color: theme.colorScheme.primary.withValues(alpha: 0.2),
              ),
            ),
            child: Icon(icon, size: 24, color: theme.colorScheme.primary),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 13,
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Switch(
            value: value,
            onChanged: onChanged,
            activeTrackColor: theme.colorScheme.primary,
            activeThumbColor: theme.colorScheme.surface,
            inactiveTrackColor: appColors.bgSurface,
            inactiveThumbColor: theme.colorScheme.onSurface.withValues(
              alpha: 0.6,
            ),
          ),
        ],
      ),
    );
  }
}
