import 'package:bourgo_arena_mobile/domain/entities/auth_state.dart';
import 'package:bourgo_arena_mobile/domain/entities/child_profile.dart';
import 'package:bourgo_arena_mobile/core/di/locator.dart';
import 'package:bourgo_arena_mobile/domain/repositories/session_repository.dart';
import 'package:bourgo_arena_mobile/domain/usecases/auth/request_family_account_otp_use_case.dart';
import 'package:bourgo_arena_mobile/presentation/auth/auth_state_notifier.dart';
import 'package:bourgo_arena_mobile/domain/entities/activity.dart';
import 'package:bourgo_arena_mobile/presentation/auth/forgot_password/forgot_password_screen.dart';
import 'package:bourgo_arena_mobile/presentation/auth/login/login_screen.dart';
import 'package:bourgo_arena_mobile/presentation/auth/new_password/new_password_screen.dart';
import 'package:bourgo_arena_mobile/presentation/auth/otp/otp_screen.dart';
import 'package:bourgo_arena_mobile/presentation/auth/register/register_screen.dart';
import 'package:bourgo_arena_mobile/presentation/auth/register/verification_method_screen.dart';
import 'package:bourgo_arena_mobile/presentation/auth/register/family_onboarding_screen.dart';
import 'package:bourgo_arena_mobile/presentation/auth/register/account_setup_screen.dart';
import 'package:bourgo_arena_mobile/presentation/auth/widgets/verify_additional_method_screen.dart';
import 'package:bourgo_arena_mobile/presentation/booking/booking_flow_screen.dart';
import 'package:bourgo_arena_mobile/presentation/booking/booking_success_screen.dart';
import 'package:bourgo_arena_mobile/presentation/common/not_found_screen.dart';
import 'package:bourgo_arena_mobile/presentation/common/offline_screen.dart';
import 'package:bourgo_arena_mobile/presentation/main_layout.dart';
import 'package:bourgo_arena_mobile/presentation/notifications/notifications_screen.dart';
import 'package:bourgo_arena_mobile/presentation/onboarding/onboarding_screen.dart';
import 'package:bourgo_arena_mobile/presentation/profile/change_password_screen.dart';
import 'package:bourgo_arena_mobile/presentation/profile/edit_profile_screen.dart';
import 'package:bourgo_arena_mobile/presentation/profile/subscription_screen.dart';
import 'package:bourgo_arena_mobile/presentation/profile/family_management_screen.dart';
import 'package:bourgo_arena_mobile/presentation/profile/manage_children_screen.dart';
import 'package:bourgo_arena_mobile/presentation/profile/add_edit_child_screen.dart';
import 'package:bourgo_arena_mobile/presentation/family_child/screens/child_profile_screen.dart';
import 'package:bourgo_arena_mobile/presentation/family_child/screens/child_schedule_screen.dart';
import 'package:bourgo_arena_mobile/presentation/family_child/screens/child_subscriptions_screen.dart';
import 'package:bourgo_arena_mobile/presentation/family_child/screens/child_bookings_screen.dart';
import 'package:bourgo_arena_mobile/presentation/family_child/screens/child_sessions_screen.dart';
import 'package:bourgo_arena_mobile/presentation/family_child/screens/child_reservations_screen.dart';
import 'package:bourgo_arena_mobile/presentation/family_child/screens/child_completed_screen.dart';
import 'package:bourgo_arena_mobile/presentation/loyalty/loyalty_dashboard_screen.dart';
import 'package:bourgo_arena_mobile/presentation/loyalty/loyalty_dashboard_view_model.dart';
import 'package:bourgo_arena_mobile/presentation/search/search_screen.dart';
import 'package:bourgo_arena_mobile/presentation/settings/privacy_policy_screen.dart';
import 'package:bourgo_arena_mobile/presentation/settings/settings_screen.dart';
import 'package:bourgo_arena_mobile/presentation/settings/terms_of_service_screen.dart';
import 'package:bourgo_arena_mobile/presentation/settings/viewmodels/settings_view_model.dart';
import 'package:bourgo_arena_mobile/presentation/onboarding/language_selection_screen.dart';
import 'package:bourgo_arena_mobile/presentation/onboarding/theme_selection_screen.dart';
import 'package:bourgo_arena_mobile/presentation/settings/notifications_preferences_screen.dart';
import 'package:bourgo_arena_mobile/presentation/planning/planning_screen.dart';
import 'package:bourgo_arena_mobile/domain/usecases/auth/login_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/auth/register_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/auth/reset_password_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/auth/send_otp_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/auth/verify_otp_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/auth/get_verification_status_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/loyalty/get_loyalty_balance_use_case.dart';
import 'package:bourgo_arena_mobile/domain/repositories/auth_repository.dart';
import 'package:bourgo_arena_mobile/presentation/service/service_detail_screen.dart';
import 'package:bourgo_arena_mobile/presentation/service/services_screen.dart';
import 'package:bourgo_arena_mobile/domain/entities/service.dart';
import 'package:bourgo_arena_mobile/presentation/planning/course_detail_screen.dart';
import 'package:bourgo_arena_mobile/domain/entities/course.dart';
import 'package:bourgo_arena_mobile/presentation/profile/transaction_history_screen.dart';
import 'package:bourgo_arena_mobile/presentation/profile/viewmodels/transaction_history_view_model.dart';
import 'package:bourgo_arena_mobile/domain/entities/event.dart';
import 'package:bourgo_arena_mobile/presentation/events/events_screen.dart';
import 'package:bourgo_arena_mobile/presentation/events/event_detail_screen.dart';
import 'package:bourgo_arena_mobile/presentation/events/my_events_screen.dart';
import 'package:bourgo_arena_mobile/presentation/events/bracket_screen.dart';
import 'package:bourgo_arena_mobile/presentation/courses/courses_screen.dart';
import 'package:bourgo_arena_mobile/presentation/activities_list/activities_list_screen.dart';
import 'package:bourgo_arena_mobile/presentation/booking/payment_gateway_screen.dart';
import 'package:bourgo_arena_mobile/presentation/profile/subscription_management_screen.dart';
import 'package:bourgo_arena_mobile/presentation/profile/plan_detail_screen.dart';
import 'package:bourgo_arena_mobile/presentation/payment/payment_selection_screen.dart';
import 'package:bourgo_arena_mobile/domain/entities/plan.dart';
import 'package:bourgo_arena_mobile/domain/entities/subscription.dart';
import 'package:bourgo_arena_mobile/presentation/common/transitions/app_page_transitions.dart';

