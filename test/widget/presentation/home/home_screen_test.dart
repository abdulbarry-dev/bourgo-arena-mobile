import 'dart:io';

import 'package:bourgo_arena_mobile/core/utils/result.dart';
import 'package:bourgo_arena_mobile/core/theme/bourgo_theme.dart';

import 'package:bourgo_arena_mobile/core/di/locator.dart';
import 'package:bourgo_arena_mobile/domain/usecases/activity/get_activities_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/course/get_courses_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/event/event_use_cases.dart';
import 'package:bourgo_arena_mobile/domain/usecases/service/get_services_use_case.dart';
import 'package:bourgo_arena_mobile/l10n/app_localizations.dart';
import 'package:bourgo_arena_mobile/presentation/home/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';

class MockGetActivitiesUseCase extends Mock implements GetActivitiesUseCase {}

class MockGetCoursesUseCase extends Mock implements GetCoursesUseCase {}

class MockGetEventsUseCase extends Mock implements GetEventsUseCase {}

class MockGetServicesUseCase extends Mock implements GetServicesUseCase {}

class MockGoRouter extends Mock implements GoRouter {}

void main() {
  late MockGetActivitiesUseCase mockGetActivitiesUseCase;
  late MockGetCoursesUseCase mockGetCoursesUseCase;
  late MockGetEventsUseCase mockGetEventsUseCase;
  late MockGetServicesUseCase mockGetServicesUseCase;
  late MockGoRouter mockGoRouter;

  setUpAll(() {
    HttpOverrides.global = _FakeHttpOverrides();
  });

  tearDownAll(() {
    HttpOverrides.global = null;
  });

  setUp(() {
    mockGetActivitiesUseCase = MockGetActivitiesUseCase();
    mockGetCoursesUseCase = MockGetCoursesUseCase();
    mockGetEventsUseCase = MockGetEventsUseCase();
    mockGetServicesUseCase = MockGetServicesUseCase();
    mockGoRouter = MockGoRouter();

    locator.allowReassignment = true;
    locator.registerFactory<GetActivitiesUseCase>(
      () => mockGetActivitiesUseCase,
    );
    locator.registerFactory<GetCoursesUseCase>(() => mockGetCoursesUseCase);
    locator.registerFactory<GetEventsUseCase>(() => mockGetEventsUseCase);
    locator.registerFactory<GetServicesUseCase>(() => mockGetServicesUseCase);

    when(
      () => mockGetActivitiesUseCase.call(),
    ).thenAnswer((_) async => const Success([]));
    when(
      () => mockGetCoursesUseCase.call(),
    ).thenAnswer((_) async => const Success([]));
    when(
      () => mockGetEventsUseCase.call(),
    ).thenAnswer((_) async => const Success([]));
    when(
      () => mockGetServicesUseCase.call(),
    ).thenAnswer((_) async => const Success([]));
  });

  tearDown(() {
    locator.reset();
  });

  Widget createWidgetUnderTest() {
    return MaterialApp(
      theme: BourgoTheme.lightTheme,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('en'), Locale('fr')],
      home: InheritedGoRouter(
        goRouter: mockGoRouter,
        child: const HomeScreen(),
      ),
    );
  }

  group('HomeScreen Widget Tests', () {
    testWidgets('shows loading state initially', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      // pump once to trigger init state
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('shows empty state when no data is returned', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester
          .pumpAndSettle(); // Wait for futures to resolve and animations

      expect(find.text('No results found'), findsOneWidget);
    });
  });
}

class _FakeHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) => _FakeHttpClient();
}

class _FakeHttpClient extends Fake implements HttpClient {
  @override
  bool autoUncompress = true;
}
