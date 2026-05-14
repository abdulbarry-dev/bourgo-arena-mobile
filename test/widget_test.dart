import 'package:bourgo_arena_mobile/domain/entities/auth_state.dart';
import 'package:bourgo_arena_mobile/core/di/locator.dart';
import 'package:bourgo_arena_mobile/presentation/auth/auth_state_notifier.dart';
import 'package:bourgo_arena_mobile/main.dart';
import 'package:bourgo_arena_mobile/presentation/common/widgets/brand_logo.dart';
import 'package:bourgo_arena_mobile/presentation/settings/viewmodels/settings_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockSettingsViewModel extends Mock implements SettingsViewModel {}

class MockAuthStateNotifier extends Mock implements AuthStateNotifier {}

void main() {
  late MockSettingsViewModel mockSettingsViewModel;
  late MockAuthStateNotifier mockAuthStateNotifier;

  setUp(() async {
    mockSettingsViewModel = MockSettingsViewModel();
    mockAuthStateNotifier = MockAuthStateNotifier();

    // Reset locator before each test
    await locator.reset();

    when(() => mockSettingsViewModel.themeMode).thenReturn(ThemeMode.dark);
    when(() => mockSettingsViewModel.locale).thenReturn(const Locale('fr'));
    when(() => mockSettingsViewModel.isLanguageSelected).thenReturn(true);
    when(() => mockAuthStateNotifier.isAuthenticated).thenReturn(false);
    when(
      () => mockAuthStateNotifier.state,
    ).thenReturn(AuthState.unauthenticated);
    when(() => mockAuthStateNotifier.addListener(any())).thenReturn(null);
    when(() => mockSettingsViewModel.addListener(any())).thenReturn(null);
  });

  testWidgets('Onboarding screen smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      BourgoArenaApp(
        settingsViewModel: mockSettingsViewModel,
        authStateNotifier: mockAuthStateNotifier,
      ),
    );

    // Wait for any animations and initializations
    await tester.pumpAndSettle();

    // Verify that the onboarding screen displays the brand logo.
    expect(find.byType(BrandLogo), findsOneWidget);

    // Verify that the start button is present.
    // In fr locale, commonStart is "COMMENCER"
    expect(find.text('COMMENCER'), findsOneWidget);
  });
}
