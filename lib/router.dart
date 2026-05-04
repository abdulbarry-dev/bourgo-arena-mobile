import 'package:bourgo_arena_mobile/data/services/activity_service.dart';
import 'package:bourgo_arena_mobile/data/services/auth_service.dart';
import 'package:bourgo_arena_mobile/domain/entities/activity.dart';
import 'package:bourgo_arena_mobile/presentation/auth/forgot_password/forgot_password_screen.dart';
import 'package:bourgo_arena_mobile/presentation/auth/login/login_screen.dart';
import 'package:bourgo_arena_mobile/presentation/auth/new_password/new_password_screen.dart';
import 'package:bourgo_arena_mobile/presentation/auth/otp/otp_screen.dart';
import 'package:bourgo_arena_mobile/presentation/auth/register/register_screen.dart';
import 'package:bourgo_arena_mobile/presentation/booking/booking_flow_screen.dart';
import 'package:bourgo_arena_mobile/presentation/booking/booking_success_screen.dart';
import 'package:bourgo_arena_mobile/presentation/common/offline_screen.dart';
import 'package:bourgo_arena_mobile/presentation/main_layout.dart';
import 'package:bourgo_arena_mobile/presentation/notifications/notifications_screen.dart';
import 'package:bourgo_arena_mobile/presentation/onboarding/onboarding_screen.dart';
import 'package:bourgo_arena_mobile/presentation/profile/change_password_screen.dart';
import 'package:bourgo_arena_mobile/presentation/profile/edit_profile_screen.dart';
import 'package:bourgo_arena_mobile/presentation/profile/history_screen.dart';
import 'package:bourgo_arena_mobile/presentation/profile/subscription_screen.dart';
import 'package:bourgo_arena_mobile/presentation/search/search_screen.dart';
import 'package:bourgo_arena_mobile/presentation/settings/privacy_policy_screen.dart';
import 'package:bourgo_arena_mobile/presentation/settings/settings_screen.dart';
import 'package:bourgo_arena_mobile/presentation/settings/terms_of_service_screen.dart';
import 'package:bourgo_arena_mobile/presentation/settings/viewmodels/settings_view_model.dart';
import 'package:go_router/go_router.dart';

/// App routing configuration using GoRouter.
GoRouter createRouter(
  SettingsViewModel settingsViewModel,
  AuthService authService,
  ActivityService activityService,
) => GoRouter(
  initialLocation: '/',
  refreshListenable: authService,
  redirect: (context, state) {
    final bool isAuthenticated = authService.isAuthenticated;
    final bool isAuthRoute =
        state.matchedLocation == '/login' ||
        state.matchedLocation == '/register' ||
        state.matchedLocation == '/otp' ||
        state.matchedLocation == '/forgot-password' ||
        state.matchedLocation == '/new-password' ||
        state.matchedLocation == '/';

    if (!isAuthenticated) {
      return isAuthRoute ? null : '/login';
    }

    if (isAuthRoute) {
      return '/home';
    }

    return null;
  },
  routes: [
    GoRoute(path: '/', builder: (context, state) => const OnboardingScreen()),
    GoRoute(
      path: '/login',
      builder: (context, state) => LoginScreen(authService: authService),
    ),
    GoRoute(
      path: '/register',
      builder: (context, state) => const RegisterScreen(),
    ),
    GoRoute(
      path: '/otp',
      builder: (context, state) {
        final destination = state.extra as String?;
        return OtpScreen(destination: destination);
      },
    ),
    GoRoute(
      path: '/forgot-password',
      builder: (context, state) => const ForgotPasswordScreen(),
    ),
    GoRoute(
      path: '/new-password',
      builder: (context, state) => const NewPasswordScreen(),
    ),
    GoRoute(path: '/home', builder: (context, state) => const MainLayout()),
    GoRoute(
      path: '/booking',
      builder: (context, state) {
        final activity = state.extra as Activity?;
        return BookingFlowScreen(
          initialActivity: activity,
          activityService: activityService,
        );
      },
    ),
    GoRoute(
      path: '/booking-success',
      builder: (context, state) {
        final activity = state.extra as Activity?;
        return BookingSuccessScreen(activity: activity);
      },
    ),
    GoRoute(
      path: '/subscription',
      builder: (context, state) => const SubscriptionScreen(),
    ),
    GoRoute(
      path: '/history',
      builder: (context, state) => const HistoryScreen(),
    ),
    GoRoute(
      path: '/notifications',
      builder: (context, state) => const NotificationsScreen(),
    ),
    GoRoute(
      path: '/settings',
      builder: (context, state) => SettingsScreen(viewModel: settingsViewModel),
    ),
    GoRoute(
      path: '/edit-profile',
      builder: (context, state) => const EditProfileScreen(),
    ),
    GoRoute(
      path: '/change-password',
      builder: (context, state) => const ChangePasswordScreen(),
    ),
    GoRoute(path: '/search', builder: (context, state) => const SearchScreen()),
    GoRoute(
      path: '/terms',
      builder: (context, state) => const TermsOfServiceScreen(),
    ),
    GoRoute(
      path: '/privacy',
      builder: (context, state) => const PrivacyPolicyScreen(),
    ),
    GoRoute(
      path: '/offline',
      builder: (context, state) => const OfflineScreen(),
    ),
  ],
);