import 'package:bourgo_arena_mobile/presentation/booking/reservations_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'dart:developer' as developer;

Map<String, dynamic> _draftExtra(AuthStateNotifier authStateNotifier) {
  final draft = authStateNotifier.registrationData;
  return draft ?? <String, dynamic>{};
}

Map<String, dynamic> _currentOrDraftExtra(
  GoRouterState state,
  AuthStateNotifier authStateNotifier,
) {
  final extra = state.extraAsMap;
  return extra.isNotEmpty ? extra : _draftExtra(authStateNotifier);
}

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

/// Creates and configures the application [GoRouter] with all route
/// definitions, redirect logic, and deep-link support.
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

    // 2. Force Theme Selection if not set
    if (!settingsViewModel.isThemeSelected) {
      return state.matchedLocation == '/theme-selection'
          ? null
          : '/theme-selection';
    }

    // 3. Prevent accessing setup screens once set
    if (state.matchedLocation == '/language-selection' ||
        state.matchedLocation == '/theme-selection') {
      return '/';
    }

    // 4. Auth Redirection
    final authState = authStateNotifier.state;
    final location = state.matchedLocation;
    developer.log('Router.redirect: authState=$authState, location=$location');

    // Truly public routes accessible to everyone
    final bool isAlwaysPublic =
        location == '/terms' ||
        location == '/privacy' ||
        location == '/offline' ||
        location == '/language-selection' ||
        location == '/theme-selection';

    if (isAlwaysPublic) return null;

    // Routes that are for unauthenticated users only (auth entry)
    final bool isAuthEntryRoute =
        location == '/login' ||
        location == '/register' ||
        location == '/forgot-password' ||
        location == '/new-password' ||
        location == '/onboarding' ||
        location == '/';

    // Routes that can be browsed by guests without authentication
    final bool isGuestAccessibleRoute =
        location == '/home' ||
        location == '/planning' ||
        location == '/search' ||
        location == '/services' ||
        location.startsWith('/services/') ||
        location.startsWith('/courses/') ||
        location.startsWith('/activities/') ||
        location.startsWith('/events/');

    // Routes that are part of the verification/onboarding flow
    final bool isSetupRoute =
        location == '/otp' ||
        location == '/verification-method' ||
        location == '/verify-additional-method' ||
        location == '/account-setup' ||
        location == '/family-onboarding';

    final draftRoute = authStateNotifier.registrationRoute;
    if (authState == AuthState.unauthenticated &&
        draftRoute != null &&
        location != draftRoute &&
        location != '/login') {
      return draftRoute;
    }

    switch (authState) {
      case AuthState.unauthenticated:
      case AuthState.guest:
        // Allow auth entry, onboarding, and guest accessible routes, otherwise force login
        return (isAuthEntryRoute || isSetupRoute || isGuestAccessibleRoute)
            ? null
            : '/login';

      case AuthState.pendingVerification:
        // Force the user to choose email or phone verification first.
        if (location == '/verification-method' ||
            location == '/otp' ||
            location == '/family-onboarding') {
          return null;
        }
        return '/verification-method';

      case AuthState.pendingAdditionalVerification:
        final onboardingCompleted =
            authStateNotifier.session.verificationData?.onboardingCompleted ??
            true;

        if (!onboardingCompleted) {
          if (location == '/verification-method' ||
              location == '/otp' ||
              location == '/account-setup' ||
              location == '/family-onboarding') {
            return null;
          }

          return '/verification-method';
        }

        if (location == '/verify-additional-method' || location == '/otp') {
          return null;
        }

        return '/verify-additional-method';

      case AuthState.pendingOnboarding:
      case AuthState.pendingDeletionCancellation:
        // Force OTP cancellation flow when account is pending deletion.
        if (authState == AuthState.pendingDeletionCancellation &&
            location == '/otp') {
          return null;
        } else if (authState == AuthState.pendingDeletionCancellation) {
          return '/otp';
        }

        // Allow staying on login or otp to show the "Account Setup Required" modal
        if (location == '/login' ||
            location == '/otp' ||
            location == '/account-setup' ||
            location == '/family-onboarding') {
          return null;
        }
        return '/account-setup';

      case AuthState.authenticated:
        // Force additional verification if required for this session
        if (authStateNotifier.session.needsLoginVerification &&
            !authStateNotifier.skippedForSession) {
          if (location == '/verify-additional-method' || location == '/otp') {
            return null;
          }
          return '/verify-additional-method';
        }

        // Prevent accessing auth/setup routes once fully authenticated or skipped
        if (isAuthEntryRoute || isSetupRoute) {
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
    GoRoute(
      path: '/theme-selection',
      builder: (context, state) =>
          ThemeSelectionScreen(viewModel: settingsViewModel),
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
      builder: (context, state) => RegisterScreen(
        registerUseCase: locator<RegisterUseCase>(),
        initialData: _currentOrDraftExtra(state, authStateNotifier),
      ),
    ),
    GoRoute(
      path: '/otp',
      builder: (context, state) {
        final data = state.extraAsMap;
        final destination =
            data['destination'] as String? ??
            authStateNotifier.session.pendingEmail;
        final isDeletionCancellation =
            authStateNotifier.state == AuthState.pendingDeletionCancellation;
        return OtpScreen(
          destination: destination,
          registrationData: data['registrationData'] as Map<String, dynamic>?,
          isPasswordReset: data['isPasswordReset'] as bool? ?? false,
          autoSendOtp: !isDeletionCancellation,
          sendOtpUseCase: locator<SendOtpUseCase>(),
          verifyOtpUseCase: locator<VerifyOtpUseCase>(),
          getVerificationStatusUseCase: locator<GetVerificationStatusUseCase>(),
          requestFamilyAccountOtpUseCase: locator<RequestFamilyAccountOtpUseCase>(),
        );
      },
    ),
    GoRoute(
      path: '/verification-method',
      builder: (context, state) {
        final data = _currentOrDraftExtra(state, authStateNotifier);
        final verificationData = authStateNotifier.session.verificationData;
        final user = authStateNotifier.session.user;

        final registrationData = <String, dynamic>{
          ...data,
          'email': data['email'] ?? verificationData?.email ?? user?.email,
          'phone': data['phone'] ?? verificationData?.phone ?? user?.phone,
        };

        return VerificationMethodScreen(
          registrationData: registrationData,
          sendOtpUseCase: locator<SendOtpUseCase>(),
        );
      },
    ),
    GoRoute(
      path: '/verify-additional-method',
      builder: (context, state) {
        final verificationData = authStateNotifier.session.verificationData;
        final user = authStateNotifier.session.user;
        return VerifyAdditionalMethodScreen(
          unverifiedMethod: verificationData?.unverifiedMethod ?? 'phone',
          email: verificationData?.email ?? user?.email,
          phone: verificationData?.phone ?? user?.phone,
          sendOtpUseCase: locator<SendOtpUseCase>(),
          authRepository: locator<AuthRepository>(),
          getVerificationStatusUseCase: locator<GetVerificationStatusUseCase>(),
          authStateNotifier: authStateNotifier,
        );
      },
    ),
    GoRoute(
      path: '/family-onboarding',
      builder: (context, state) => FamilyOnboardingScreen(
        registrationData: _currentOrDraftExtra(state, authStateNotifier),
      ),
    ),
    GoRoute(
      path: '/account-setup',
      builder: (context, state) {
        final data = _currentOrDraftExtra(state, authStateNotifier);
        if (data.isNotEmpty) {
          return AccountSetupScreen(registrationData: data);
        }

        // Fallback for users who just logged in and need onboarding
        final user = authStateNotifier.session.user;
        final registrationData = {
          'firstName': user?.firstName ?? '',
          'lastName': user?.lastName ?? '',
          'email': user?.email ?? '',
          'phone': user?.phone ?? '',
          'gender': user?.gender,
          'birthDate': user?.birthDate,
          'isParentAccount': user?.isParentAccount ?? false,
        };
        return AccountSetupScreen(registrationData: registrationData);
      },
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
      path: '/loyalty',
      builder: (context, state) => LoyaltyDashboardScreen(
        viewModel: LoyaltyDashboardViewModel(
          authStateNotifier: authStateNotifier,
          getLoyaltyBalanceUseCase: locator<GetLoyaltyBalanceUseCase>(),
        ),
      ),
    ),
    GoRoute(
      path: '/subscription',
      pageBuilder: (context, state) =>
          AppPageTransitions.pushPage(state, const SubscriptionScreen()),
    ),
    GoRoute(
      path: '/plans',
      pageBuilder: (context, state) => AppPageTransitions.pushPage(
        state,
        SubscriptionManagementScreen(
          currentSubscription: state.extra as Subscription?,
          childId: state.uri.queryParameters['childId'],
        ),
      ),
    ),
    GoRoute(
      path: '/plans/:id',
      pageBuilder: (context, state) {
        final planId = state.pathParameters['id']!;
        final plan = state.extra as Plan?;
        final childId = state.uri.queryParameters['childId'];
        return AppPageTransitions.pushPage(
          state,
          PlanDetailScreen(planId: planId, plan: plan, childId: childId),
        );
      },
    ),
    GoRoute(
      path: '/payment-selection',
      pageBuilder: (context, state) {
        final extra = state.extra! as Map<String, dynamic>;
        return AppPageTransitions.pushPage(
          state,
          PaymentSelectionScreen(
            plan: extra['plan'] as Plan,
            childId: extra['childId'] as String?,
          ),
        );
      },
    ),
    GoRoute(
      path: '/notifications',
      builder: (context, state) => const NotificationsScreen(),
    ),
    GoRoute(
      path: '/bookings',
      builder: (context, state) => const ReservationsScreen(),
    ),
    GoRoute(
      path: '/settings',
      builder: (context, state) => SettingsScreen(viewModel: settingsViewModel),
    ),
    GoRoute(
      path: '/notifications-preferences',
      builder: (context, state) =>
          NotificationsPreferencesScreen(viewModel: settingsViewModel),
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
    GoRoute(
      path: '/manage-children',
      builder: (context, state) => const ManageChildrenScreen(),
    ),
    GoRoute(
      path: '/add-child',
      builder: (context, state) => const AddEditChildScreen(),
    ),
    GoRoute(
      path: '/edit-child/:id',
      builder: (context, state) {
        final childId = state.pathParameters['id'];
        final child = state.extra as ChildProfile?;
        return AddEditChildScreen(childId: childId, child: child);
      },
    ),
    GoRoute(
      path: '/child/:childId/profile',
      builder: (context, state) => ChildProfileScreen(
        childId: state.pathParameters['childId']!,
      ),
    ),
    GoRoute(
      path: '/child/:childId/schedule',
      builder: (context, state) => ChildScheduleScreen(
        childId: state.pathParameters['childId']!,
      ),
    ),
    GoRoute(
      path: '/child/:childId/subscriptions',
      builder: (context, state) => ChildSubscriptionsScreen(
        childId: state.pathParameters['childId']!,
      ),
    ),
    GoRoute(
      path: '/child/:childId/bookings',
      builder: (context, state) => ChildBookingsScreen(
        childId: state.pathParameters['childId']!,
      ),
    ),
    GoRoute(
      path: '/child/:childId/sessions',
      builder: (context, state) => ChildSessionsScreen(
        childId: state.pathParameters['childId']!,
      ),
    ),
    GoRoute(
      path: '/child/:childId/reservations',
      builder: (context, state) => ChildReservationsScreen(
        childId: state.pathParameters['childId']!,
      ),
    ),
    GoRoute(
      path: '/child/:childId/completed',
      builder: (context, state) => ChildCompletedScreen(
        childId: state.pathParameters['childId']!,
      ),
    ),
    GoRoute(
      path: '/courses',
      builder: (context, state) => const CoursesScreen(),
    ),
    GoRoute(
      path: '/activities',
      builder: (context, state) => const ActivitiesListScreen(),
    ),
    GoRoute(
      path: '/services',
      builder: (context, state) => const ServicesScreen(),
    ),
    GoRoute(
      path: '/services/:id',
      builder: (context, state) {
        final serviceId = state.pathParameters['id']!;
        final service = state.extra as Service?;
        return ServiceDetailScreen(serviceId: serviceId, service: service);
      },
    ),
    GoRoute(
      path: '/courses/:id',
      builder: (context, state) {
        final courseId = state.pathParameters['id']!;
        final course = state.extra as Course?;
        return CourseDetailScreen(courseId: courseId, course: course);
      },
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
    GoRoute(
      path: '/transactions',
      builder: (context, state) =>
          PaymentHistoryScreen(viewModel: locator<PaymentHistoryViewModel>()),
    ),
    GoRoute(
      path: '/my-events',
      builder: (context, state) => const MyEventsScreen(),
    ),
    GoRoute(path: '/events', builder: (context, state) => const EventsScreen()),
    GoRoute(
      path: '/events/:id',
      builder: (context, state) {
        final eventId = state.pathParameters['id']!;
        final event = state.extra as Event?;
        return EventDetailScreen(eventId: eventId, event: event);
      },
      routes: [
        GoRoute(
          path: 'bracket',
          builder: (context, state) {
            final eventId = state.pathParameters['id']!;
            final event = state.extra as Event?;
            return BracketScreen(eventId: eventId, event: event);
          },
        ),
      ],
    ),
    GoRoute(
      path: '/payment/:id',
      builder: (context, state) {
        final reservationId = state.pathParameters['id']!;
        return PaymentGatewayScreen(reservationId: reservationId);
      },
    ),
    GoRoute(
      path: '/activities/:id/slots',
      builder: (context, state) {
        // The API directs to slots, which maps to our booking flow.
        return BookingFlowScreen(initialActivity: state.extraAsActivity);
      },
    ),
    GoRoute(
      path: '/events/:id/participants',
      builder: (context, state) {
        final eventId = state.pathParameters['id']!;
        final event = state.extra as Event?;
        return EventDetailScreen(eventId: eventId, event: event);
      },
    ),
    // NFC screen removed — route intentionally deleted.
  ],
);
