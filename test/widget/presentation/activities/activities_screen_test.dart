import 'dart:io';

import 'package:bourgo_arena_mobile/core/di/locator.dart';
import 'package:bourgo_arena_mobile/domain/usecases/course/get_courses_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/booking/get_user_bookings_use_case.dart';
import 'package:bourgo_arena_mobile/presentation/activities/activities_screen.dart';
import 'package:bourgo_arena_mobile/presentation/auth/auth_state_notifier.dart';
import 'package:bourgo_arena_mobile/presentation/common/empty_state.dart';
import 'package:bourgo_arena_mobile/presentation/common/widgets/guest_auth_state.dart';
import 'package:bourgo_arena_mobile/l10n/app_localizations.dart';
import 'package:bourgo_arena_mobile/core/theme/bourgo_theme.dart';
import 'package:bourgo_arena_mobile/core/utils/result.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockGetCoursesUseCase extends Mock implements GetCoursesUseCase {}

class MockGetUserBookingsUseCase extends Mock
    implements GetUserBookingsUseCase {}

class MockAuthStateNotifier extends Mock implements AuthStateNotifier {}

void main() {
  late MockGetCoursesUseCase mockGetCoursesUseCase;
  late MockGetUserBookingsUseCase mockGetUserBookingsUseCase;
  late MockAuthStateNotifier mockAuthStateNotifier;

  setUpAll(() {
    HttpOverrides.global = _FakeHttpOverrides();
  });

  tearDownAll(() {
    HttpOverrides.global = null;
  });

  setUp(() {
    mockGetCoursesUseCase = MockGetCoursesUseCase();
    mockGetUserBookingsUseCase = MockGetUserBookingsUseCase();
    mockAuthStateNotifier = MockAuthStateNotifier();

    locator.allowReassignment = true;
    locator.registerFactory<GetCoursesUseCase>(() => mockGetCoursesUseCase);
    locator.registerFactory<GetUserBookingsUseCase>(
      () => mockGetUserBookingsUseCase,
    );
    locator.registerSingleton<AuthStateNotifier>(mockAuthStateNotifier);

    when(() => mockAuthStateNotifier.isAuthenticated).thenReturn(false);
    when(
      () => mockGetCoursesUseCase.call(),
    ).thenAnswer((_) async => Result.success([]));
    when(
      () => mockGetUserBookingsUseCase.call(),
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
      home: const ActivitiesScreen(),
    );
  }

  group('ActivitiesScreen Widget Tests', () {
    testWidgets(
      'shows EmptyState for courses and GuestAuthState for reservations when unauthenticated',
      (tester) async {
        when(() => mockAuthStateNotifier.isAuthenticated).thenReturn(false);

        await tester.pumpWidget(createWidgetUnderTest(tester));
        await tester.pump(
          const Duration(seconds: 1),
        ); // Wait for futures and animations

        // Initial tab is Explorer (Courses). Because it's empty, we should see EmptyState.
        expect(find.byType(EmptyState), findsOneWidget);

        // Tap on Reservations tab
        await tester.tap(find.text('My Reservations'));
        await tester.pumpAndSettle();

        // Because unauthenticated, we should see GuestAuthState.
        expect(find.byType(GuestAuthState), findsOneWidget);
      },
    );

    testWidgets(
      'shows EmptyState for reservations when authenticated but no reservations exist',
      (tester) async {
        when(() => mockAuthStateNotifier.isAuthenticated).thenReturn(true);

        await tester.pumpWidget(createWidgetUnderTest());
        await tester.pump(const Duration(seconds: 1));

        // Tap on Reservations tab
        await tester.tap(find.text('My Reservations'));
        await tester.pumpAndSettle();

        // Because authenticated but no reservations, we should see EmptyState.
        expect(find.byType(EmptyState), findsOneWidget);
      },
    );
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
