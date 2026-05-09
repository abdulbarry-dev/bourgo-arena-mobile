import 'package:bourgo_arena_mobile/l10n/app_localizations.dart';
import 'package:bourgo_arena_mobile/presentation/settings/settings_screen.dart';
import 'package:bourgo_arena_mobile/presentation/settings/viewmodels/settings_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';

class _MockSettingsViewModel extends Mock implements SettingsViewModel {}

void main() {
  late _MockSettingsViewModel mockViewModel;

  setUpAll(() {
    registerFallbackValue(ThemeMode.system);
    registerFallbackValue(const Locale('en'));
  });

  setUp(() {
    mockViewModel = _MockSettingsViewModel();

    // SettingsScreen uses AnimatedBuilder — we must stub addListener /
    // removeListener so the framework can register its rebuild callback.
    when(() => mockViewModel.addListener(any())).thenReturn(null);
    when(() => mockViewModel.removeListener(any())).thenReturn(null);

    // Default property stubs.
    when(() => mockViewModel.themeMode).thenReturn(ThemeMode.system);
    when(() => mockViewModel.locale).thenReturn(const Locale('en'));
    when(() => mockViewModel.notificationsEnabled).thenReturn(true);
    when(() => mockViewModel.isLanguageSelected).thenReturn(true);
  });

  Widget buildSubject() {
    final router = GoRouter(
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => SettingsScreen(viewModel: mockViewModel),
        ),
      ],
    );

    return MaterialApp.router(
      routerConfig: router,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('en'), Locale('fr')],
    );
  }

  group('SettingsScreen widget tests', () {
    testWidgets('renders settings sections on initial load', (tester) async {
      await tester.pumpWidget(buildSubject());
      await tester.pumpAndSettle();

      // The locale badge shows the current language code.
      expect(find.text('EN'), findsOneWidget);

      // Notifications switch is present.
      expect(find.byType(Switch), findsOneWidget);
    });

    testWidgets('notifications switch reflects ViewModel state', (
      tester,
    ) async {
      when(() => mockViewModel.notificationsEnabled).thenReturn(false);

      await tester.pumpWidget(buildSubject());
      await tester.pumpAndSettle();

      final switchWidget = tester.widget<Switch>(find.byType(Switch));
      expect(switchWidget.value, isFalse);
    });

    testWidgets('tapping notifications switch calls toggleNotifications', (
      tester,
    ) async {
      when(
        () => mockViewModel.toggleNotifications(any()),
      ).thenAnswer((_) async {});

      await tester.pumpWidget(buildSubject());
      await tester.pumpAndSettle();

      await tester.tap(find.byType(Switch));
      await tester.pump();

      verify(() => mockViewModel.toggleNotifications(false)).called(1);
    });
  });
}
