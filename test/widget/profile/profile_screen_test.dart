import 'dart:async';
import 'dart:io';
import 'package:bourgo_arena_mobile/core/di/locator.dart';
import 'package:bourgo_arena_mobile/core/utils/result.dart';
import 'package:bourgo_arena_mobile/domain/core/failure.dart';
import 'package:bourgo_arena_mobile/domain/entities/user.dart';
import 'package:bourgo_arena_mobile/domain/usecases/auth/logout_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/user/get_user_profile_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/user/update_user_profile_use_case.dart';
import 'package:bourgo_arena_mobile/l10n/app_localizations.dart';
import 'package:bourgo_arena_mobile/core/theme/bourgo_theme.dart';
import 'package:bourgo_arena_mobile/presentation/profile/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mocktail/mocktail.dart';

class MockGetUserProfileUseCase extends Mock implements GetUserProfileUseCase {}

class MockUpdateUserProfileUseCase extends Mock
    implements UpdateUserProfileUseCase {}

class MockLogoutUseCase extends Mock implements LogoutUseCase {}

class MockHttpClient extends Mock implements HttpClient {}

class MockHttpClientRequest extends Mock implements HttpClientRequest {}

class MockHttpClientResponse extends Mock implements HttpClientResponse {}

class MockHttpHeaders extends Mock implements HttpHeaders {}

final List<int> _transparentPixel = [
  0x89,
  0x50,
  0x4E,
  0x47,
  0x0D,
  0x0A,
  0x1A,
  0x0A,
  0x00,
  0x00,
  0x00,
  0x0D,
  0x49,
  0x48,
  0x44,
  0x52,
  0x00,
  0x00,
  0x00,
  0x01,
  0x00,
  0x00,
  0x00,
  0x01,
  0x08,
  0x06,
  0x00,
  0x00,
  0x00,
  0x1F,
  0x15,
  0xC4,
  0x89,
  0x00,
  0x00,
  0x00,
  0x0A,
  0x49,
  0x44,
  0x41,
  0x54,
  0x78,
  0x9C,
  0x63,
  0x00,
  0x01,
  0x00,
  0x00,
  0x05,
  0x00,
  0x01,
  0x0D,
  0x0A,
  0x2D,
  0xB4,
  0x00,
  0x00,
  0x00,
  0x00,
  0x49,
  0x45,
  0x4E,
  0x44,
  0xAE,
  0x42,
  0x60,
  0x82,
];

