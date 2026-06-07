import 'package:bourgo_arena_mobile/domain/entities/user.dart';
import 'package:bourgo_arena_mobile/domain/repositories/auth_repository.dart';
import 'package:bourgo_arena_mobile/domain/usecases/auth/logout_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/auth/delete_account_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/booking/get_ongoing_reservations_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/payment/get_full_payment_history_use_case.dart';
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
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';

/// The user profile screen enhanced with premium design standards.
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
      getOngoingReservationsUseCase: locator<GetOngoingReservationsUseCase>(),
      getFullPaymentHistoryUseCase: locator<GetFullPaymentHistoryUseCase>(),
    );

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
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
    final spacing = context.spacing;

    return ListenableBuilder(
      listenable: _viewModel,
      builder: (context, _) {
        if (_viewModel.isLoading) {
          return Scaffold(
            backgroundColor: theme.scaffoldBackgroundColor,
            body: const Center(
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          );
        }

        final user = _viewModel.user;
        final authState = locator<AuthStateNotifier>().state;

        if (authState == AuthState.unauthenticated ||
            authState == AuthState.guest) {
          return Scaffold(
            backgroundColor: theme.scaffoldBackgroundColor,
            appBar: AppBar(
              title: Text(
                l10n.navProfile.toUpperCase(),
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w900,
                  letterSpacing: 2,
                ),
              ),
              backgroundColor: Colors.transparent,
              elevation: 0,
              centerTitle: true,
            ),
            body: const GuestAuthState(icon: Symbols.person),
          );
        }

        if (user == null) {
          return Scaffold(
            backgroundColor: theme.scaffoldBackgroundColor,
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Symbols.error,
                    size: 48,
                    color: theme.colorScheme.error.withValues(alpha: 0.5),
                  ),
                  const SizedBox(height: 16),
                  Text(l10n.commonLoadingError),
                ],
              ),
            ),
          );
        }

        return Scaffold(
          backgroundColor: theme.scaffoldBackgroundColor,
          body: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              _buildAppBar(context, user),
              SliverToBoxAdapter(
                child: Padding(
                  padding: spacing.horizontalPadding(context),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SizedBox(height: spacing.lg),
                      _StatsDashboard(
                        user: user,
                        ongoingReservationsCount: _viewModel.ongoingReservationsCount,
                        successfulPaymentsCount: _viewModel.successfulPaymentsCount,
                        animation: _animationController,
                      ),
                      SizedBox(height: spacing.xl),
                      _buildSectionHeader(context, l10n.profileSettings),
                      SizedBox(height: spacing.md),
                      _ProfileMenu(
                        animation: _animationController,
                        onTapAbonnement: () => context.push('/subscription'),
                        onTapNotifications: () =>
                            context.push('/notifications'),
                        onTapSettings: () => context.push('/settings'),
                      ),
                      SizedBox(height: spacing.xxl),
                      _LogoutButton(
                        onLogout: () async {
                          await _viewModel.logout();
                          if (context.mounted) {
                            context.go('/login');
                          }
                        },
                      ),
                      SizedBox(height: spacing.xxxl),
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

  Widget _buildSectionHeader(BuildContext context, String title) {
    final theme = Theme.of(context);
    final spacing = context.spacing;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: spacing.xs),
      child: Text(
        title.toUpperCase(),
        style: theme.textTheme.labelSmall?.copyWith(
          color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
          fontWeight: FontWeight.w900,
          letterSpacing: 2,
          fontFamily: GoogleFonts.lexend().fontFamily,
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context, User user) {
    final theme = Theme.of(context);
    final appColors = theme.extension<AppColors>()!;
    final l10n = AppLocalizations.of(context)!;
    final spacing = context.spacing;

    return SliverAppBar(
      expandedHeight: 320,
      pinned: true,
      stretch: true,
      backgroundColor: theme.scaffoldBackgroundColor,
      elevation: 0,
      flexibleSpace: FlexibleSpaceBar(
        stretchModes: const [
          StretchMode.zoomBackground,
          StretchMode.blurBackground,
        ],
        background: Stack(
          alignment: Alignment.center,
          children: [
            // Kinetic Background Gradient
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    theme.colorScheme.primary.withValues(alpha: 0.1),
                    theme.scaffoldBackgroundColor,
                  ],
                ),
              ),
            ),
            // Asymmetric Decorative Ring
            Positioned(
              top: -40,
              right: -40,
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: theme.colorScheme.primary.withValues(alpha: 0.05),
                    width: 40,
                  ),
                ),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 60),
                Hero(
                  tag: 'profile_avatar',
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: theme.colorScheme.primary.withValues(alpha: 0.2),
                        width: 1,
                      ),
                    ),
                    child: ClipOval(
                      child: SizedBox(
                        width: 110,
                        height: 110,
                        child: user.avatarUrl != null
                            ? Image.network(
                                user.avatarUrl!,
                                fit: BoxFit.cover,
                                loadingBuilder:
                                    (context, child, loadingProgress) {
                                  if (loadingProgress == null) return child;
                                  return Shimmer.fromColors(
                                    baseColor:
                                        theme.colorScheme.surfaceContainerHighest,
                                    highlightColor: theme.colorScheme
                                        .surfaceContainerHighest
                                        .withValues(alpha: 0.4),
                                    child: Container(
                                      color: theme.colorScheme
                                          .surfaceContainerHighest,
                                    ),
                                  );
                                },
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    decoration: BoxDecoration(
                                      color: appColors.bgElevated,
                                      boxShadow: [
                                        BoxShadow(
                                          color: theme.colorScheme.primary
                                              .withValues(alpha: 0.15),
                                          blurRadius: 30,
                                          spreadRadius: 5,
                                        ),
                                      ],
                                    ),
                                    child: Icon(
                                      Symbols.person_filled,
                                      size: 48,
                                      color: theme.colorScheme.primary
                                          .withValues(alpha: 0.5),
                                    ),
                                  );
                                },
                              )
                            : Container(
                                decoration: BoxDecoration(
                                  color: appColors.bgElevated,
                                  boxShadow: [
                                    BoxShadow(
                                      color: theme.colorScheme.primary
                                          .withValues(alpha: 0.15),
                                      blurRadius: 30,
                                      spreadRadius: 5,
                                    ),
                                  ],
                                ),
                                child: Icon(
                                  Symbols.person_filled,
                                  size: 48,
                                  color: theme.colorScheme.primary
                                      .withValues(alpha: 0.5),
                                ),
                              ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: spacing.lg),
                Text(
                  user.name.toUpperCase(),
                  textAlign: TextAlign.center,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontFamily: AppConstants.displayFontFamily,
                    fontWeight: FontWeight.w900,
                    letterSpacing: -1.0,
                    fontSize: 28,
                    height: 1.1,
                  ),
                ),
                const SizedBox(height: 12),
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

class _StatsDashboard extends StatelessWidget {
  final User user;
  final int ongoingReservationsCount;
  final int successfulPaymentsCount;
  final Animation<double> animation;

  const _StatsDashboard({
    required this.user,
    required this.ongoingReservationsCount,
    required this.successfulPaymentsCount,
    required this.animation,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = theme.extension<AppColors>()!;

    return SlideTransition(
      position: Tween<Offset>(begin: const Offset(0, 0.1), end: Offset.zero)
          .animate(
            CurvedAnimation(
              parent: animation,
              curve: const Interval(0.2, 0.7, curve: Curves.easeOutCubic),
            ),
          ),
      child: FadeTransition(
        opacity: CurvedAnimation(
          parent: animation,
          curve: const Interval(0.2, 0.7, curve: Curves.easeIn),
        ),
        child: Container(
          decoration: BoxDecoration(
            color: appColors.bgElevated,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: appColors.bgBorder.withValues(alpha: 0.5),
            ),
          ),
          clipBehavior: Clip.antiAlias,
          child: IntrinsicHeight(
            child: Row(
              children: [
                Expanded(
                  child: _StatTile(
                    value: NumberFormat(
                      '#,###',
                    ).format(user.loyaltyPoints).replaceAll(',', ' '),
                    icon: Symbols.stars,
                    color: theme.colorScheme.primary,
                    onTap: () => context.push('/loyalty'),
                  ),
                ),
                _buildDivider(appColors),
                Expanded(
                  child: _ReservationStatTile(
                    count: ongoingReservationsCount,
                    onTap: () => context.push('/bookings'),
                  ),
                ),
                _buildDivider(appColors),
                Expanded(
                  child: _HistoryStatTile(
                    count: successfulPaymentsCount,
                    onTap: () => context.push('/transactions'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDivider(AppColors appColors) {
    return VerticalDivider(
      width: 1,
      thickness: 1,
      color: appColors.bgBorder.withValues(alpha: 0.5),
      indent: 20,
      endIndent: 20,
    );
  }
}

class _StatTile extends StatelessWidget {
  final String value;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _StatTile({
    required this.value,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = context.spacing;

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(
          vertical: spacing.lg,
          horizontal: spacing.md,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color.withValues(alpha: 0.8), size: 24),
            SizedBox(height: spacing.sm),
            Text(
              value,
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w900,
                color: color,
                fontFamily: GoogleFonts.lexend().fontFamily,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ReservationStatTile extends StatelessWidget {
  final int count;
  final VoidCallback onTap;

  const _ReservationStatTile({
    required this.count,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = context.spacing;
    final color = theme.colorScheme.primary;

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(
          vertical: spacing.lg,
          horizontal: spacing.md,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Symbols.event_available, color: color, size: 24),
            SizedBox(height: spacing.sm),
            Text(
              '$count',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w900,
                color: color,
                fontFamily: GoogleFonts.lexend().fontFamily,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HistoryStatTile extends StatelessWidget {
  final int count;
  final VoidCallback onTap;

  const _HistoryStatTile({
    required this.count,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = context.spacing;
    final color = theme.colorScheme.primary;

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(
          vertical: spacing.lg,
          horizontal: spacing.md,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Symbols.history, color: color, size: 24),
            SizedBox(height: spacing.sm),
            Text(
              '$count',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w900,
                color: color,
                fontFamily: GoogleFonts.lexend().fontFamily,
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
          0.3,
          ProfileListItem(
            icon: Symbols.card_membership,
            title: l10n.profileMySubscription,
            subtitle: "Gérer votre forfait et accès premium",
            onTap: onTapAbonnement,
          ),
        ),
        _buildAnimatedItem(
          0.4,
          ProfileListItem(
            icon: Symbols.notifications,
            title: l10n.profileNotifications,
            subtitle: "Gérer vos alertes et rappels de cours",
            onTap: onTapNotifications,
          ),
        ),
        _buildAnimatedItem(
          0.5,
          ProfileListItem(
            icon: Symbols.settings,
            title: l10n.profileSettings,
            subtitle: "Informations personnelles et sécurité",
            onTap: onTapSettings,
          ),
        ),
      ],
    );
  }

  Widget _buildAnimatedItem(double delay, Widget child) {
    return SlideTransition(
      position: Tween<Offset>(begin: const Offset(0.1, 0), end: Offset.zero)
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
        final spacing = context.spacing;

        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(dialogContext).viewInsets.bottom,
          ),
          child: Container(
            padding: EdgeInsets.all(spacing.lg),
            decoration: BoxDecoration(
              color: appColors.bgElevated,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(32),
              ),
              border: Border.all(
                color: theme.colorScheme.error.withValues(alpha: 0.1),
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
                Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.error.withValues(alpha: 0.08),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Symbols.logout,
                    color: theme.colorScheme.error,
                    size: 32,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  l10n.profileLogoutTitle.toUpperCase(),
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w900,
                    color: theme.colorScheme.onSurface,
                    fontFamily: AppConstants.displayFontFamily,
                    letterSpacing: -0.5,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                Text(
                  l10n.profileLogoutMessage,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant.withValues(
                      alpha: 0.7,
                    ),
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
                          padding: const EdgeInsets.symmetric(vertical: 18),
                          side: BorderSide(
                            color: theme.colorScheme.onSurface.withValues(
                              alpha: 0.1,
                            ),
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: Text(
                          l10n.commonCancel.toUpperCase(),
                          style: TextStyle(
                            color: theme.colorScheme.onSurface,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 1,
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
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: theme.colorScheme.error,
                          foregroundColor: theme.colorScheme.onError,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(vertical: 18),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: Text(
                          l10n.profileLogoutConfirm.toUpperCase(),
                          style: const TextStyle(
                            fontWeight: FontWeight.w900,
                            letterSpacing: 1,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        );
      },
    );
  }
}
