import 'package:bourgo_arena_mobile/data/services/activity_service.dart';
import 'package:bourgo_arena_mobile/presentation/auth/auth_state_notifier.dart';
import 'package:bourgo_arena_mobile/domain/entities/activity.dart';
import 'package:bourgo_arena_mobile/presentation/auth/forgot_password/forgot_password_screen.dart';
import 'package:bourgo_arena_mobile/presentation/auth/login/login_screen.dart';
import 'package:bourgo_arena_mobile/presentation/auth/new_password/new_password_screen.dart';
import 'package:bourgo_arena_mobile/presentation/auth/otp/otp_screen.dart';
import 'package:bourgo_arena_mobile/presentation/auth/register/account_setup_screen.dart';
import 'package:bourgo_arena_mobile/presentation/auth/register/family_onboarding_screen.dart';
import 'package:bourgo_arena_mobile/presentation/auth/register/pin_setup_screen.dart';
import 'package:bourgo_arena_mobile/presentation/auth/register/register_screen.dart';
import 'package:bourgo_arena_mobile/presentation/auth/register/verification_method_screen.dart';
import 'package:bourgo_arena_mobile/presentation/booking/booking_flow_screen.dart';
import 'package:bourgo_arena_mobile/presentation/booking/booking_success_screen.dart';
import 'package:bourgo_arena_mobile/presentation/common/not_found_screen.dart';
import 'package:bourgo_arena_mobile/presentation/common/offline_screen.dart';
import 'package:bourgo_arena_mobile/presentation/main_layout.dart';
import 'package:bourgo_arena_mobile/presentation/notifications/notifications_screen.dart';
import 'package:bourgo_arena_mobile/presentation/onboarding/onboarding_screen.dart';
import 'package:bourgo_arena_mobile/presentation/profile/change_password_screen.dart';
import 'package:bourgo_arena_mobile/presentation/profile/edit_profile_screen.dart';
import 'package:bourgo_arena_mobile/presentation/profile/history_screen.dart';
import 'package:bourgo_arena_mobile/presentation/profile/subscription_screen.dart';
import 'package:bourgo_arena_mobile/presentation/profile/family_management_screen.dart';
import 'package:bourgo_arena_mobile/presentation/search/search_screen.dart';
import 'package:bourgo_arena_mobile/presentation/settings/privacy_policy_screen.dart';
import 'package:bourgo_arena_mobile/presentation/settings/settings_screen.dart';
import 'package:bourgo_arena_mobile/presentation/settings/terms_of_service_screen.dart';
import 'package:bourgo_arena_mobile/presentation/settings/viewmodels/settings_view_model.dart';
import 'package:bourgo_arena_mobile/presentation/onboarding/language_selection_screen.dart';
import 'package:bourgo_arena_mobile/presentation/planning/planning_screen.dart';
import 'package:bourgo_arena_mobile/core/di/locator.dart';
import 'package:bourgo_arena_mobile/domain/usecases/auth/login_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/auth/register_use_case.dart';

import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';

/// App routing configuration using GoRouter.
GoRouter createRouter(
  SettingsViewModel settingsViewModel,
  AuthStateNotifier authStateNotifier,
  ActivityService activityService,
) => GoRouter(
  initialLocation: '/',
  errorBuilder: (context, state) => NotFoundScreen(error: state.error),
  refreshListenable: Listenable.merge([authStateNotifier, settingsViewModel]),
  redirect: (context, state) {
    // 1. Force Language Selection if not set
    if (!settingsViewModel.isLanguageSelected) {
      return state.matchedLocation == '/language-selection'
          ? null
          : '/language-selection';
    }

    // 2. Prevent accessing language selection once set
    if (state.matchedLocation == '/language-selection') {
      return '/';
    }

    // 3. Auth Redirection
    final bool isAuthenticated = authStateNotifier.isAuthenticated;
    final bool isAuthRoute =
        state.matchedLocation == '/login' ||
        state.matchedLocation == '/register' ||
        state.matchedLocation == '/otp' ||
        state.matchedLocation == '/verification-method' ||
        state.matchedLocation == '/family-onboarding' ||
        state.matchedLocation == '/account-setup' ||
        state.matchedLocation == '/pin-setup' ||
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
    GoRoute(
      path: '/language-selection',
      builder: (context, state) =>
          LanguageSelectionScreen(viewModel: settingsViewModel),
    ),
    GoRoute(path: '/', builder: (context, state) => const OnboardingScreen()),
    GoRoute(
      path: '/login',
      builder: (context, state) => LoginScreen(
        loginUseCase: locator<LoginUseCase>(),
      ),
    ),
    GoRoute(
      path: '/register',
      builder: (context, state) => RegisterScreen(
        registerUseCase: locator<RegisterUseCase>(),
      ),
    ),
    GoRoute(
      path: '/otp',
      builder: (context, state) {
        final data = state.extra as Map<String, dynamic>?;
        return OtpScreen(
          destination: data?['destination'] as String?,
          registrationData: data?['registrationData'] as Map<String, dynamic>?,
        );
      },
    ),
    GoRoute(
      path: '/verification-method',
      builder: (context, state) {
        final registrationData = state.extra as Map<String, dynamic>;
        return VerificationMethodScreen(registrationData: registrationData);
      },
    ),
    GoRoute(
      path: '/family-onboarding',
      builder: (context, state) {
        final registrationData = state.extra as Map<String, dynamic>;
        return FamilyOnboardingScreen(registrationData: registrationData);
      },
    ),
    GoRoute(
      path: '/account-setup',
      builder: (context, state) {
        final registrationData = state.extra as Map<String, dynamic>;
        return AccountSetupScreen(registrationData: registrationData);
      },
    ),
    GoRoute(
      path: '/pin-setup',
      builder: (context, state) {
        final registrationData = state.extra as Map<String, dynamic>;
        return PinSetupScreen(registrationData: registrationData);
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
      path: '/planning',
      builder: (context, state) => const PlanningScreen(),
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
    GoRoute(
      path: '/family-management',
      builder: (context, state) => const FamilyManagementScreen(),
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
