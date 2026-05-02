import 'package:bourgo_arena_mobile/data/services/auth_service.dart';
import 'package:bourgo_arena_mobile/main.dart';
import 'package:bourgo_arena_mobile/presentation/settings/settings_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockSettingsViewModel extends Mock implements SettingsViewModel {}

class MockAuthService extends Mock implements AuthService {}

void main() {
  late MockSettingsViewModel mockSettingsViewModel;
  late MockAuthService mockAuthService;

  setUp(() {
    mockSettingsViewModel = MockSettingsViewModel();
    mockAuthService = MockAuthService();
    when(() => mockSettingsViewModel.themeMode).thenReturn(ThemeMode.dark);
    when(() => mockSettingsViewModel.locale).thenReturn(const Locale('fr'));
    when(() => mockAuthService.isAuthenticated).thenReturn(false);
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
