import 'package:bourgo_arena_mobile/domain/entities/user.dart';
import 'package:bourgo_arena_mobile/domain/repositories/auth_repository.dart';
import 'package:bourgo_arena_mobile/domain/usecases/auth/logout_use_case.dart';
import 'package:bourgo_arena_mobile/core/di/locator.dart';
import 'package:bourgo_arena_mobile/core/constants/app_constants.dart';
import 'package:bourgo_arena_mobile/l10n/app_localizations.dart';
import 'package:bourgo_arena_mobile/presentation/loyalty/loyalty_dashboard_screen.dart';
import 'package:bourgo_arena_mobile/presentation/loyalty/widgets/tier_badge.dart';
import 'package:bourgo_arena_mobile/presentation/profile/profile_view_model.dart';
import 'package:bourgo_arena_mobile/presentation/auth/auth_state_notifier.dart';
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
    _viewModel = ProfileViewModel(
      authRepository: locator<AuthRepository>(),
      logoutUseCase: locator<LogoutUseCase>(),
      authStateNotifier: locator<AuthStateNotifier>(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return ListenableBuilder(
      listenable: _viewModel,
      builder: (context, _) {
        if (_viewModel.isLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final user = _viewModel.user;
        if (user == null) {
          return Scaffold(body: Center(child: Text(l10n!.commonLoadingError)));
        }

        return Scaffold(
          body: CustomScrollView(
            slivers: [
              _buildAppBar(context, user),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      _StatsRow(user: user),
                      const SizedBox(height: 32),
                      _ProfileMenu(
                        onTapAbonnement: () => context.push('/subscription'),
                        onTapHistorique: () => context.push('/history'),
                        onTapNotifications: () =>
                            context.push('/notifications'),
                        onTapSettings: () => context.push('/settings'),
                      ),
                      const SizedBox(height: 32),
                      _LogoutButton(
                        onLogout: () async {
                          await _viewModel.logout();
                          if (context.mounted) {
                            context.go('/login');
                          }
                        },
                      ),
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

  Widget _buildAppBar(BuildContext context, User user) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

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
                  backgroundImage: user.avatarUrl != null
                      ? NetworkImage(user.avatarUrl!)
                      : null,
                  backgroundColor: theme.colorScheme.primary.withValues(
                    alpha: 0.2,
                  ),
                  child: user.avatarUrl == null
                      ? Icon(
                          Symbols.person,
                          size: 50,
                          color: theme.colorScheme.primary,
                        )
                      : null,
                ),
                const SizedBox(height: 16),
                Text(
                  '${user.firstName} ${user.lastName}'.toUpperCase(),
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontFamily: AppConstants.displayFontFamily,
                    letterSpacing: 1,
                  ),
                ),
                const SizedBox(height: 4),
                TierBadge(
                  tierName: user.subscriptionLevel ?? l10n.profileStandardTier,
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
  final User user;

  const _StatsRow({required this.user});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.5),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const LoyaltyDashboardScreen(),
                ),
              );
            },
            child: _StatItem(
              label: AppLocalizations.of(context)!.profilePoints,
              value: user.loyaltyPoints.toString(),
              icon: Symbols.stars,
            ),
          ),

          Container(width: 1, height: 40, color: theme.colorScheme.outline),
          _StatItem(
            label: AppLocalizations.of(context)!.profileCheckins,
            value: user.totalCheckIns.toString(),
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
          style: TextStyle(
            color: theme.colorScheme.onSurfaceVariant,
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
          border: Border.all(
            color: theme.colorScheme.outline.withValues(alpha: 0.5),
          ),
        ),
        child: Icon(icon, color: theme.colorScheme.primary, size: 20),
      ),
      title: Text(
        label,
        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
      ),
      trailing: Icon(
        Icons.chevron_right,
        color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.3),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: theme.colorScheme.outline.withValues(alpha: 0.5),
        ),
      ),
    );
  }
}

class _LogoutButton extends StatelessWidget {
  final VoidCallback onLogout;

  const _LogoutButton({required this.onLogout});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return TextButton(
      onPressed: () {
        showDialog(
          context: context,
          builder: (BuildContext dialogContext) {
            return AlertDialog(
              title: Text(l10n.profileLogoutTitle),
              content: Text(l10n.profileLogoutMessage),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(dialogContext).pop(),
                  child: Text(
                    l10n.commonCancel,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(dialogContext).pop();
                    onLogout();
                    // Show toast message
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(l10n.profileLogoutSuccess),
                        duration: const Duration(seconds: 2),
                        behavior: SnackBarBehavior.floating,
                        margin: const EdgeInsets.all(16),
                      ),
                    );
                  },
                  child: Text(
                    l10n.profileLogoutConfirm,
                    style: const TextStyle(color: Colors.redAccent),
                  ),
                ),
              ],
            );
          },
        );
      },
      child: Text(
        l10n.profileLogout,
        style: const TextStyle(
          color: Colors.redAccent,
          fontWeight: FontWeight.bold,
          letterSpacing: 1,
        ),
      ),
    );
  }
}
