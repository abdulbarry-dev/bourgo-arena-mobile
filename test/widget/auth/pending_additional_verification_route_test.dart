import 'package:bourgo_arena_mobile/core/di/locator.dart';
import 'package:bourgo_arena_mobile/core/utils/result.dart';
import 'package:bourgo_arena_mobile/domain/entities/auth_session.dart';
import 'package:bourgo_arena_mobile/domain/entities/auth_state.dart';
import 'package:bourgo_arena_mobile/domain/entities/verification_status.dart';
import 'package:bourgo_arena_mobile/domain/repositories/auth_repository.dart';
import 'package:bourgo_arena_mobile/domain/repositories/session_repository.dart';
import 'package:bourgo_arena_mobile/domain/usecases/auth/get_verification_status_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/auth/send_otp_use_case.dart';
import 'package:bourgo_arena_mobile/l10n/app_localizations.dart';
import 'package:bourgo_arena_mobile/core/theme/bourgo_theme.dart';
import 'package:bourgo_arena_mobile/presentation/auth/auth_state_notifier.dart';
import 'package:bourgo_arena_mobile/presentation/auth/register/verification_method_screen.dart';
import 'package:bourgo_arena_mobile/presentation/settings/viewmodels/settings_view_model.dart';
import 'package:bourgo_arena_mobile/router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockSettingsViewModel extends Mock implements SettingsViewModel {}

class MockAuthStateNotifier extends Mock implements AuthStateNotifier {}

class MockSendOtpUseCase extends Mock implements SendOtpUseCase {}

class MockAuthRepository extends Mock implements AuthRepository {}

class MockSessionRepository extends Mock implements SessionRepository {}

class MockGetVerificationStatusUseCase extends Mock
    implements GetVerificationStatusUseCase {}

void main() {
  late MockSettingsViewModel mockSettingsViewModel;
  late MockAuthStateNotifier mockAuthStateNotifier;
  late MockSendOtpUseCase mockSendOtpUseCase;
  late MockAuthRepository mockAuthRepository;
  late MockSessionRepository mockSessionRepository;
  late MockGetVerificationStatusUseCase mockGetVerificationStatusUseCase;

  setUpAll(() {
    registerFallbackValue(<String, dynamic>{});
  });

  setUp(() async {
    mockSettingsViewModel = MockSettingsViewModel();
    mockAuthStateNotifier = MockAuthStateNotifier();
    mockSendOtpUseCase = MockSendOtpUseCase();
    mockAuthRepository = MockAuthRepository();
    mockSessionRepository = MockSessionRepository();
    mockGetVerificationStatusUseCase = MockGetVerificationStatusUseCase();

    await locator.reset();
    locator.registerSingleton<SendOtpUseCase>(mockSendOtpUseCase);
    locator.registerSingleton<AuthRepository>(mockAuthRepository);
    locator.registerSingleton<SessionRepository>(mockSessionRepository);
    locator.registerSingleton<GetVerificationStatusUseCase>(
      mockGetVerificationStatusUseCase,
    );

    when(() => mockSettingsViewModel.addListener(any())).thenReturn(null);
    when(() => mockSettingsViewModel.removeListener(any())).thenReturn(null);
    when(() => mockSettingsViewModel.isLanguageSelected).thenReturn(true);
    when(() => mockSettingsViewModel.isThemeSelected).thenReturn(true);

    when(
      () => mockSessionRepository.saveRegistrationDraft(any()),
    ).thenAnswer((_) async => const Success(null));

    when(() => mockAuthStateNotifier.addListener(any())).thenReturn(null);
    when(() => mockAuthStateNotifier.removeListener(any())).thenReturn(null);
    when(
      () => mockAuthStateNotifier.state,
    ).thenReturn(AuthState.pendingAdditionalVerification);
    when(() => mockAuthStateNotifier.registrationRoute).thenReturn(null);
    when(() => mockAuthStateNotifier.skippedForSession).thenReturn(false);
    when(() => mockAuthStateNotifier.session).thenReturn(
      AuthSession(
        state: AuthState.pendingAdditionalVerification,
        token: 'token-123',
        verificationData: const VerificationData(
          unverifiedMethod: 'email',
          email: 'guenichi.abdelbari@gmail.com',
          phone: '55666222',
          onboardingCompleted: false,
        ),
      ),
    );

    when(() => mockGetVerificationStatusUseCase()).thenAnswer(
      (_) async => const Success(
        VerificationStatus(
          emailVerified: false,
          phoneVerified: false,
          onboardingCompleted: false,
          isFullyVerified: false,
          email: 'guenichi.abdelbari@gmail.com',
          phone: '55666222',
          unverifiedMethod: 'email',
        ),
      ),
    );
    when(
      () => mockSendOtpUseCase(any()),
    ).thenAnswer((_) async => const Success(null));
  });

  tearDown(() async {
    await locator.reset();
  });

  Widget createWidgetUnderTest() {
    return MaterialApp.router(
      theme: BourgoTheme.lightTheme,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      routerConfig: createRouter(mockSettingsViewModel, mockAuthStateNotifier),
    );
  }

  testWidgets(
    'shows the setup modal and continues to verification method for incomplete onboarding',
    (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      expect(find.byType(VerificationMethodScreen), findsOneWidget);
    },
  );
}
