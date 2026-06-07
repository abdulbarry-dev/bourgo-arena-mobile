import 'package:bourgo_arena_mobile/core/di/locator.dart';
import 'package:bourgo_arena_mobile/core/utils/result.dart';
import 'package:bourgo_arena_mobile/domain/entities/auth_state.dart';
import 'package:bourgo_arena_mobile/domain/repositories/session_repository.dart';
import 'package:bourgo_arena_mobile/l10n/app_localizations.dart';
import 'package:bourgo_arena_mobile/presentation/auth/auth_state_notifier.dart';
import 'package:bourgo_arena_mobile/presentation/auth/register/family_onboarding_screen.dart';
import 'package:bourgo_arena_mobile/presentation/settings/viewmodels/settings_view_model.dart';
import 'package:bourgo_arena_mobile/router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockSettingsViewModel extends Mock implements SettingsViewModel {}

class MockAuthStateNotifier extends Mock implements AuthStateNotifier {}

class MockSessionRepository extends Mock implements SessionRepository {}

void main() {
  late MockSettingsViewModel mockSettingsViewModel;
  late MockAuthStateNotifier mockAuthStateNotifier;
  late MockSessionRepository mockSessionRepository;

  setUpAll(() {
    registerFallbackValue(<String, dynamic>{});
  });

  setUp(() async {
    mockSettingsViewModel = MockSettingsViewModel();
    mockAuthStateNotifier = MockAuthStateNotifier();
    mockSessionRepository = MockSessionRepository();

    await locator.reset();
    locator.registerSingleton<SessionRepository>(mockSessionRepository);

    when(() => mockSettingsViewModel.addListener(any())).thenReturn(null);
    when(() => mockSettingsViewModel.removeListener(any())).thenReturn(null);
    when(() => mockSettingsViewModel.isLanguageSelected).thenReturn(true);
    when(() => mockSettingsViewModel.isThemeSelected).thenReturn(true);
    when(() => mockAuthStateNotifier.addListener(any())).thenReturn(null);
    when(() => mockAuthStateNotifier.removeListener(any())).thenReturn(null);
    when(
      () => mockAuthStateNotifier.state,
    ).thenReturn(AuthState.unauthenticated);
    when(
      () => mockAuthStateNotifier.registrationRoute,
    ).thenReturn('/family-onboarding');
    when(() => mockAuthStateNotifier.registrationData).thenReturn({
      'firstName': 'John',
      'lastName': 'Doe',
      'email': 'john@example.com',
      'phone': '123456789',
      'isParentAccount': true,
      'familyMembers': const [],
    });
    when(
      () => mockSessionRepository.saveRegistrationDraft(any()),
    ).thenAnswer((_) async => const Success(null));
  });

  tearDown(() async {
    await locator.reset();
  });

  Widget createWidgetUnderTest() {
    return MaterialApp.router(
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

  testWidgets('redirects to the saved onboarding step after restart', (
    tester,
  ) async {
    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pumpAndSettle();

    expect(find.byType(FamilyOnboardingScreen), findsOneWidget);
    verify(
      () => mockSessionRepository.saveRegistrationDraft(any()),
    ).called(greaterThan(0));
  });
}
