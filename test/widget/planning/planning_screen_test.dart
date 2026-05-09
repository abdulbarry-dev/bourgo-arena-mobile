import 'package:bourgo_arena_mobile/l10n/app_localizations.dart';
import 'package:bourgo_arena_mobile/presentation/planning/planning_screen.dart';
import 'package:bourgo_arena_mobile/presentation/planning/planning_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockPlanningViewModel extends Mock implements PlanningViewModel {}

void main() {
  late MockPlanningViewModel mockViewModel;

  setUp(() {
    mockViewModel = MockPlanningViewModel();
    when(() => mockViewModel.isLoading).thenReturn(false);
    when(() => mockViewModel.courses).thenReturn([]);
    when(() => mockViewModel.selectedDay).thenReturn(1);
    when(() => mockViewModel.selectedCategory).thenReturn('All');
    when(() => mockViewModel.addListener(any())).thenReturn(null);
    when(() => mockViewModel.removeListener(any())).thenReturn(null);
  });

  Widget createWidget() {
    return MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: PlanningScreen(viewModel: mockViewModel),
    );
  }

  testWidgets('renders day selector and empty state', (tester) async {
    await tester.pumpWidget(createWidget());
    await tester.pumpAndSettle();

    final context = tester.element(find.byType(PlanningScreen));
    final l10n = AppLocalizations.of(context)!;

    // Day names should be present (e.g., Mon)
    expect(find.text(l10n.commonMon), findsWidgets);
    expect(find.text(l10n.planningNoCourses), findsOneWidget);
  });

  testWidgets('tapping day calls selectDay', (tester) async {
    when(() => mockViewModel.selectDay(any())).thenReturn(null);

    await tester.pumpWidget(createWidget());
    await tester.pumpAndSettle();

    final context = tester.element(find.byType(PlanningScreen));
    final l10n = AppLocalizations.of(context)!;
    final mon = find.text(l10n.commonMon).first;
    await tester.tap(mon);
    await tester.pump();

    verify(() => mockViewModel.selectDay(1)).called(1);
  });
}
