import 'package:bourgo_arena_mobile/core/utils/result.dart';
import 'package:bourgo_arena_mobile/domain/core/failure.dart';
import 'package:bourgo_arena_mobile/domain/repositories/session_repository.dart';
import 'package:bourgo_arena_mobile/domain/usecases/auth/login_use_case.dart';
import 'package:bourgo_arena_mobile/l10n/app_localizations.dart';
import 'package:bourgo_arena_mobile/presentation/auth/login/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';

import '../../unit/data/repositories/repository_test_fixtures.dart';
import 'package:bourgo_arena_mobile/domain/core/app_error_code.dart';

class MockLoginUseCase extends Mock implements LoginUseCase {}

class MockSessionRepository extends Mock implements SessionRepository {}

void main() {
  late MockLoginUseCase mockLoginUseCase;
  late MockSessionRepository mockSessionRepository;

  setUp(() {
    mockLoginUseCase = MockLoginUseCase();
    mockSessionRepository = MockSessionRepository();

    when(
      () => mockSessionRepository.getRememberedIdentifier(),
    ).thenAnswer((_) async => const Success(null));
  });

  Future<void> setupScreenSize(WidgetTester tester) async {
    tester.view.physicalSize = const Size(800, 1200);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
  }

  testWidgets('login button disabled when form invalid', (tester) async {
    await setupScreenSize(tester);
    final router = GoRouter(
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => LoginScreen(
            loginUseCase: mockLoginUseCase,
            sessionRepository: mockSessionRepository,
          ),
        ),
      ],
    );

    await tester.pumpWidget(
      MaterialApp.router(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        routerConfig: router,
      ),
    );

    // Button exists and should be present
    final loginButton = find.descendant(
      of: find.byType(LoginScreen),
      matching: find.widgetWithText(ElevatedButton, 'LOG IN'),
    );
    expect(loginButton, findsOneWidget);

    // Invoke the ElevatedButton callback directly to avoid hit-test/scrolling flakiness
    final el0 = find
        .descendant(
          of: find.byType(LoginScreen),
          matching: find.widgetWithText(ElevatedButton, 'LOG IN'),
        )
        .evaluate()
        .first;
    final btn0 = el0.widget as ElevatedButton;
    btn0.onPressed?.call();
    await tester.pumpAndSettle();

    verifyNever(() => mockLoginUseCase(any(), any()));
  });

  testWidgets('calls login use case on valid form', (tester) async {
    await setupScreenSize(tester);
    final session = testAuthSession();
    when(
      () => mockLoginUseCase(any(), any()),
    ).thenAnswer((_) async => Success(session));
    when(
      () => mockSessionRepository.clearRememberedIdentifier(),
    ).thenAnswer((_) async => const Success(null));

    final router = GoRouter(
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => LoginScreen(
            loginUseCase: mockLoginUseCase,
            sessionRepository: mockSessionRepository,
          ),
        ),
      ],
    );

    await tester.pumpWidget(
      MaterialApp.router(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        routerConfig: router,
      ),
    );

    // Enter credentials
    await tester.enterText(
      find.byType(TextFormField).at(0),
      'alex@example.com',
    );
    await tester.enterText(find.byType(TextFormField).at(1), 'secret123');

    final el1 = find
        .descendant(
          of: find.byType(LoginScreen),
          matching: find.widgetWithText(ElevatedButton, 'LOG IN'),
        )
        .evaluate()
        .first;
    final btn1 = el1.widget as ElevatedButton;
    btn1.onPressed?.call();
    await tester.pumpAndSettle();

    verify(() => mockLoginUseCase('alex@example.com', 'secret123')).called(1);
  });

  testWidgets('shows SnackBar on failure', (tester) async {
    await setupScreenSize(tester);
    when(() => mockLoginUseCase(any(), any())).thenAnswer(
      (_) async =>
          FailureResult(AuthFailure(AppErrorCode.invalidCredentials, 'bad')),
    );

    final router = GoRouter(
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => LoginScreen(
            loginUseCase: mockLoginUseCase,
            sessionRepository: mockSessionRepository,
          ),
        ),
      ],
    );

    await tester.pumpWidget(
      MaterialApp.router(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        routerConfig: router,
      ),
    );

    await tester.enterText(
      find.byType(TextFormField).at(0),
      'alex@example.com',
    );
    await tester.enterText(find.byType(TextFormField).at(1), 'wrong');

    final el2 = find
        .descendant(
          of: find.byType(LoginScreen),
          matching: find.widgetWithText(ElevatedButton, 'LOG IN'),
        )
        .evaluate()
        .first;
    final btn2 = el2.widget as ElevatedButton;
    btn2.onPressed?.call();
    await tester.pumpAndSettle();

    expect(find.text('bad'), findsOneWidget);
    verify(() => mockLoginUseCase('alex@example.com', 'wrong')).called(1);
  });
}
