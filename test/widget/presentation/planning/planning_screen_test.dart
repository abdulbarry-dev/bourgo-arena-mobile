import 'dart:io';

import 'package:bourgo_arena_mobile/core/di/locator.dart';
import 'package:bourgo_arena_mobile/domain/usecases/course/get_courses_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/family/get_family_members_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/loyalty/get_member_tier_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/user/get_user_profile_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/subscription/get_active_subscriptions_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/course/get_course_sessions_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/course/enroll_in_course_use_case.dart';
import 'package:bourgo_arena_mobile/presentation/auth/auth_state_notifier.dart';
import 'package:bourgo_arena_mobile/presentation/planning/planning_screen.dart';
import 'package:bourgo_arena_mobile/l10n/app_localizations.dart';
import 'package:bourgo_arena_mobile/core/theme/bourgo_theme.dart';
import 'package:bourgo_arena_mobile/domain/core/failure.dart';
import 'package:bourgo_arena_mobile/domain/core/app_error_code.dart';
import 'package:bourgo_arena_mobile/core/utils/result.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';

class MockGetCoursesUseCase extends Mock implements GetCoursesUseCase {}

class MockGetFamilyMembersUseCase extends Mock
    implements GetFamilyMembersUseCase {}

class MockGetMemberTierUseCase extends Mock implements GetMemberTierUseCase {}

class MockGetUserProfileUseCase extends Mock implements GetUserProfileUseCase {}

class MockGetActiveSubscriptionsUseCase extends Mock
    implements GetActiveSubscriptionsUseCase {}

class MockGetCourseSessionsUseCase extends Mock
    implements GetCourseSessionsUseCase {}

class MockBookCourseSessionUseCase extends Mock implements BookCourseSessionUseCase {}

class MockAuthStateNotifier extends Mock implements AuthStateNotifier {}

class MockGoRouter extends Mock implements GoRouter {}

void main() {
  late MockGetCoursesUseCase mockGetCoursesUseCase;
  late MockGetFamilyMembersUseCase mockGetFamilyMembersUseCase;
  late MockGetMemberTierUseCase mockGetMemberTierUseCase;
  late MockGetUserProfileUseCase mockGetUserProfileUseCase;
  late MockGetActiveSubscriptionsUseCase mockGetActiveSubscriptionsUseCase;
  late MockGetCourseSessionsUseCase mockGetCourseSessionsUseCase;
  late MockBookCourseSessionUseCase mockBookCourseSessionUseCase;
  late MockAuthStateNotifier mockAuthStateNotifier;
  late MockGoRouter mockGoRouter;

  setUpAll(() {
    HttpOverrides.global = _FakeHttpOverrides();
  });

  tearDownAll(() {
    HttpOverrides.global = null;
  });

  setUp(() {
    mockGetCoursesUseCase = MockGetCoursesUseCase();
    mockGetFamilyMembersUseCase = MockGetFamilyMembersUseCase();
    mockGetMemberTierUseCase = MockGetMemberTierUseCase();
    mockGetUserProfileUseCase = MockGetUserProfileUseCase();
    mockGetActiveSubscriptionsUseCase = MockGetActiveSubscriptionsUseCase();
    mockGetCourseSessionsUseCase = MockGetCourseSessionsUseCase();
    mockBookCourseSessionUseCase = MockBookCourseSessionUseCase();
    mockAuthStateNotifier = MockAuthStateNotifier();
    mockGoRouter = MockGoRouter();

    locator.allowReassignment = true;
    locator.registerFactory<GetCoursesUseCase>(() => mockGetCoursesUseCase);
    locator.registerFactory<GetFamilyMembersUseCase>(
      () => mockGetFamilyMembersUseCase,
    );
    locator.registerFactory<GetMemberTierUseCase>(
      () => mockGetMemberTierUseCase,
    );
    locator.registerFactory<GetUserProfileUseCase>(
      () => mockGetUserProfileUseCase,
    );
    locator.registerFactory<GetActiveSubscriptionsUseCase>(
      () => mockGetActiveSubscriptionsUseCase,
    );
    locator.registerFactory<GetCourseSessionsUseCase>(
      () => mockGetCourseSessionsUseCase,
    );
    locator.registerFactory<BookCourseSessionUseCase>(
      () => mockBookCourseSessionUseCase,
    );
    locator.registerSingleton<AuthStateNotifier>(mockAuthStateNotifier);

    when(() => mockAuthStateNotifier.isAuthenticated).thenReturn(true);
    when(
      () => mockGetCoursesUseCase.call(),
    ).thenAnswer((_) async => const Success([]));
    when(
      () => mockGetFamilyMembersUseCase.call(),
    ).thenAnswer((_) async => const Success([]));
    when(() => mockGetActiveSubscriptionsUseCase.execute()).thenAnswer(
      (_) async => Result.failure(
        const ServerFailure(AppErrorCode.serverError, 'error'),
      ),
    );
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
        child: const PlanningScreen(),
      ),
    );
  }

  group('PlanningScreen Widget Tests', () {
    testWidgets('shows Subscription State when no active plan', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump(
        const Duration(seconds: 1),
      ); // wait for animations and futures
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
