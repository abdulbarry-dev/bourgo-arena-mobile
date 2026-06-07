import 'package:bourgo_arena_mobile/domain/entities/user.dart';
import 'package:bourgo_arena_mobile/domain/repositories/auth_repository.dart';
import 'package:bourgo_arena_mobile/domain/usecases/auth/logout_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/auth/delete_account_use_case.dart';
import 'package:bourgo_arena_mobile/core/di/locator.dart';
import 'package:bourgo_arena_mobile/core/constants/app_constants.dart';
import 'package:bourgo_arena_mobile/l10n/app_localizations.dart';
import 'package:bourgo_arena_mobile/presentation/loyalty/widgets/tier_badge.dart';
import 'package:bourgo_arena_mobile/presentation/profile/profile_view_model.dart';
import 'package:bourgo_arena_mobile/presentation/auth/auth_state_notifier.dart';
import 'package:bourgo_arena_mobile/domain/entities/auth_state.dart';
import 'package:bourgo_arena_mobile/presentation/profile/widgets/profile_list_item.dart';
import 'package:bourgo_arena_mobile/presentation/common/widgets/guest_auth_state.dart';
import 'package:bourgo_arena_mobile/core/theme/bourgo_theme.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:material_symbols_icons/symbols.dart';

/// The user profile screen.
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with SingleTickerProviderStateMixin {
  late final ProfileViewModel _viewModel;
  late final AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _viewModel = ProfileViewModel(
      authRepository: locator<AuthRepository>(),
      logoutUseCase: locator<LogoutUseCase>(),
      deleteAccountUseCase: locator<DeleteAccountUseCase>(),
      authStateNotifier: locator<AuthStateNotifier>(),
    );

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final appColors = theme.extension<AppColors>()!;

    return ListenableBuilder(
      listenable: _viewModel,
      builder: (context, _) {
        if (_viewModel.isLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final user = _viewModel.user;
        final authState = locator<AuthStateNotifier>().state;

        if (authState == AuthState.unauthenticated ||
            authState == AuthState.guest) {
          return Scaffold(
            backgroundColor: theme.scaffoldBackgroundColor,
            appBar: AppBar(
              title: Text(l10n.navProfile),
              backgroundColor: appColors.bgSurface,
              elevation: 0,
            ),
            body: const GuestAuthState(icon: Symbols.person),
          );
        }

        if (user == null) {
          return Scaffold(body: Center(child: Text(l10n.commonLoadingError)));
        }

        return Scaffold(
          backgroundColor: theme.scaffoldBackgroundColor,
          body: CustomScrollView(
            slivers: [
              _buildAppBar(context, user),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 24),
                      _StatsRow(user: user, animation: _animationController),
                      const SizedBox(height: 32),
                      Text(
                        l10n.profileSettings.toUpperCase(),
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: theme.colorScheme.onSurface.withValues(
                            alpha: 0.35,
                          ),
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.5,
                        ),
                      ),
                      const SizedBox(height: 16),
                      _ProfileMenu(
                        animation: _animationController,
                        onTapAbonnement: () => context.push('/subscription'),
                        onTapNotifications: () =>
                            context.push('/notifications'),
                        onTapSettings: () => context.push('/settings'),
                      ),
                      const SizedBox(height: 48),
                      _LogoutButton(
                        onLogout: () async {
                          await _viewModel.logout();
                          if (context.mounted) {
                            context.go('/login');
                          }
                        },
                      ),
                      const SizedBox(height: 40),
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
    final appColors = theme.extension<AppColors>()!;
    final l10n = AppLocalizations.of(context)!;

    return SliverAppBar(
      expandedHeight: 280,
      pinned: true,
      backgroundColor: appColors.bgSurface,
      elevation: 0,
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          alignment: Alignment.center,
          children: [
            // Ambient Background Glow
            Positioned(
              top: 20,
              child: Container(
                width: 240,
                height: 240,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      theme.colorScheme.primary.withValues(alpha: 0.15),
                      theme.colorScheme.primary.withValues(alpha: 0.0),
                    ],
                  ),
                ),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 40),
                Hero(
                  tag: 'profile_avatar',
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: theme.colorScheme.primary.withValues(alpha: 0.08),
                      border: Border.all(
                        color: theme.colorScheme.primary.withValues(alpha: 0.3),
                        width: 2,
                      ),
                      image: user.avatarUrl != null
                          ? DecorationImage(
                              image: NetworkImage(user.avatarUrl!),
                              fit: BoxFit.cover,
                            )
                          : null,
                      boxShadow: [
                        BoxShadow(
                          color: theme.colorScheme.primary.withValues(
                            alpha: 0.2,
                          ),
                          blurRadius: 20,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: user.avatarUrl == null
                        ? Icon(
                            Symbols.person,
                            size: 48,
                            color: theme.colorScheme.primary,
                          )
                        : null,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  '${user.firstName} ${user.lastName}'.toUpperCase(),
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontFamily: AppConstants.displayFontFamily,
                    fontWeight: FontWeight.w900,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 8),
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
  final Animation<double> animation;

  const _StatsRow({required this.user, required this.animation});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = theme.extension<AppColors>()!;
    final l10n = AppLocalizations.of(context)!;

    return SlideTransition(
      position: Tween<Offset>(begin: const Offset(0, 0.2), end: Offset.zero)
          .animate(
            CurvedAnimation(
              parent: animation,
              curve: const Interval(0.0, 0.5, curve: Curves.easeOutCubic),
            ),
          ),
      child: FadeTransition(
        opacity: CurvedAnimation(
          parent: animation,
          curve: const Interval(0.0, 0.5, curve: Curves.easeIn),
        ),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
          decoration: BoxDecoration(
            color: appColors.bgElevated,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: appColors.bgBorder, width: 1),
            boxShadow: [
              BoxShadow(
                color: theme.shadowColor.withValues(alpha: 0.2),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatItem(
                context,
                l10n.profilePoints,
                NumberFormat(
                  '#,###',
                ).format(user.loyaltyPoints).replaceAll(',', ' '),
                Symbols.stars,
                theme.colorScheme.primary,
                () => context.push('/loyalty'),
              ),
              Container(width: 1, height: 40, color: appColors.bgBorder),
              _buildStatItem(
                context,
                "RÉSERVATIONS",
                "12", // Placeholder for actual stats
                Symbols.event_available,
                theme.colorScheme.onSurface,
                () => context.push('/bookings'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatItem(
    BuildContext context,
    String label,
    String value,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, color: color, size: 20),
                const SizedBox(width: 8),
                Text(
                  value,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w900,
                    color: color,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              label.toUpperCase(),
              style: theme.textTheme.labelSmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant.withValues(
                  alpha: 0.65,
                ),
                letterSpacing: 1,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileMenu extends StatelessWidget {
  final VoidCallback onTapAbonnement;
  final VoidCallback onTapNotifications;
  final VoidCallback onTapSettings;
  final Animation<double> animation;

  const _ProfileMenu({
    required this.onTapAbonnement,
    required this.onTapNotifications,
    required this.onTapSettings,
    required this.animation,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Column(
      children: [
        _buildAnimatedItem(
          0.1,
          ProfileListItem(
            icon: Symbols.card_membership,
            title: l10n.profileMySubscription,
            subtitle: "Gérer votre forfait et accès",
            onTap: onTapAbonnement,
          ),
        ),
        _buildAnimatedItem(
          0.2,
          ProfileListItem(
            icon: Symbols.notifications,
            title: l10n.profileNotifications,
            subtitle: "Gérer vos alertes et rappels",
            onTap: onTapNotifications,
          ),
        ),
        _buildAnimatedItem(
          0.3,
          ProfileListItem(
            icon: Symbols.settings,
            title: l10n.profileSettings,
            subtitle: "Informations personnelles, mot de passe",
            onTap: onTapSettings,
          ),
        ),
      ],
    );
  }

  Widget _buildAnimatedItem(double delay, Widget child) {
    return SlideTransition(
      position: Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero)
          .animate(
            CurvedAnimation(
              parent: animation,
              curve: Interval(delay, delay + 0.5, curve: Curves.easeOutCubic),
            ),
          ),
      child: FadeTransition(
        opacity: CurvedAnimation(
          parent: animation,
          curve: Interval(delay, delay + 0.5, curve: Curves.easeIn),
        ),
        child: child,
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

    return ProfileListItem(
      icon: Symbols.logout,
      title: l10n.profileLogout,
      isDestructive: true,
      onTap: () => _showLogoutModal(context, l10n),
    );
  }

  void _showLogoutModal(BuildContext context, AppLocalizations l10n) {
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
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.1),
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
                    Symbols.logout,
                    color: theme.colorScheme.error,
                    size: 32,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  l10n.profileLogoutTitle.toUpperCase(),
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w900,
                    color: theme.colorScheme.error,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                Text(
                  l10n.profileLogoutMessage,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                    height: 1.5,
                  ),
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
                          l10n.commonCancel.toUpperCase(),
                          style: TextStyle(
                            color: theme.colorScheme.onSurface,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(dialogContext);
                          onLogout();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(l10n.profileLogoutSuccess),
                              duration: const Duration(seconds: 2),
                              behavior: SnackBarBehavior.floating,
                              margin: const EdgeInsets.all(16),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: theme.colorScheme.error,
                          foregroundColor: theme.colorScheme.onError,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          l10n.profileLogoutConfirm.toUpperCase(),
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
