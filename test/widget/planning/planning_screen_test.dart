import 'package:bourgo_arena_mobile/domain/entities/course.dart';
import 'package:bourgo_arena_mobile/l10n/app_localizations.dart';
import 'package:bourgo_arena_mobile/presentation/planning/planning_screen.dart';
import 'package:bourgo_arena_mobile/presentation/planning/planning_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:checks/checks.dart';

class MockPlanningViewModel extends Mock implements PlanningViewModel {}

void main() {
  late MockPlanningViewModel mockViewModel;

  setUp(() {
    mockViewModel = MockPlanningViewModel();
    when(() => mockViewModel.isLoading).thenReturn(false);
    when(() => mockViewModel.errorMessage).thenReturn(null);
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
    check(find.text(l10n.commonMon).evaluate()).isNotEmpty();
    check(find.text(l10n.planningNoCourses).evaluate()).length.equals(1);
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

  testWidgets('shows loading indicator when isLoading is true', (tester) async {
    when(() => mockViewModel.isLoading).thenReturn(true);
    await tester.pumpWidget(createWidget());

    check(find.byType(CircularProgressIndicator).evaluate()).isNotEmpty();
  });

  testWidgets('shows error message when errorMessage is present', (
    tester,
  ) async {
    when(() => mockViewModel.errorMessage).thenReturn('Failed to load');
    await tester.pumpWidget(createWidget());

    check(find.text('Failed to load').evaluate()).isNotEmpty();
  });

  testWidgets('renders list of courses when data is loaded', (tester) async {
    final courses = [
      const Course(
        id: '1',
        title: 'Morning Yoga',
        instructor: 'Alice',
        startTime: '08:00',
        endTime: '09:00',
        dayOfWeek: 1,
        category: 'Wellness',
        capacity: 20,
        enrolled: 5,
        icon: 'yoga',
      ),
    ];
    when(() => mockViewModel.courses).thenReturn(courses);

    await tester.pumpWidget(createWidget());
    await tester.pumpAndSettle();

    check(find.text('MORNING YOGA').evaluate()).isNotEmpty();
    check(find.text('Alice').evaluate()).isNotEmpty();
  });
}
