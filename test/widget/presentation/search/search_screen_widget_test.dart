import 'package:bourgo_arena_mobile/domain/entities/search_result.dart';
import 'package:bourgo_arena_mobile/l10n/app_localizations.dart';
import 'package:bourgo_arena_mobile/presentation/search/search_screen.dart';
import 'package:bourgo_arena_mobile/presentation/search/search_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';

class _MockSearchViewModel extends Mock implements SearchViewModel {}

void main() {
  late _MockSearchViewModel mockViewModel;

  const testResult = SearchResult(
    title: 'Yoga Basics',
    subtitle: 'Wellness',
    type: SearchResultType.activity,
    iconKey: 'sports_soccer',
    route: '/booking',
  );

  setUp(() {
    mockViewModel = _MockSearchViewModel();

    // ListenableBuilder stubs.
    when(() => mockViewModel.addListener(any())).thenReturn(null);
    when(() => mockViewModel.removeListener(any())).thenReturn(null);
    when(() => mockViewModel.dispose()).thenReturn(null);

    // Default state.
    when(() => mockViewModel.query).thenReturn('');
    when(() => mockViewModel.isSearching).thenReturn(false);
    when(() => mockViewModel.results).thenReturn([]);
  });

  Widget buildSubject() {
    final router = GoRouter(
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => SearchScreen(viewModel: mockViewModel),
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

  group('SearchScreen widget tests', () {
    testWidgets('renders search field on initial load', (tester) async {
      await tester.pumpWidget(buildSubject());
      await tester.pumpAndSettle();

      expect(find.byType(TextField), findsOneWidget);

      FocusManager.instance.primaryFocus?.unfocus();
      await tester.pumpAndSettle();
    });

    testWidgets('shows results after search is performed', (tester) async {
      when(() => mockViewModel.results).thenReturn([testResult]);
      // _buildContent checks query.isEmpty before rendering results.
      when(() => mockViewModel.query).thenReturn('yoga');

      await tester.pumpWidget(buildSubject());
      await tester.pumpAndSettle();

      expect(find.text('Yoga Basics'), findsOneWidget);

      FocusManager.instance.primaryFocus?.unfocus();
      await tester.pumpAndSettle();
    });

    testWidgets('typing in search field calls search on ViewModel', (
      tester,
    ) async {
      when(() => mockViewModel.search(any())).thenAnswer((_) async {});

      await tester.pumpWidget(buildSubject());
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField), 'yoga');
      await tester.pumpAndSettle();

      verify(() => mockViewModel.search('yoga')).called(1);

      FocusManager.instance.primaryFocus?.unfocus();
      await tester.pumpAndSettle();
    });
  });
}
