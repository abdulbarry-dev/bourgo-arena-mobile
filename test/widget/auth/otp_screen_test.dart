import 'package:bourgo_arena_mobile/core/di/locator.dart';
import 'package:bourgo_arena_mobile/core/utils/result.dart';
import 'package:bourgo_arena_mobile/domain/core/failure.dart';
import 'package:bourgo_arena_mobile/domain/entities/auth_state.dart';
import 'package:bourgo_arena_mobile/domain/entities/verification_status.dart';
import 'package:bourgo_arena_mobile/domain/usecases/auth/send_otp_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/auth/verify_otp_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/auth/get_verification_status_use_case.dart';
import 'package:bourgo_arena_mobile/l10n/app_localizations.dart';
import 'package:bourgo_arena_mobile/presentation/auth/auth_state_notifier.dart';
import 'package:bourgo_arena_mobile/presentation/auth/otp/otp_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';
import 'package:bourgo_arena_mobile/domain/core/app_error_code.dart';

class MockVerifyOtpUseCase extends Mock implements VerifyOtpUseCase {}

class MockSendOtpUseCase extends Mock implements SendOtpUseCase {}

class MockGetVerificationStatusUseCase extends Mock
    implements GetVerificationStatusUseCase {}

class MockAuthStateNotifier extends Mock implements AuthStateNotifier {}

void main() {
  late MockVerifyOtpUseCase mockVerifyOtpUseCase;
  late MockSendOtpUseCase mockSendOtpUseCase;
  late MockGetVerificationStatusUseCase mockGetVerificationStatusUseCase;
  late MockAuthStateNotifier mockAuthStateNotifier;

  setUpAll(() {
    registerFallbackValue(const Success<bool, Failure>(true));
    registerFallbackValue(const Success<void, Failure>(null));
  });

  setUp(() {
    mockVerifyOtpUseCase = MockVerifyOtpUseCase();
    mockSendOtpUseCase = MockSendOtpUseCase();
    mockGetVerificationStatusUseCase = MockGetVerificationStatusUseCase();
    mockAuthStateNotifier = MockAuthStateNotifier();

    locator.registerSingleton<AuthStateNotifier>(mockAuthStateNotifier);

    when(
      () => mockAuthStateNotifier.state,
    ).thenReturn(AuthState.unauthenticated);
    when(() => mockAuthStateNotifier.addListener(any())).thenReturn(null);
    when(() => mockAuthStateNotifier.removeListener(any())).thenReturn(null);

    // Default successful answer for resend which is called in initState
    when(
      () => mockSendOtpUseCase(any()),
    ).thenAnswer((_) async => const Success(null));
    when(() => mockGetVerificationStatusUseCase()).thenAnswer(
      (_) async => const Success(
        VerificationStatus(
          emailVerified: true,
          phoneVerified: true,
          onboardingCompleted: true,
          isFullyVerified: true,
          email: 'test@example.com',
          phone: '+1234567890',
        ),
      ),
    );
  });

  tearDown(() {
    locator.reset();
  });

  Widget createWidgetUnderTest({String? destination}) {
    final router = GoRouter(
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => OtpScreen(
            destination: destination,
            verifyOtpUseCase: mockVerifyOtpUseCase,
            sendOtpUseCase: mockSendOtpUseCase,
            getVerificationStatusUseCase: mockGetVerificationStatusUseCase,
          ),
        ),
        GoRoute(
          path: '/home',
          builder: (context, state) => const Scaffold(body: Text('Home')),
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

  group('OtpScreen -', () {
    testWidgets('renders all elements', (tester) async {
      await setupScreenSize(tester);
      await tester.pumpWidget(
        createWidgetUnderTest(destination: 'test@example.com'),
      );
      await tester.pumpAndSettle();

      expect(find.textContaining('test@example.com'), findsOneWidget);
      expect(find.byType(TextField), findsNWidgets(6));
      expect(find.byType(ElevatedButton), findsOneWidget);
    });

    testWidgets('entering code and tapping verify calls ViewModel', (
      tester,
    ) async {
      await setupScreenSize(tester);
      when(
        () => mockVerifyOtpUseCase(any(), any()),
      ).thenAnswer((_) async => const Success(true));

      await tester.pumpWidget(
        createWidgetUnderTest(destination: 'test@example.com'),
      );
      await tester.pumpAndSettle();

      final textFields = find.byType(TextField);
      for (int i = 0; i < 6; i++) {
        await tester.enterText(textFields.at(i), i.toString());
      }

      final verifyButton = find.byType(ElevatedButton);
      await tester.ensureVisible(verifyButton);
      await tester.tap(verifyButton);
      await tester.pump();

      verify(
        () => mockVerifyOtpUseCase('test@example.com', '012345'),
      ).called(1);
    });

    testWidgets('shows error message on failure', (tester) async {
      await setupScreenSize(tester);
      when(() => mockVerifyOtpUseCase(any(), any())).thenAnswer(
        (_) async => FailureResult(
          AuthFailure(AppErrorCode.invalidCredentials, 'Invalid code'),
        ),
      );

      await tester.pumpWidget(
        createWidgetUnderTest(destination: 'test@example.com'),
      );
      await tester.pumpAndSettle();

      final textFields = find.byType(TextField);
      for (int i = 0; i < 6; i++) {
        await tester.enterText(textFields.at(i), '1');
      }

      await tester.tap(find.byType(ElevatedButton));

      // Process microtasks and SnackBar animation
      await tester.pumpAndSettle();

      expect(find.text('Invalid code'), findsOneWidget);
    });

    testWidgets('resend button works after timer expires', (tester) async {
      await setupScreenSize(tester);
      when(
        () => mockSendOtpUseCase(any()),
      ).thenAnswer((_) async => const Success(null));

      await tester.pumpWidget(
        createWidgetUnderTest(destination: 'test@example.com'),
      );
      await tester.pumpAndSettle();

      // Wait for 60 seconds timer
      await tester.pump(const Duration(seconds: 61));
      await tester.pumpAndSettle();

      final resendButton = find.byType(TextButton);
      expect(resendButton, findsOneWidget);

      await tester.tap(resendButton);
      await tester.pump();

      // Called once in initState and once on tap
      verify(() => mockSendOtpUseCase('test@example.com')).called(2);
    });
  });
}
