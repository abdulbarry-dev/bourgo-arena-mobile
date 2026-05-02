import 'package:bourgo_arena_mobile/main.dart';
import 'package:bourgo_arena_mobile/presentation/settings/settings_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockSettingsViewModel extends Mock implements SettingsViewModel {}

void main() {
  late MockSettingsViewModel mockSettingsViewModel;

  setUp(() {
    mockSettingsViewModel = MockSettingsViewModel();
    when(() => mockSettingsViewModel.themeMode).thenReturn(ThemeMode.dark);
    when(() => mockSettingsViewModel.locale).thenReturn(const Locale('fr'));
  });

  testWidgets('Onboarding screen smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      BourgoArenaApp(settingsViewModel: mockSettingsViewModel),
    );

    // Verify that the onboarding screen displays the brand text.
    expect(find.text('BOURGO'), findsOneWidget);
    expect(find.text('ARENA'), findsOneWidget);

    // Verify that the "COMMENCER" button is present.
    // Note: This depends on the default locale (fr) we mocked.
    expect(find.text('COMMENCER'), findsOneWidget);
  });
}
