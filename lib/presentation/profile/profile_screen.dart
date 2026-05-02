import 'package:bourgo_arena_mobile/data/models/user_profile.dart';
import 'package:bourgo_arena_mobile/data/services/data_service.dart';
import 'package:bourgo_arena_mobile/core/constants.dart';
import 'package:bourgo_arena_mobile/l10n/app_localizations.dart';
import 'package:bourgo_arena_mobile/presentation/profile/profile_view_model.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';

/// The user profile screen.
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late final ProfileViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = ProfileViewModel(dataService: DataService());
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _viewModel,
      builder: (context, _) {
        if (_viewModel.isLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final profile = _viewModel.profile;
        if (profile == null) {
          return Scaffold(
            body: Center(
              child: Text(AppLocalizations.of(context)!.commonLoadingError),
            ),
          );
        }

        return Scaffold(
          body: CustomScrollView(
            slivers: [
              _buildAppBar(context, profile),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      _StatsRow(profile: profile),
                      const SizedBox(height: 32),
                      _ProfileMenu(
                        onTapAbonnement: () => context.push('/subscription'),
                        onTapHistorique: () => context.push('/history'),
                        onTapNotifications: () =>
                            context.push('/notifications'),
                        onTapSettings: () => context.push('/settings'),
                      ),
                      const SizedBox(height: 32),
                      _LogoutButton(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAppBar(BuildContext context, UserProfile profile) {
    final theme = Theme.of(context);

    return SliverAppBar(
      expandedHeight: 280,
      pinned: true,
      backgroundColor: theme.colorScheme.surface,
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          alignment: Alignment.center,
          children: [
            // Background Glow
            Positioned(
              top: -50,
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: theme.colorScheme.primary.withValues(alpha: 0.08),
                ),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 40),
                CircleAvatar(
                  radius: 50,
                  backgroundImage: NetworkImage(profile.avatarUrl),
                  backgroundColor: theme.colorScheme.primary.withValues(
                    alpha: 0.2,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  profile.name.toUpperCase(),
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontFamily: AppConstants.displayFontFamily,
                    letterSpacing: 1,
                  ),
                ),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    profile.subscriptionLevel,
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 10,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _StatsRow extends StatelessWidget {
  final UserProfile profile;

  const _StatsRow({required this.profile});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _StatItem(
            label: AppLocalizations.of(context)!.profilePoints,
            value: profile.loyaltyPoints.toString(),
            icon: Symbols.stars,
          ),
          Container(width: 1, height: 40, color: Colors.white10),
          _StatItem(
            label: AppLocalizations.of(context)!.profileCheckins,
            value: profile.totalCheckIns.toString(),
            icon: Symbols.qr_code_scanner,
          ),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _StatItem({
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        Icon(icon, color: theme.colorScheme.primary, size: 24),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white54,
            fontSize: 10,
            letterSpacing: 1,
          ),
        ),
      ],
    );
  }
}

class _ProfileMenu extends StatelessWidget {
  final VoidCallback onTapAbonnement;
  final VoidCallback onTapHistorique;
  final VoidCallback onTapNotifications;
  final VoidCallback onTapSettings;

  const _ProfileMenu({
    required this.onTapAbonnement,
    required this.onTapHistorique,
    required this.onTapNotifications,
    required this.onTapSettings,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _MenuItem(
          icon: Symbols.card_membership,
          label: AppLocalizations.of(context)!.profileMySubscription,
          onTap: onTapAbonnement,
        ),
        const SizedBox(height: 12),
        _MenuItem(
          icon: Symbols.history,
          label: AppLocalizations.of(context)!.profileHistory,
          onTap: onTapHistorique,
        ),
        const SizedBox(height: 12),
        _MenuItem(
          icon: Symbols.notifications,
          label: AppLocalizations.of(context)!.profileNotifications,
          onTap: onTapNotifications,
        ),
        const SizedBox(height: 12),
        _MenuItem(
          icon: Symbols.settings,
          label: AppLocalizations.of(context)!.profileSettings,
          onTap: onTapSettings,
        ),
      ],
    );
  }
}

class _MenuItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _MenuItem({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListTile(
      onTap: onTap,
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.white10),
        ),
        child: Icon(icon, color: theme.colorScheme.primary, size: 20),
      ),
      title: Text(
        label,
        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
      ),
      trailing: const Icon(Icons.chevron_right, color: Colors.white24),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: Colors.white10),
      ),
    );
  }
}

class _LogoutButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () => context.go('/login'),
      child: Text(
        AppLocalizations.of(context)!.profileLogout,
        style: const TextStyle(
          color: Colors.redAccent,
          fontWeight: FontWeight.bold,
          letterSpacing: 1,
        ),
      ),
    );
  }
}
