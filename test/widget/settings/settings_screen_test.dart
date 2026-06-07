import 'package:bourgo_arena_mobile/core/theme/bourgo_theme.dart';
import 'package:bourgo_arena_mobile/l10n/app_localizations.dart';
import 'package:bourgo_arena_mobile/presentation/settings/settings_screen.dart';
import 'package:bourgo_arena_mobile/presentation/settings/viewmodels/settings_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockSettingsViewModel extends Mock implements SettingsViewModel {}

void main() {
  late MockSettingsViewModel mockViewModel;

  setUp(() {
    mockViewModel = MockSettingsViewModel();
    when(() => mockViewModel.themeMode).thenReturn(ThemeMode.system);
    when(() => mockViewModel.locale).thenReturn(const Locale('en'));
    when(() => mockViewModel.notificationsEnabled).thenReturn(true);
    when(() => mockViewModel.isLanguageSelected).thenReturn(false);
    when(() => mockViewModel.isThemeSelected).thenReturn(false);
    when(() => mockViewModel.appVersion).thenReturn('1.0.0 (1)');

    // Stub addListener/removeListener because it's a ChangeNotifier
    when(() => mockViewModel.addListener(any())).thenReturn(null);
    when(() => mockViewModel.removeListener(any())).thenReturn(null);
  });

  Widget createWidgetUnderTest(WidgetTester tester) {
    tester.view.physicalSize = const Size(800, 2000);
    tester.view.devicePixelRatio = 1.0;
    return MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      theme: BourgoTheme.lightTheme,
      home: SettingsScreen(viewModel: mockViewModel),
    );
  }

  group('SettingsScreen', () {
    testWidgets('renders all sections and basic items', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest(tester));
      await tester.pumpAndSettle();

      expect(find.text('SETTINGS'), findsOneWidget);
      expect(find.text('ACCOUNT'), findsOneWidget);
      expect(find.text('PREFERENCES'), findsOneWidget);
      expect(find.text('LEGAL'), findsOneWidget);
      expect(find.text('ABOUT'), findsOneWidget);

      expect(find.text('Edit Profile'), findsOneWidget);
      expect(find.text('App Language'), findsOneWidget);
      expect(find.text('Display Mode'), findsOneWidget);
      expect(find.text('Push Notifications'), findsOneWidget);
    });

    testWidgets('tapping App Language opens bottom sheet', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest(tester));
      await tester.pumpAndSettle();

      await tester.tap(find.text('App Language'));
      await tester.pumpAndSettle();

      expect(find.text('English'), findsOneWidget);
      expect(find.text('Français'), findsOneWidget);
    });

    testWidgets('tapping Display Mode opens bottom sheet', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest(tester));
      await tester.pumpAndSettle();

      final displayModeFinder = find.text('Display Mode');
      await tester.ensureVisible(displayModeFinder.first);
      await tester.pumpAndSettle();

      await tester.tap(displayModeFinder.first);
      await tester.pumpAndSettle();

      expect(find.text('Light Mode'), findsOneWidget);
      expect(find.text('Dark Mode'), findsOneWidget);
    });

    testWidgets('toggling push notifications calls viewModel', (tester) async {
      when(
        () => mockViewModel.toggleNotifications(any()),
      ).thenAnswer((_) async {});

      await tester.pumpWidget(createWidgetUnderTest(tester));
      await tester.pumpAndSettle();

      final switchFinder = find.byType(Switch);
      expect(switchFinder, findsOneWidget);

      await tester.tap(switchFinder);
      await tester.pump();

      verify(() => mockViewModel.toggleNotifications(false)).called(1);
    });
  });
}
