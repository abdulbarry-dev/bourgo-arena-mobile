import 'dart:async';
import 'package:bourgo_arena_mobile/domain/entities/auth_state.dart';
import 'package:bourgo_arena_mobile/domain/core/failure.dart';
import 'package:bourgo_arena_mobile/domain/entities/auth_session.dart';
import 'package:bourgo_arena_mobile/l10n/app_localizations.dart';
import 'package:bourgo_arena_mobile/domain/repositories/session_repository.dart';
import 'package:bourgo_arena_mobile/domain/usecases/auth/login_use_case.dart';
import 'package:bourgo_arena_mobile/presentation/auth/login/viewmodels/login_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bourgo_arena_mobile/core/utils/result.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';
import 'package:checks/checks.dart';

import '../../../data/repositories/repository_test_fixtures.dart';
import 'package:bourgo_arena_mobile/domain/core/app_error_code.dart';

class MockLoginUseCase extends Mock implements LoginUseCase {}

class MockSessionRepository extends Mock implements SessionRepository {}

class MockBuildContext extends Mock implements BuildContext {}

void main() {
  late MockLoginUseCase mockLoginUseCase;
  late MockSessionRepository mockSessionRepository;
  late LoginViewModel viewModel;

  setUpAll(() {
    registerFallbackValue(MockBuildContext());
  });

  setUp(() {
    mockLoginUseCase = MockLoginUseCase();
    mockSessionRepository = MockSessionRepository();
    viewModel = LoginViewModel(mockLoginUseCase, mockSessionRepository);

    when(
      () => mockSessionRepository.getRememberedIdentifier(),
    ).thenAnswer((_) async => const Success(null));
  });

  testWidgets('does not call use case when form is not valid', (tester) async {
    await tester.pumpWidget(
      MaterialApp(home: Builder(builder: (context) => Container())),
    );

    final ctx = tester.element(find.byType(Container));

    await viewModel.login(ctx);

    verifyNever(() => mockLoginUseCase(any(), any()));
    check(viewModel.isLoading).isFalse();
  });

  testWidgets('calls use case and leaves isLoading false on success', (
    tester,
  ) async {
    final session = testAuthSession();
    when(
      () => mockLoginUseCase(any(), any()),
    ).thenAnswer((_) async => Success(session));
    when(
      () => mockSessionRepository.clearRememberedIdentifier(),
    ).thenAnswer((_) async => const Success(null));

    // set controller values
    viewModel.identifierController.text = 'alex@example.com';
    viewModel.passwordController.text = 'secret123';

    await tester.pumpWidget(
      MaterialApp.router(
        routerConfig: GoRouter(
          initialLocation: '/',
          routes: [
            GoRoute(
              path: '/',
              builder: (context, state) => Scaffold(
                body: Form(
                  key: viewModel.formKey,
                  child: Column(
                    children: [
                      TextFormField(controller: viewModel.identifierController),
                      TextFormField(controller: viewModel.passwordController),
                    ],
                  ),
                ),
              ),
            ),
            GoRoute(
              path: '/home',
              builder: (context, state) => const SizedBox(),
            ),
          ],
        ),
      ),
    );

    final ctx = tester.element(find.byType(Form));

    await viewModel.login(ctx);

    verify(() => mockLoginUseCase('alex@example.com', 'secret123')).called(1);
    check(viewModel.isLoading).isFalse();
  });

  group('Remember Me -', () {
    test('initialize loads remembered identifier', () async {
      when(
        () => mockSessionRepository.getRememberedIdentifier(),
      ).thenAnswer((_) async => const Success('remembered@example.com'));

      await viewModel.initialize();

      check(
        viewModel.identifierController.text,
      ).equals('remembered@example.com');
      check(viewModel.isRememberMeChecked).isTrue();
    });

    testWidgets('login saves identifier when remember me is checked', (
      tester,
    ) async {
      final session = testAuthSession();
      when(
        () => mockLoginUseCase(any(), any()),
      ).thenAnswer((_) async => Success(session));
      when(
        () => mockSessionRepository.saveRememberedIdentifier(any()),
      ).thenAnswer((_) async => const Success(null));

      viewModel.identifierController.text = 'alex@example.com';
      viewModel.passwordController.text = 'password';
      viewModel.toggleRememberMe(true);

      await tester.pumpWidget(
        MaterialApp.router(
          routerConfig: GoRouter(
            initialLocation: '/',
            routes: [
              GoRoute(
                path: '/',
                builder: (context, state) => Scaffold(
                  body: Form(
                    key: viewModel.formKey,
                    child: TextFormField(
                      controller: viewModel.identifierController,
                    ),
                  ),
                ),
              ),
              GoRoute(
                path: '/home',
                builder: (context, state) => const SizedBox(),
              ),
            ],
          ),
        ),
      );

      final ctx = tester.element(find.byType(Form));

      await viewModel.login(ctx);

      verify(
        () =>
            mockSessionRepository.saveRememberedIdentifier('alex@example.com'),
      ).called(1);
    });

    testWidgets('login clears identifier when remember me is NOT checked', (
      tester,
    ) async {
      final session = testAuthSession();
      when(
        () => mockLoginUseCase(any(), any()),
      ).thenAnswer((_) async => Success(session));
      when(
        () => mockSessionRepository.clearRememberedIdentifier(),
      ).thenAnswer((_) async => const Success(null));

      viewModel.identifierController.text = 'alex@example.com';
      viewModel.passwordController.text = 'password';
      viewModel.toggleRememberMe(false);

      await tester.pumpWidget(
        MaterialApp.router(
          routerConfig: GoRouter(
            initialLocation: '/',
            routes: [
              GoRoute(
                path: '/',
                builder: (context, state) => Scaffold(
                  body: Form(
                    key: viewModel.formKey,
                    child: TextFormField(
                      controller: viewModel.identifierController,
                    ),
                  ),
                ),
              ),
              GoRoute(
                path: '/home',
                builder: (context, state) => const SizedBox(),
              ),
            ],
          ),
        ),
      );

      final ctx = tester.element(find.byType(Form));

      await viewModel.login(ctx);

      verify(() => mockSessionRepository.clearRememberedIdentifier()).called(1);
    });
  });

  testWidgets('shows SnackBar with failure message on failure', (tester) async {
    when(() => mockLoginUseCase(any(), any())).thenAnswer(
      (_) async =>
          FailureResult(AuthFailure(AppErrorCode.invalidCredentials, 'bad')),
    );

    viewModel.identifierController.text = 'alex@example.com';
    viewModel.passwordController.text = 'wrong';

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Form(
            key: viewModel.formKey,
            child: Column(
              children: [
                TextFormField(controller: viewModel.identifierController),
                TextFormField(controller: viewModel.passwordController),
              ],
            ),
          ),
        ),
      ),
    );

    final ctx = tester.element(find.byType(Form));

    await viewModel.login(ctx);

    // Pump once so the AppToast builds
    await tester.pump();

    check(find.text('bad').evaluate()).isNotEmpty();
    verify(() => mockLoginUseCase('alex@example.com', 'wrong')).called(1);
    check(viewModel.isLoading).isFalse();

    // wait for toast to finish
    await tester.pumpAndSettle();
    await tester.pump(const Duration(seconds: 5));
  });

  testWidgets('isLoading resets to false on failure result', (tester) async {
    final completer = Completer<Result<AuthSession, Failure>>();
    when(
      () => mockLoginUseCase(any(), any()),
    ).thenAnswer((_) => completer.future);

    viewModel.identifierController.text = 'alex@example.com';
    viewModel.passwordController.text = 'password';

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Form(
            key: viewModel.formKey,
            child: TextFormField(controller: viewModel.identifierController),
          ),
        ),
      ),
    );

    final ctx = tester.element(find.byType(Form));

    final loginFuture = viewModel.login(ctx);

    check(viewModel.isLoading).isTrue();

    completer.complete(
      FailureResult(AuthFailure(AppErrorCode.invalidCredentials, 'failed')),
    );
    await loginFuture;

    check(viewModel.isLoading).isFalse();

    // cleanup toast
    await tester.pumpAndSettle();
    await tester.pump(const Duration(seconds: 5));
  });

  group('LoginViewModel - State Management', () {
    testWidgets('isLoading lifecycle and notifyListeners count', (
      tester,
    ) async {
      final session = testAuthSession();
      final completer = Completer<Result<AuthSession, Failure>>();
      when(
        () => mockLoginUseCase(any(), any()),
      ).thenAnswer((_) => completer.future);
      when(
        () => mockSessionRepository.clearRememberedIdentifier(),
      ).thenAnswer((_) async => const Success(null));

      viewModel.identifierController.text = 'alex@example.com';
      viewModel.passwordController.text = 'password';

      int notifyCount = 0;
      viewModel.addListener(() => notifyCount++);

      await tester.pumpWidget(
        MaterialApp.router(
          routerConfig: GoRouter(
            initialLocation: '/',
            routes: [
              GoRoute(
                path: '/',
                builder: (context, state) => Scaffold(
                  body: Form(
                    key: viewModel.formKey,
                    child: TextFormField(
                      controller: viewModel.identifierController,
                    ),
                  ),
                ),
              ),
              GoRoute(
                path: '/home',
                builder: (context, state) => const SizedBox(),
              ),
            ],
          ),
        ),
      );

      final ctx = tester.element(find.byType(Form));

      final loginFuture = viewModel.login(ctx);

      check(viewModel.isLoading).isTrue();
      check(notifyCount).equals(1); // setLoading(true)

      completer.complete(Success(session));
      await loginFuture;

      check(viewModel.isLoading).isFalse();
      check(notifyCount).equals(2); // setLoading(false)
    });

    testWidgets('shows setup modal when state is pendingOnboarding', (
      tester,
    ) async {
      final session = testAuthSession(
        user: testUserEntity(
          firstName: 'Alex',
          lastName: 'Morgan',
          email: 'alex@example.com',
          phone: '+15550000000',
          birthDate: DateTime.utc(1992, 7, 8),
          gender: 'male',
        ),
        state: AuthState.pendingOnboarding,
      );
      when(
        () => mockLoginUseCase(any(), any()),
      ).thenAnswer((_) async => Success(session));
      when(
        () => mockSessionRepository.clearRememberedIdentifier(),
      ).thenAnswer((_) async => const Success(null));

      viewModel.identifierController.text = 'alex@example.com';
      viewModel.passwordController.text = 'password';

      await tester.pumpWidget(
        MaterialApp.router(
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          routerConfig: GoRouter(
            initialLocation: '/',
            routes: [
              GoRoute(
                path: '/',
                builder: (context, state) => Scaffold(
                  body: Form(
                    key: viewModel.formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: viewModel.identifierController,
                        ),
                        TextFormField(controller: viewModel.passwordController),
                      ],
                    ),
                  ),
                ),
              ),
              GoRoute(
                path: '/account-setup',
                builder: (context, state) {
                  final payload = state.extra is Map<String, dynamic>
                      ? state.extra as Map<String, dynamic>
                      : <String, dynamic>{};
                  return Scaffold(
                    body: Text(
                      '${payload['firstName']} ${payload['lastName']} '
                      '${payload['email']} ${payload['phone']}',
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      );

      final ctx = tester.element(find.byType(Form));

      await viewModel.login(ctx);
      await tester.pumpAndSettle();

      expect(find.text('Complete Setup'), findsOneWidget);

      await tester.tap(find.text('Complete Setup'));
      await tester.pumpAndSettle();

      expect(find.textContaining('Alex Morgan'), findsOneWidget);
      expect(find.textContaining('alex@example.com'), findsOneWidget);
    });
  });
}
