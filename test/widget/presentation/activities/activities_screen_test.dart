import 'dart:io';

import 'package:bourgo_arena_mobile/core/di/locator.dart';
import 'package:bourgo_arena_mobile/domain/usecases/course/get_courses_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/activity/get_activities_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/event/event_use_cases.dart';
import 'package:bourgo_arena_mobile/presentation/browse/browse_screen.dart';
import 'package:bourgo_arena_mobile/l10n/app_localizations.dart';
import 'package:bourgo_arena_mobile/core/theme/bourgo_theme.dart';
import 'package:bourgo_arena_mobile/core/utils/result.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockGetCoursesUseCase extends Mock implements GetCoursesUseCase {}

class MockGetActivitiesUseCase extends Mock implements GetActivitiesUseCase {}

class MockGetEventsUseCase extends Mock implements GetEventsUseCase {}

void main() {
  late MockGetCoursesUseCase mockGetCoursesUseCase;
  late MockGetActivitiesUseCase mockGetActivitiesUseCase;
  late MockGetEventsUseCase mockGetEventsUseCase;

  setUpAll(() {
    HttpOverrides.global = _FakeHttpOverrides();
  });

  tearDownAll(() {
    HttpOverrides.global = null;
  });

  setUp(() {
    mockGetCoursesUseCase = MockGetCoursesUseCase();
    mockGetActivitiesUseCase = MockGetActivitiesUseCase();
    mockGetEventsUseCase = MockGetEventsUseCase();

    locator.allowReassignment = true;
    locator.registerFactory<GetCoursesUseCase>(() => mockGetCoursesUseCase);
    locator.registerFactory<GetActivitiesUseCase>(
      () => mockGetActivitiesUseCase,
    );
    locator.registerFactory<GetEventsUseCase>(() => mockGetEventsUseCase);

    when(
      () => mockGetCoursesUseCase.call(),
    ).thenAnswer((_) async => Result.success([]));
    when(
      () => mockGetActivitiesUseCase.call(),
    ).thenAnswer((_) async => Result.success([]));
    when(
      () => mockGetEventsUseCase.call(),
    ).thenAnswer((_) async => Result.success([]));
  });

  tearDown(() {
    locator.reset();
  });

  Widget createWidgetUnderTest(WidgetTester tester) {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    return MaterialApp(
      theme: BourgoTheme.lightTheme,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('en'), Locale('fr')],
      home: const BrowseScreen(),
    );
  }

  group('BrowseScreen Widget Tests', () {
    testWidgets('shows tab bar with all three tabs', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest(tester));
      await tester.pump(const Duration(seconds: 1));

      expect(find.text('COURSES'), findsOneWidget);
      expect(find.text('ACTIVITIES'), findsOneWidget);
      expect(find.text('EVENTS'), findsOneWidget);
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
