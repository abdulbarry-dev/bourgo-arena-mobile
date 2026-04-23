import 'package:bourgo_arena_mobile/presentation/auth/forgot_password/forgot_password_screen.dart';
import 'package:bourgo_arena_mobile/presentation/auth/login/login_screen.dart';
import 'package:bourgo_arena_mobile/presentation/auth/new_password/new_password_screen.dart';
import 'package:bourgo_arena_mobile/presentation/auth/otp/otp_screen.dart';
import 'package:bourgo_arena_mobile/presentation/auth/register/register_screen.dart';
import 'package:bourgo_arena_mobile/presentation/onboarding/onboarding_screen.dart';
import 'package:go_router/go_router.dart';

/// App routing configuration using GoRouter.
final router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const OnboardingScreen(),
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/register',
      builder: (context, state) => const RegisterScreen(),
    ),
    GoRoute(
      path: '/otp',
      builder: (context, state) => const OtpScreen(),
    ),
    GoRoute(
      path: '/forgot-password',
      builder: (context, state) => const ForgotPasswordScreen(),
    ),
    GoRoute(
      path: '/new-password',
      builder: (context, state) => const NewPasswordScreen(),
    ),
  ],
);
