import 'package:bourgo_arena_mobile/domain/entities/auth_state.dart';
import 'package:bourgo_arena_mobile/core/theme/bourgo_theme.dart';
import 'package:bourgo_arena_mobile/presentation/auth/auth_state_notifier.dart';
import 'package:bourgo_arena_mobile/core/di/locator.dart';
import 'package:bourgo_arena_mobile/domain/entities/course.dart';
import 'package:bourgo_arena_mobile/l10n/app_localizations.dart';
import 'package:bourgo_arena_mobile/presentation/planning/planning_screen.dart';
import 'package:bourgo_arena_mobile/presentation/planning/planning_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:checks/checks.dart';
import 'package:shimmer/shimmer.dart';

class MockPlanningViewModel extends Mock implements PlanningViewModel {}

class MockAuthStateNotifier extends Mock implements AuthStateNotifier {}

void main() {
  late MockPlanningViewModel mockViewModel;

  setUp(() {
    final mockAuthStateNotifier = MockAuthStateNotifier();
    if (!locator.isRegistered<AuthStateNotifier>()) {
      locator.registerSingleton<AuthStateNotifier>(mockAuthStateNotifier);
    }
    when(() => mockAuthStateNotifier.state).thenReturn(AuthState.authenticated);
    when(() => mockAuthStateNotifier.isAuthenticated).thenReturn(true);
    mockViewModel = MockPlanningViewModel();
    when(() => mockViewModel.isAuthenticated).thenReturn(true);
    when(() => mockViewModel.hasActivePlan).thenReturn(true);
    when(() => mockViewModel.isLoading).thenReturn(false);
    when(() => mockViewModel.isSubscriptionGate).thenReturn(false);
    when(() => mockViewModel.errorMessage).thenReturn(null);
    when(() => mockViewModel.courses).thenReturn([]);
    when(() => mockViewModel.allSessions).thenReturn([]);
    when(() => mockViewModel.hasSessions).thenReturn(false);
    when(() => mockViewModel.availableDays).thenReturn([]);
    when(() => mockViewModel.sessionsByDay).thenReturn({});
    when(() => mockViewModel.familyMembers).thenReturn([]);
    when(() => mockViewModel.selectedMember).thenReturn(null);
    when(() => mockViewModel.loadPlanning()).thenAnswer((_) async {});
    when(() => mockViewModel.addListener(any())).thenReturn(null);
    when(() => mockViewModel.removeListener(any())).thenReturn(null);
  });

  Widget createWidget() {
    return MaterialApp(
      theme: BourgoTheme.lightTheme,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: PlanningScreen(viewModel: mockViewModel),
    );
  }

  testWidgets('renders empty state when no courses', (tester) async {
    await tester.pumpWidget(createWidget());
    await tester.pumpAndSettle();

    check(find.text('AUCUNE SÉANCE').evaluate()).isNotEmpty();
  });

  testWidgets('shows loading indicator when isLoading is true', (tester) async {
    when(() => mockViewModel.isLoading).thenReturn(true);
    await tester.pumpWidget(createWidget());

    check(find.byType(Shimmer).evaluate()).isNotEmpty();
  });

  testWidgets('shows error message when errorMessage is present', (
    tester,
  ) async {
    when(() => mockViewModel.errorMessage).thenReturn('Failed to load');
    await tester.pumpWidget(createWidget());

    check(find.text('ERREUR DE PLANNING').evaluate()).isNotEmpty();
  });

  testWidgets('renders list of courses when data is loaded', (tester) async {
    final courses = [
      const Course(
        id: '1',
        name: 'Morning Yoga',
        description: 'Start your day right',
        images: [],
        status: 'active',
      ),
    ];
    final sessions = [
      PlanningEntry(
        id: '1',
        title: 'Morning Yoga',
        source: courses.first,
        courseId: '1',
        dayOfWeek: 1,
        startTime: '08:00',
        endTime: '09:00',
        capacity: 20,
        enrolled: 5,
        isFull: false,
      ),
    ];
    when(() => mockViewModel.allSessions).thenReturn(sessions);
    when(() => mockViewModel.hasSessions).thenReturn(true);
    when(() => mockViewModel.availableDays).thenReturn([1]);
    when(() => mockViewModel.sessionsByDay).thenReturn({1: sessions});

    await tester.pumpWidget(createWidget());
    await tester.pump(const Duration(seconds: 2));

    check(find.text('LUNDI').evaluate()).isNotEmpty();
    check(find.text('MORNING YOGA').evaluate()).isNotEmpty();
  });
}
