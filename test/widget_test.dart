import 'package:bourgo_arena_mobile/core/di/locator.dart';
import 'package:bourgo_arena_mobile/data/services/activity_service.dart';
import 'package:bourgo_arena_mobile/presentation/auth/auth_state_notifier.dart';
import 'package:bourgo_arena_mobile/main.dart';
import 'package:bourgo_arena_mobile/presentation/common/widgets/brand_logo.dart';
import 'package:bourgo_arena_mobile/presentation/settings/viewmodels/settings_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockSettingsViewModel extends Mock implements SettingsViewModel {}

class MockAuthStateNotifier extends Mock implements AuthStateNotifier {}

class MockActivityService extends Mock implements ActivityService {}

void main() {
  late MockSettingsViewModel mockSettingsViewModel;
  late MockAuthStateNotifier mockAuthStateNotifier;
  late MockActivityService mockActivityService;

  setUp(() async {
    mockSettingsViewModel = MockSettingsViewModel();
    mockAuthStateNotifier = MockAuthStateNotifier();
    mockActivityService = MockActivityService();

    // Reset locator before each test
    await locator.reset();
    locator.registerSingleton<ActivityService>(mockActivityService);

    when(() => mockSettingsViewModel.themeMode).thenReturn(ThemeMode.dark);
    when(() => mockSettingsViewModel.locale).thenReturn(const Locale('fr'));
    when(() => mockSettingsViewModel.isLanguageSelected).thenReturn(true);
    when(() => mockAuthStateNotifier.isAuthenticated).thenReturn(false);
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
