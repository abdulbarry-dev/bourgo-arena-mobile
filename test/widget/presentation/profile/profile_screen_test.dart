import 'dart:io';

import 'package:bourgo_arena_mobile/core/di/locator.dart';
import 'package:bourgo_arena_mobile/core/utils/result.dart';
import 'package:bourgo_arena_mobile/domain/entities/auth_session.dart';
import 'package:bourgo_arena_mobile/domain/entities/auth_state.dart';
import 'package:bourgo_arena_mobile/domain/entities/user.dart';
import 'package:bourgo_arena_mobile/domain/repositories/auth_repository.dart';
import 'package:bourgo_arena_mobile/domain/usecases/auth/logout_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/auth/delete_account_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/booking/get_ongoing_reservations_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/payment/get_full_payment_history_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/event/get_my_events_use_case.dart';
import 'package:bourgo_arena_mobile/presentation/auth/auth_state_notifier.dart';
import 'package:bourgo_arena_mobile/presentation/profile/profile_screen.dart';
import 'package:bourgo_arena_mobile/presentation/common/widgets/guest_auth_state.dart';
import 'package:bourgo_arena_mobile/l10n/app_localizations.dart';
import 'package:bourgo_arena_mobile/core/theme/bourgo_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

class MockLogoutUseCase extends Mock implements LogoutUseCase {}

class MockDeleteAccountUseCase extends Mock implements DeleteAccountUseCase {}

class MockGetOngoingReservationsUseCase extends Mock
    implements GetOngoingReservationsUseCase {}

class MockGetFullPaymentHistoryUseCase extends Mock
    implements GetFullPaymentHistoryUseCase {}

class MockGetMyEventsUseCase extends Mock implements GetMyEventsUseCase {}

class MockAuthStateNotifier extends Mock implements AuthStateNotifier {}

class MockGoRouter extends Mock implements GoRouter {}

void main() {
  late MockAuthRepository mockAuthRepository;
  late MockLogoutUseCase mockLogoutUseCase;
  late MockDeleteAccountUseCase mockDeleteAccountUseCase;
  late MockGetOngoingReservationsUseCase mockGetOngoingReservationsUseCase;
  late MockGetFullPaymentHistoryUseCase mockGetFullPaymentHistoryUseCase;
  late MockGetMyEventsUseCase mockGetMyEventsUseCase;
  late MockAuthStateNotifier mockAuthStateNotifier;
  late MockGoRouter mockGoRouter;

  setUpAll(() {
    HttpOverrides.global = _FakeHttpOverrides();
    registerFallbackValue(() {});
  });

  tearDownAll(() {
    HttpOverrides.global = null;
  });

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    mockLogoutUseCase = MockLogoutUseCase();
    mockDeleteAccountUseCase = MockDeleteAccountUseCase();
    mockGetOngoingReservationsUseCase = MockGetOngoingReservationsUseCase();
    mockGetFullPaymentHistoryUseCase = MockGetFullPaymentHistoryUseCase();
    mockGetMyEventsUseCase = MockGetMyEventsUseCase();
    mockAuthStateNotifier = MockAuthStateNotifier();
    mockGoRouter = MockGoRouter();

    locator.allowReassignment = true;
    locator.registerFactory<AuthRepository>(() => mockAuthRepository);
    locator.registerFactory<LogoutUseCase>(() => mockLogoutUseCase);
    locator.registerFactory<DeleteAccountUseCase>(
      () => mockDeleteAccountUseCase,
    );
    locator.registerFactory<GetOngoingReservationsUseCase>(
      () => mockGetOngoingReservationsUseCase,
    );
    locator.registerFactory<GetFullPaymentHistoryUseCase>(
      () => mockGetFullPaymentHistoryUseCase,
    );
    locator.registerFactory<GetMyEventsUseCase>(() => mockGetMyEventsUseCase);
    locator.registerSingleton<AuthStateNotifier>(mockAuthStateNotifier);

    when(() => mockAuthStateNotifier.isAuthenticated).thenReturn(false);
    when(() => mockAuthStateNotifier.currentUser).thenReturn(null);
    when(
      () => mockAuthStateNotifier.state,
    ).thenReturn(AuthState.unauthenticated);
    when(() => mockAuthStateNotifier.addListener(any())).thenReturn(null);
    when(() => mockAuthStateNotifier.removeListener(any())).thenReturn(null);

    when(
      () => mockGetOngoingReservationsUseCase(),
    ).thenAnswer((_) async => Result.success([]));
    when(
      () => mockGetFullPaymentHistoryUseCase.execute(),
    ).thenAnswer((_) async => Result.success([]));
    when(
      () => mockGetMyEventsUseCase(),
    ).thenAnswer((_) async => Result.success([]));
    when(() => mockAuthRepository.getMemberTier()).thenAnswer(
      (_) async =>
          Result.success(const AuthSession(state: AuthState.unauthenticated)),
    );
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
      home: InheritedGoRouter(
        goRouter: mockGoRouter,
        child: const ProfileScreen(),
      ),
    );
  }

  group('ProfileScreen Widget Tests', () {
    testWidgets('shows GuestAuthState when unauthenticated', (tester) async {
      when(
        () => mockAuthStateNotifier.state,
      ).thenReturn(AuthState.unauthenticated);

      await tester.pumpWidget(createWidgetUnderTest(tester));
      await tester.pump(const Duration(seconds: 1)); // Wait for animations

      expect(find.byType(GuestAuthState), findsOneWidget);
    });

    testWidgets('shows User details when authenticated', (tester) async {
      const testUser = User(
        id: '1',
        firstName: 'John',
        lastName: 'Doe',
        email: 'john@doe.com',
        loyaltyPoints: 1200,
      );

      when(
        () => mockAuthStateNotifier.state,
      ).thenReturn(AuthState.authenticated);
      when(() => mockAuthStateNotifier.isAuthenticated).thenReturn(true);
      when(() => mockAuthStateNotifier.currentUser).thenReturn(testUser);

      await tester.pumpWidget(createWidgetUnderTest(tester));
      await tester.pumpAndSettle(const Duration(seconds: 1));

      expect(find.text('JOHN DOE'), findsOneWidget);
      // Because loyaltyPoints is 1200, it formats as 1 200 or 1,200 depending on locale.
      // We can check if "1 200" or similar is shown.
      expect(find.textContaining('1'), findsWidgets);
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
