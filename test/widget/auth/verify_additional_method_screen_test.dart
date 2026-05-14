import 'package:bourgo_arena_mobile/core/utils/result.dart';
import 'package:bourgo_arena_mobile/domain/core/failure.dart';
import 'package:bourgo_arena_mobile/domain/usecases/auth/send_otp_use_case.dart';
import 'package:bourgo_arena_mobile/l10n/app_localizations.dart';
import 'package:bourgo_arena_mobile/presentation/auth/widgets/verify_additional_method_screen.dart';
import 'package:bourgo_arena_mobile/domain/usecases/auth/get_verification_status_use_case.dart';
import 'package:bourgo_arena_mobile/domain/entities/verification_status.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';

class MockSendOtpUseCase extends Mock implements SendOtpUseCase {}
class MockGetVerificationStatusUseCase extends Mock implements GetVerificationStatusUseCase {}

void main() {
  late MockSendOtpUseCase mockSendOtpUseCase;
  late MockGetVerificationStatusUseCase mockGetVerificationStatusUseCase;

  setUpAll(() {
    registerFallbackValue(const Success<void, Failure>(null));
  });

  setUp(() {
    mockSendOtpUseCase = MockSendOtpUseCase();
    mockGetVerificationStatusUseCase = MockGetVerificationStatusUseCase();

    when(() => mockGetVerificationStatusUseCase()).thenAnswer((_) async => Success(VerificationStatus(emailVerified: true, phoneVerified: false, email: 'alex@example.com', phone: '+15550000000')));

    // Default successful answer for send OTP
    when(
      () => mockSendOtpUseCase(any()),
    ).thenAnswer((_) async => const Success(null));
  });

  Widget createWidgetUnderTest({
    required String unverifiedMethod,
    String? email,
    String? phone,
  }) {
    final router = GoRouter(
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => VerifyAdditionalMethodScreen(
            unverifiedMethod: unverifiedMethod,
            email: email,
            phone: phone,
            sendOtpUseCase: mockSendOtpUseCase,
            getVerificationStatusUseCase: mockGetVerificationStatusUseCase,
          ),
        ),
        GoRoute(
          path: '/otp',
          builder: (context, state) => const Scaffold(body: Text('OTP')),
        ),
        GoRoute(
          path: '/onboarding',
          builder: (context, state) => const Scaffold(body: Text('Onboarding')),
        ),
        GoRoute(
          path: '/account-setup',
          builder: (context, state) => const Scaffold(body: Text('Account Setup')),
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
      'renders email verification UI when unverifiedMethod is email',
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

        // Should show email verification title and subtitle
        expect(find.textContaining('Verify Email'), findsOneWidget);
        expect(find.textContaining('alex@example.com'), findsWidgets);
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

        // Should show phone verification title and subtitle
        expect(find.textContaining('Verify Phone'), findsOneWidget);
        expect(find.textContaining('+15550000000'), findsWidgets);
      },
    );

    
    testWidgets('renders skip for now button', (tester) async {
      await setupScreenSize(tester);
      await tester.pumpWidget(
        createWidgetUnderTest(
          unverifiedMethod: 'email',
          email: 'alex@example.com',
          phone: '+15550000000',
        ),
      );
      await tester.pumpAndSettle();

      expect(find.textContaining('SKIP'), findsOneWidget);
    });

    testWidgets('skip for now button navigates to onboarding', (tester) async {
      await setupScreenSize(tester);
      await tester.pumpWidget(
        createWidgetUnderTest(
          unverifiedMethod: 'email',
          email: 'alex@example.com',
          phone: '+15550000000',
        ),
      );
      await tester.pumpAndSettle();

      // Tap skip for now button
      await tester.tap(find.textContaining('SKIP FOR NOW'));
      await tester.pumpAndSettle();

      // Should navigate to onboarding
      expect(find.text('Account Setup'), findsOneWidget);
    });

    testWidgets('renders verify now button', (tester) async {
      await setupScreenSize(tester);
      await tester.pumpWidget(
        createWidgetUnderTest(
          unverifiedMethod: 'email',
          email: 'alex@example.com',
          phone: '+15550000000',
        ),
      );
      await tester.pumpAndSettle();

      expect(find.textContaining('VERIFY'), findsWidgets);
    });

    

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

        // Tap verify now button
        await tester.tap(find.textContaining('VERIFY NOW'));
        await tester.pumpAndSettle();

        verify(() => mockSendOtpUseCase('+15550000000')).called(1);
      },
    );

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

        // Tap verify now button
        await tester.tap(find.textContaining('VERIFY NOW'));
        await tester.pumpAndSettle();

        verify(() => mockSendOtpUseCase('alex@example.com')).called(1);
      },
    );

    testWidgets('navigates to OTP screen after sending OTP', (tester) async {
      await setupScreenSize(tester);
      await tester.pumpWidget(
        createWidgetUnderTest(
          unverifiedMethod: 'email',
          email: 'alex@example.com',
          phone: '+15550000000',
        ),
      );
      await tester.pumpAndSettle();

      // Tap verify now button
      await tester.tap(find.textContaining('VERIFY NOW'));
      await tester.pumpAndSettle();

      // Should navigate to OTP screen
      expect(find.text('OTP'), findsOneWidget);
    });

    

    testWidgets('renders title correctly', (tester) async {
      await setupScreenSize(tester);
      await tester.pumpWidget(
        createWidgetUnderTest(
          unverifiedMethod: 'email',
          email: 'alex@example.com',
          phone: '+15550000000',
        ),
      );
      await tester.pumpAndSettle();

      // Should show the main title
      expect(find.textContaining('Complete Your Verification'), findsOneWidget);
    });

    testWidgets('renders subtitle with method name', (tester) async {
      await setupScreenSize(tester);
      await tester.pumpWidget(
        createWidgetUnderTest(
          unverifiedMethod: 'phone',
          email: 'alex@example.com',
          phone: '+15550000000',
        ),
      );
      await tester.pumpAndSettle();

      // Should show subtitle with method name
      expect(find.textContaining('phone'), findsWidgets);
    });

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

      // Should render email icon
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

      // Should render phone icon
      expect(find.byIcon(Symbols.call), findsOneWidget);
    });

    testWidgets('handles null email correctly', (tester) async {
      when(() => mockGetVerificationStatusUseCase()).thenAnswer((_) async => Success(VerificationStatus(emailVerified: true, phoneVerified: false, email: null, phone: '+15550000000')));
      await setupScreenSize(tester);
      await tester.pumpWidget(
        createWidgetUnderTest(
          unverifiedMethod: 'phone',
          email: null,
          phone: '+15550000000',
        ),
      );
      await tester.pumpAndSettle();

      // Should render phone icon since email is null
      expect(find.byIcon(Symbols.call), findsOneWidget);
    });

    testWidgets('handles null phone correctly', (tester) async {
      when(() => mockGetVerificationStatusUseCase()).thenAnswer((_) async => Success(VerificationStatus(emailVerified: false, phoneVerified: true, email: 'alex@example.com', phone: null)));
      await setupScreenSize(tester);
      await tester.pumpWidget(
        createWidgetUnderTest(
          unverifiedMethod: 'email',
          email: 'alex@example.com',
          phone: null,
        ),
      );
      await tester.pumpAndSettle();

      // Should render mail icon since phone is null
      expect(find.byIcon(Symbols.mail), findsOneWidget);
    });

    testWidgets('handles OTP send failure gracefully', (tester) async {
      when(() => mockSendOtpUseCase(any())).thenAnswer(
        (_) async => FailureResult(ServerFailure('Failed to send OTP')),
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

      // Tap verify now button
      await tester.tap(find.textContaining('VERIFY NOW'));
      await tester.pumpAndSettle();

      // Verify the use case was called despite failure
      verify(() => mockSendOtpUseCase('alex@example.com')).called(1);
    });
  });
}
