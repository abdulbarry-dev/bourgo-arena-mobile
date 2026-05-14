import 'package:bourgo_arena_mobile/domain/entities/auth_state.dart';
import 'package:bourgo_arena_mobile/core/di/locator.dart';
import 'package:bourgo_arena_mobile/domain/repositories/session_repository.dart';
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
import 'package:bourgo_arena_mobile/domain/usecases/auth/login_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/auth/register_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/auth/reset_password_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/auth/send_otp_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/auth/verify_otp_use_case.dart';

import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';

/// App routing configuration using GoRouter.
/// Extension to safely extract extra data from [GoRouterState].
extension GoRouterStateExtraX on GoRouterState {
  /// Safely gets a [Map<String, dynamic>] from extra.
  Map<String, dynamic> get extraAsMap {
    final data = extra;
    if (data is Map<String, dynamic>) {
      return data;
    }
    if (data is String) {
      return {'destination': data};
    }
    return <String, dynamic>{};
  }

  /// Safely gets an [Activity] from extra.
  Activity? get extraAsActivity {
    final data = extra;
    return data is Activity ? data : null;
  }
}

GoRouter createRouter(
  SettingsViewModel settingsViewModel,
  AuthStateNotifier authStateNotifier,
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
    final authState = authStateNotifier.state;
    final bool isAuthRoute =
        state.matchedLocation == '/login' ||
        state.matchedLocation == '/register' ||
        state.matchedLocation == '/forgot-password' ||
        state.matchedLocation == '/new-password' ||
        state.matchedLocation == '/otp' ||
        state.matchedLocation == '/';

    switch (authState) {
      case AuthState.unauthenticated:
        return isAuthRoute ? null : '/login';

      case AuthState.pendingVerification:
        // Allow OTP verification and related registration steps
        final bool isVerificationRoute =
            state.matchedLocation == '/otp' ||
            state.matchedLocation == '/verification-method' ||
            state.matchedLocation == '/family-onboarding';

        if (isVerificationRoute) return null;

        // Otherwise, force restore OTP screen
        return '/otp';

      case AuthState.pendingOnboarding:
        // Allow onboarding flow steps
        final bool isOnboardingRoute =
            state.matchedLocation == '/onboarding' ||
            state.matchedLocation == '/account-setup' ||
            state.matchedLocation == '/pin-setup';

        if (isOnboardingRoute) return null;

        return '/onboarding';

      case AuthState.authenticated:
        // Prevent accessing auth routes once fully authenticated
        if (isAuthRoute ||
            state.matchedLocation == '/otp' ||
            state.matchedLocation == '/onboarding') {
          return '/home';
        }
        return null;
    }
  },
  routes: [
    GoRoute(
      path: '/language-selection',
      builder: (context, state) =>
          LanguageSelectionScreen(viewModel: settingsViewModel),
    ),
    GoRoute(path: '/', builder: (context, state) => const OnboardingScreen()),
    GoRoute(
      path: '/onboarding',
      builder: (context, state) => const OnboardingScreen(),
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) => LoginScreen(
        loginUseCase: locator<LoginUseCase>(),
        sessionRepository: locator<SessionRepository>(),
      ),
    ),
    GoRoute(
      path: '/register',
      builder: (context, state) =>
          RegisterScreen(registerUseCase: locator<RegisterUseCase>()),
    ),
    GoRoute(
      path: '/otp',
      builder: (context, state) {
        final data = state.extraAsMap;
        final destination =
            data['destination'] as String? ??
            authStateNotifier.session.pendingEmail;
        return OtpScreen(
          destination: destination,
          registrationData: data['registrationData'] as Map<String, dynamic>?,
          isPasswordReset: data['isPasswordReset'] as bool? ?? false,
          sendOtpUseCase: locator<SendOtpUseCase>(),
          verifyOtpUseCase: locator<VerifyOtpUseCase>(),
        );
      },
    ),
    GoRoute(
      path: '/verification-method',
      builder: (context, state) => VerificationMethodScreen(
        registrationData: state.extraAsMap,
        sendOtpUseCase: locator<SendOtpUseCase>(),
      ),
    ),
    GoRoute(
      path: '/family-onboarding',
      builder: (context, state) =>
          FamilyOnboardingScreen(registrationData: state.extraAsMap),
    ),
    GoRoute(
      path: '/account-setup',
      builder: (context, state) =>
          AccountSetupScreen(registrationData: state.extraAsMap),
    ),
    GoRoute(
      path: '/pin-setup',
      builder: (context, state) =>
          PinSetupScreen(registrationData: state.extraAsMap),
    ),
    GoRoute(
      path: '/forgot-password',
      builder: (context, state) => const ForgotPasswordScreen(),
    ),
    GoRoute(
      path: '/new-password',
      builder: (context, state) {
        final data = state.extraAsMap;
        return NewPasswordScreen(
          identifier: data['identifier'] as String? ?? '',
          otp: data['otp'] as String? ?? '',
          resetPasswordUseCase: locator<ResetPasswordUseCase>(),
        );
      },
    ),
    GoRoute(path: '/home', builder: (context, state) => const MainLayout()),
    GoRoute(
      path: '/booking',
      builder: (context, state) =>
          BookingFlowScreen(initialActivity: state.extraAsActivity),
    ),
    GoRoute(
      path: '/booking-success',
      builder: (context, state) =>
          BookingSuccessScreen(activity: state.extraAsActivity),
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
