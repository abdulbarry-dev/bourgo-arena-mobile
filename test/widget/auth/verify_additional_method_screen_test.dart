import 'package:bourgo_arena_mobile/core/utils/result.dart';
import 'package:bourgo_arena_mobile/domain/core/app_error_code.dart';
import 'package:bourgo_arena_mobile/domain/core/failure.dart';
import 'package:bourgo_arena_mobile/domain/entities/auth_session.dart';
import 'package:bourgo_arena_mobile/domain/entities/auth_state.dart';
import 'package:bourgo_arena_mobile/domain/entities/verification_status.dart';
import 'package:bourgo_arena_mobile/domain/repositories/auth_repository.dart';
import 'package:bourgo_arena_mobile/domain/usecases/auth/get_verification_status_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/auth/send_otp_use_case.dart';
import 'package:bourgo_arena_mobile/l10n/app_localizations.dart';
import 'package:bourgo_arena_mobile/presentation/auth/auth_state_notifier.dart';
import 'package:bourgo_arena_mobile/presentation/auth/widgets/verify_additional_method_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:mocktail/mocktail.dart';

class MockSendOtpUseCase extends Mock implements SendOtpUseCase {}

class MockAuthRepository extends Mock implements AuthRepository {}

class MockGetVerificationStatusUseCase extends Mock
    implements GetVerificationStatusUseCase {}

class MockAuthStateNotifier extends Mock implements AuthStateNotifier {}

