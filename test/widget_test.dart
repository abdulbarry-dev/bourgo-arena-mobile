import 'package:bourgo_arena_mobile/core/di/locator.dart';
import 'package:bourgo_arena_mobile/data/services/activity_service.dart';
import 'package:bourgo_arena_mobile/data/services/auth_service.dart';
import 'package:bourgo_arena_mobile/main.dart';
import 'package:bourgo_arena_mobile/presentation/settings/viewmodels/settings_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockSettingsViewModel extends Mock implements SettingsViewModel {}

class MockAuthService extends Mock implements AuthService {}

class MockActivityService extends Mock implements ActivityService {}

void main() {
  late MockSettingsViewModel mockSettingsViewModel;
  late MockAuthService mockAuthService;
  late MockActivityService mockActivityService;

  setUp(() async {
    mockSettingsViewModel = MockSettingsViewModel();
    mockAuthService = MockAuthService();
    mockActivityService = MockActivityService();

    // Reset locator before each test
    await locator.reset();
    locator.registerSingleton<ActivityService>(mockActivityService);

    when(() => mockSettingsViewModel.themeMode).thenReturn(ThemeMode.dark);
    when(() => mockSettingsViewModel.locale).thenReturn(const Locale('fr'));
    when(() => mockSettingsViewModel.isLanguageSelected).thenReturn(true);
    when(() => mockAuthService.isAuthenticated).thenReturn(false);
    when(() => mockAuthService.addListener(any())).thenReturn(null);
    when(() => mockSettingsViewModel.addListener(any())).thenReturn(null);
  });

  testWidgets('Onboarding screen smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      BourgoArenaApp(
        settingsViewModel: mockSettingsViewModel,
        authService: mockAuthService,
      ),
    );

    // Verify that the onboarding screen displays the brand text.
    expect(find.text('BOURGO'), findsOneWidget);
    expect(find.text('ARENA'), findsOneWidget);

    // Verify that the "COMMENCER" button is present.
    // Note: This depends on the default locale (fr) we mocked.
    expect(find.text('COMMENCER'), findsOneWidget);
  });
}