void main() {
  setUpAll(() {
    GoogleFonts.config.allowRuntimeFetching = false;

    final mockHttpClient = MockHttpClient();
    final mockRequest = MockHttpClientRequest();
    final mockResponse = MockHttpClientResponse();
    final mockHeaders = MockHttpHeaders();

    registerFallbackValue(Uri.parse('https://example.com'));

    when(
      () => mockHttpClient.getUrl(any()),
    ).thenAnswer((_) async => mockRequest);
    when(() => mockRequest.headers).thenReturn(mockHeaders);
    when(() => mockRequest.close()).thenAnswer((_) async => mockResponse);
    when(() => mockResponse.statusCode).thenReturn(HttpStatus.ok);
    when(() => mockResponse.contentLength).thenReturn(_transparentPixel.length);
    when(
      () => mockResponse.compressionState,
    ).thenReturn(HttpClientResponseCompressionState.notCompressed);
    when(
      () => mockResponse.listen(
        any(),
        cancelOnError: any(named: 'cancelOnError'),
        onDone: any(named: 'onDone'),
        onError: any(named: 'onError'),
      ),
    ).thenAnswer((invocation) {
      final onData =
          invocation.positionalArguments[0] as void Function(List<int>);
      final onDone = invocation.namedArguments[#onDone] as void Function()?;
      onData(_transparentPixel);
      onDone?.call();
      return MockStreamSubscription<List<int>>();
    });

    HttpOverrides.global = _MockHttpOverrides(mockHttpClient);
  });

  late MockGetUserProfileUseCase mockGetUserProfileUseCase;
  late MockUpdateUserProfileUseCase mockUpdateUserProfileUseCase;
  late MockLogoutUseCase mockLogoutUseCase;

  final testUser = User(
    id: 'user-1',
    firstName: 'John',
    lastName: 'Doe',
    email: 'john@example.com',
    phone: '123456789',
    avatarUrl: 'https://example.com/avatar.png',
    loyaltyPoints: 100,
    subscriptionLevel: 'Gold',
    subscriptionExpiry: '2026-12-31',
    totalCheckIns: 42,
  );

  setUp(() {
    mockGetUserProfileUseCase = MockGetUserProfileUseCase();
    mockUpdateUserProfileUseCase = MockUpdateUserProfileUseCase();
    mockLogoutUseCase = MockLogoutUseCase();

    locator.registerSingleton<GetUserProfileUseCase>(mockGetUserProfileUseCase);
    locator.registerSingleton<UpdateUserProfileUseCase>(
      mockUpdateUserProfileUseCase,
    );
    locator.registerSingleton<LogoutUseCase>(mockLogoutUseCase);
  });

  tearDown(() {
    locator.reset();
  });

  Widget createWidget() {
    final router = GoRouter(
      routes: [
        GoRoute(path: '/', builder: (context, state) => const ProfileScreen()),
        GoRoute(
          path: '/login',
          builder: (context, state) => const Scaffold(body: Text('Login Page')),
        ),
      ],
    );

    return MaterialApp.router(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      theme: BourgoTheme.lightTheme,
      routerConfig: router,
    );
  }

  group('ProfileScreen', () {
    testWidgets('shows loading spinner when fetching data', (tester) async {
      when(
        () => mockGetUserProfileUseCase(),
      ).thenAnswer((_) async => Result.success(testUser));

      // We don't await pumpWidget fully to catch the loading state if possible,
      // but ProfileViewModel calls it in constructor and it might complete immediately if not delayed.
      // To reliably test loading, we can delay the response.
      when(() => mockGetUserProfileUseCase()).thenAnswer(
        (_) async => Future.delayed(
          const Duration(milliseconds: 100),
          () => Result.success(testUser),
        ),
      );

      await tester.pumpWidget(createWidget());
      await tester.pump(); // Start the future

      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      await tester.pumpAndSettle();
    });

    testWidgets('shows user data when fetch is successful', (tester) async {
      when(
        () => mockGetUserProfileUseCase(),
      ).thenAnswer((_) async => Result.success(testUser));

      await tester.pumpWidget(createWidget());
      await tester.pumpAndSettle();

      expect(find.text('JOHN DOE'), findsOneWidget);
      expect(find.text('Gold'), findsOneWidget);
      expect(find.text('100'), findsOneWidget); // Points
      expect(find.text('42'), findsOneWidget); // Check-ins
    });

    testWidgets('shows error message when fetch fails', (tester) async {
      when(() => mockGetUserProfileUseCase()).thenAnswer(
        (_) async => Result.failure(const ServerFailure('Failed to load')),
      );

      await tester.pumpWidget(createWidget());
      await tester.pumpAndSettle();

      // The screen shows l10n.commonLoadingError or 'Loading error'
      // From app_en.arb: "commonLoadingError": "Loading Error"
      expect(find.text('Loading Error'), findsOneWidget);
    });

    testWidgets('logout button triggers LogoutUseCase', (tester) async {
      when(
        () => mockGetUserProfileUseCase(),
      ).thenAnswer((_) async => Result.success(testUser));
      when(
        () => mockLogoutUseCase(),
      ).thenAnswer((_) async => Result.success(null));

      await tester.pumpWidget(createWidget());
      await tester.pumpAndSettle();

      // From app_en.arb: "profileLogout": "SIGN OUT"
      final logoutButton = find.text('SIGN OUT');

      // Scroll until the logout button is visible
      await tester.scrollUntilVisible(
        logoutButton,
        100.0,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.pumpAndSettle();

      expect(logoutButton, findsOneWidget);

      await tester.tap(logoutButton);
      await tester.pumpAndSettle();

      verify(() => mockLogoutUseCase()).called(1);
    });
  });
}

class _MockHttpOverrides extends HttpOverrides {
  final HttpClient client;
  _MockHttpOverrides(this.client);
  @override
  HttpClient createHttpClient(SecurityContext? context) => client;
}

class MockStreamSubscription<T> extends Mock implements StreamSubscription<T> {
  @override
  Future<void> cancel() async {}
}
