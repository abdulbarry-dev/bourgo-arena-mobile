import 'package:bourgo_arena_mobile/core/di/locator.dart';
import 'package:bourgo_arena_mobile/core/theme/bourgo_theme.dart';
import 'package:bourgo_arena_mobile/core/utils/result.dart';
import 'package:bourgo_arena_mobile/domain/core/app_error_code.dart';
import 'package:bourgo_arena_mobile/domain/core/failure.dart';
import 'package:bourgo_arena_mobile/domain/entities/auth_session.dart';
import 'package:bourgo_arena_mobile/domain/entities/auth_state.dart';
import 'package:bourgo_arena_mobile/domain/repositories/session_repository.dart';
import 'package:bourgo_arena_mobile/domain/usecases/auth/send_otp_use_case.dart';
import 'package:bourgo_arena_mobile/l10n/app_localizations.dart';
import 'package:bourgo_arena_mobile/presentation/auth/auth_state_notifier.dart';
import 'package:bourgo_arena_mobile/presentation/auth/register/verification_method_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';

class MockSendOtpUseCase extends Mock implements SendOtpUseCase {}

class MockSessionRepository extends Mock implements SessionRepository {}

class MockAuthStateNotifier extends Mock implements AuthStateNotifier {}

void main() {
  late MockSendOtpUseCase mockSendOtpUseCase;
  late MockSessionRepository mockSessionRepository;
  late MockAuthStateNotifier mockAuthStateNotifier;

  setUpAll(() {
    registerFallbackValue(<String, dynamic>{});
  });

  setUp(() async {
    mockSendOtpUseCase = MockSendOtpUseCase();
    mockSessionRepository = MockSessionRepository();
    mockAuthStateNotifier = MockAuthStateNotifier();

    await locator.reset();
    locator.registerSingleton<SessionRepository>(mockSessionRepository);
    locator.registerSingleton<AuthStateNotifier>(mockAuthStateNotifier);

    when(
      () => mockSessionRepository.saveRegistrationDraft(any()),
    ).thenAnswer((_) async => const Success<void, Failure>(null));
    when(() => mockAuthStateNotifier.addListener(any())).thenReturn(null);
    when(() => mockAuthStateNotifier.removeListener(any())).thenReturn(null);
    when(
      () => mockAuthStateNotifier.session,
    ).thenReturn(const AuthSession(state: AuthState.unauthenticated));
  });

  tearDown(() async {
    await locator.reset();
  });

  Widget createWidgetUnderTest() {
    final router = GoRouter(
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => VerificationMethodScreen(
            registrationData: const {},
            sendOtpUseCase: mockSendOtpUseCase,
          ),
        ),
        GoRoute(
          path: '/account-setup',
          builder: (context, state) =>
              const Scaffold(body: Text('Account Setup')),
        ),
      ],
    );

    return MaterialApp.router(
      theme: BourgoTheme.lightTheme,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      routerConfig: router,
    );
  }

  testWidgets(
    'falls back to account setup when no verification method is available',
    (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      expect(find.text('Account Setup'), findsOneWidget);
      expect(find.byType(VerificationMethodScreen), findsNothing);
    },
  );

  testWidgets('sends OTP for a trimmed email and navigates to OTP', (
    tester,
  ) async {
    when(
      () => mockSendOtpUseCase(any()),
    ).thenAnswer((_) async => const Success(null));

    await tester.pumpWidget(
      MaterialApp.router(
        theme: BourgoTheme.lightTheme,
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        routerConfig: GoRouter(
          routes: [
            GoRoute(
              path: '/',
              builder: (context, state) => VerificationMethodScreen(
                registrationData: const {
                  'email': '  alex@example.com  ',
                  'phone': '   ',
                },
                sendOtpUseCase: mockSendOtpUseCase,
              ),
            ),
            GoRoute(
              path: '/otp',
              builder: (context, state) => const Scaffold(body: Text('OTP')),
            ),
          ],
        ),
      ),
    );

    await tester.pumpAndSettle();
    await tester.tap(find.textContaining('alex@example.com'));
    await tester.pumpAndSettle();

    verify(() => mockSendOtpUseCase('alex@example.com')).called(1);
    expect(find.text('OTP'), findsOneWidget);
    expect(find.text('Verification'), findsNothing);
  });

  testWidgets('keeps the user on the screen when OTP sending fails', (
    tester,
  ) async {
    when(() => mockSendOtpUseCase(any())).thenAnswer(
      (_) async =>
          FailureResult(Failure.server(AppErrorCode.serverError, 'failed')),
    );

    await tester.pumpWidget(
      MaterialApp.router(
        theme: BourgoTheme.lightTheme,
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        routerConfig: GoRouter(
          routes: [
            GoRoute(
              path: '/',
              builder: (context, state) => VerificationMethodScreen(
                registrationData: const {
                  'email': 'alex@example.com',
                  'phone': '+15550000000',
                },
                sendOtpUseCase: mockSendOtpUseCase,
              ),
            ),
            GoRoute(
              path: '/otp',
              builder: (context, state) => const Scaffold(body: Text('OTP')),
            ),
          ],
        ),
      ),
    );

    await tester.pumpAndSettle();
    await tester.tap(find.textContaining('alex@example.com'));

    // Pump to show AppToast
    await tester.pump();

    expect(find.text('OTP'), findsNothing);
    expect(find.textContaining('failed'), findsOneWidget);

    await tester.pumpAndSettle();
    await tester.pump(const Duration(seconds: 5));
  });
}