void main() {
  late MockSendOtpUseCase mockSendOtpUseCase;
  late MockGetVerificationStatusUseCase mockGetVerificationStatusUseCase;
  late MockAuthRepository mockAuthRepository;
  late MockAuthStateNotifier mockAuthStateNotifier;

  setUpAll(() {
    registerFallbackValue(const Success<void, Failure>(null));
  });

  setUp(() {
    mockSendOtpUseCase = MockSendOtpUseCase();
    mockGetVerificationStatusUseCase = MockGetVerificationStatusUseCase();
    mockAuthRepository = MockAuthRepository();
    mockAuthStateNotifier = MockAuthStateNotifier();

    when(() => mockAuthStateNotifier.addListener(any())).thenReturn(null);
    when(() => mockAuthStateNotifier.removeListener(any())).thenReturn(null);
    when(() => mockAuthStateNotifier.skipForSession()).thenReturn(null);
    when(() => mockAuthStateNotifier.skipForever()).thenAnswer((_) async {});
    when(() => mockAuthStateNotifier.session).thenReturn(
      AuthSession(
        user: null,
        state: AuthState.pendingAdditionalVerification,
        token: 'test_token',
        pendingEmail: null,
        verificationData: const VerificationData(
          unverifiedMethod: 'email',
          email: 'alex@example.com',
          phone: '+15550000000',
          onboardingCompleted: false,
        ),
        needsLoginVerification: false,
      ),
    );

    when(
      () => mockAuthRepository.skipAdditionalVerification(),
    ).thenAnswer((_) async => Success(true));

    when(
      () => mockSendOtpUseCase(any()),
    ).thenAnswer((_) async => const Success(null));
  });

  Widget createWidgetUnderTest({
    required String unverifiedMethod,
    String? email,
    String? phone,
    VerificationStatus? verificationStatus,
    bool onboardingCompleted = true,
  }) {
    final status =
        verificationStatus ??
        (unverifiedMethod == 'email'
            ? VerificationStatus(
                emailVerified: false,
                phoneVerified: true,
                onboardingCompleted: onboardingCompleted,
                isFullyVerified: false,
                email: email,
                phone: phone,
                unverifiedMethod: 'email',
              )
            : VerificationStatus(
                emailVerified: true,
                phoneVerified: false,
                onboardingCompleted: onboardingCompleted,
                isFullyVerified: false,
                email: email,
                phone: phone,
                unverifiedMethod: 'phone',
              ));

    when(
      () => mockGetVerificationStatusUseCase(),
    ).thenAnswer((_) async => Success(status));

    final router = GoRouter(
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => VerifyAdditionalMethodScreen(
            unverifiedMethod: unverifiedMethod,
            email: email,
            phone: phone,
            sendOtpUseCase: mockSendOtpUseCase,
            authRepository: mockAuthRepository,
            getVerificationStatusUseCase: mockGetVerificationStatusUseCase,
            authStateNotifier: mockAuthStateNotifier,
          ),
        ),
        GoRoute(
          path: '/otp',
          builder: (context, state) => const Scaffold(body: Text('OTP')),
        ),
        GoRoute(
          path: '/verification-method',
          builder: (context, state) =>
              const Scaffold(body: Text('VERIF_METHOD')),
        ),
        GoRoute(
          path: '/account-setup',
          builder: (context, state) =>
              const Scaffold(body: Text('Account Setup')),
        ),
      ],
    );

    return MaterialApp.router(
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

  Future<void> setupScreenSize(WidgetTester tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
  }

  group('VerifyAdditionalMethodScreen -', () {
    testWidgets(
      'redirects to verification-method when onboarding is incomplete',
      (tester) async {
        await setupScreenSize(tester);
        await tester.pumpWidget(
          createWidgetUnderTest(
            unverifiedMethod: 'email',
            email: 'alex@example.com',
            phone: '+15550000000',
            onboardingCompleted: false,
          ),
        );
        await tester.pumpAndSettle();

        expect(find.text('VERIF_METHOD'), findsOneWidget);
      },
    );

    testWidgets(
      'renders phone verification UI when unverifiedMethod is phone',
      (tester) async {
        await setupScreenSize(tester);
        await tester.pumpWidget(
          createWidgetUnderTest(
            unverifiedMethod: 'phone',
            email: 'alex@example.com',
            phone: '+15550000000',
          ),
        );
        await tester.pumpAndSettle();

        expect(find.byIcon(Symbols.call), findsOneWidget);
        expect(find.textContaining('+15550000000'), findsWidgets);
      },
    );

    testWidgets('skip for now calls skipForSession', (tester) async {
      await setupScreenSize(tester);
      await tester.pumpWidget(
        createWidgetUnderTest(
          unverifiedMethod: 'email',
          email: 'alex@example.com',
          phone: '+15550000000',
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.textContaining('SKIP FOR NOW'));
      await tester.pumpAndSettle();

      verify(() => mockAuthStateNotifier.skipForSession()).called(1);
    });

    testWidgets(
      'calls sendOtpUseCase with correct email when verify now is tapped',
      (tester) async {
        await setupScreenSize(tester);
        await tester.pumpWidget(
          createWidgetUnderTest(
            unverifiedMethod: 'email',
            email: 'alex@example.com',
            phone: '+15550000000',
          ),
        );
        await tester.pumpAndSettle();

        await tester.tap(find.textContaining('VERIFY NOW'));
        await tester.pumpAndSettle();

        verify(() => mockSendOtpUseCase('alex@example.com')).called(1);
        expect(find.text('OTP'), findsOneWidget);
      },
    );

    testWidgets(
      'calls sendOtpUseCase with correct phone when verify now is tapped',
      (tester) async {
        await setupScreenSize(tester);
        await tester.pumpWidget(
          createWidgetUnderTest(
            unverifiedMethod: 'phone',
            email: 'alex@example.com',
            phone: '+15550000000',
          ),
        );
        await tester.pumpAndSettle();

        await tester.tap(find.textContaining('VERIFY NOW'));
        await tester.pumpAndSettle();

        verify(() => mockSendOtpUseCase('+15550000000')).called(1);
        expect(find.text('OTP'), findsOneWidget);
      },
    );

    testWidgets('renders icon for email verification', (tester) async {
      await setupScreenSize(tester);
      await tester.pumpWidget(
        createWidgetUnderTest(
          unverifiedMethod: 'email',
          email: 'alex@example.com',
          phone: '+15550000000',
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byIcon(Symbols.mail), findsOneWidget);
    });

    testWidgets('renders icon for phone verification', (tester) async {
      await setupScreenSize(tester);
      await tester.pumpWidget(
        createWidgetUnderTest(
          unverifiedMethod: 'phone',
          email: 'alex@example.com',
          phone: '+15550000000',
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byIcon(Symbols.call), findsOneWidget);
    });

    testWidgets('handles null email correctly', (tester) async {
      await setupScreenSize(tester);
      await tester.pumpWidget(
        createWidgetUnderTest(
          unverifiedMethod: 'phone',
          email: null,
          phone: '+15550000000',
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byIcon(Symbols.call), findsOneWidget);
    });

    testWidgets('handles null phone correctly', (tester) async {
      await setupScreenSize(tester);
      await tester.pumpWidget(
        createWidgetUnderTest(
          unverifiedMethod: 'email',
          email: 'alex@example.com',
          phone: null,
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byIcon(Symbols.mail), findsOneWidget);
    });

    testWidgets('handles OTP send failure gracefully', (tester) async {
      when(() => mockSendOtpUseCase(any())).thenAnswer(
        (_) async => FailureResult(
          ServerFailure(AppErrorCode.serverError, 'Failed to send OTP'),
        ),
      );

      await setupScreenSize(tester);
      await tester.pumpWidget(
        createWidgetUnderTest(
          unverifiedMethod: 'email',
          email: 'alex@example.com',
          phone: '+15550000000',
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.textContaining('VERIFY NOW'));
      await tester.pumpAndSettle();

      verify(() => mockSendOtpUseCase('alex@example.com')).called(1);
    });
  });
}
