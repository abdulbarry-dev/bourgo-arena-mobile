import 'package:bourgo_arena_mobile/l10n/app_localizations.dart';
import 'package:bourgo_arena_mobile/presentation/search/search_screen.dart';
import 'package:bourgo_arena_mobile/presentation/search/search_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockSearchViewModel extends Mock implements SearchViewModel {}

void main() {
  late MockSearchViewModel mockViewModel;

  setUp(() {
    mockViewModel = MockSearchViewModel();
    when(() => mockViewModel.addListener(any())).thenReturn(null);
    when(() => mockViewModel.removeListener(any())).thenReturn(null);
    when(() => mockViewModel.query).thenReturn('');
    when(() => mockViewModel.isSearching).thenReturn(false);
    when(() => mockViewModel.results).thenReturn([]);
  });

  Widget createWidget() {
    return MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: SearchScreen(viewModel: mockViewModel),
    );
  }

  testWidgets('typing into search calls viewModel.search', (tester) async {
    when(() => mockViewModel.search(any())).thenAnswer((_) async {});

    await tester.pumpWidget(createWidget());
    await tester.pumpAndSettle();

    final field = find.byType(TextField);
    expect(field, findsOneWidget);

    await tester.enterText(field, 'Yo');
    await tester.pump();

    verify(() => mockViewModel.search('Yo')).called(1);
  });

  testWidgets('shows no results placeholder when query set and empty results', (
    tester,
  ) async {
    when(() => mockViewModel.query).thenReturn('abc');
    when(() => mockViewModel.isSearching).thenReturn(false);
    when(() => mockViewModel.results).thenReturn([]);

    await tester.pumpWidget(createWidget());
    await tester.pumpAndSettle();

    expect(find.textContaining('No results'), findsOneWidget);
  });
}
