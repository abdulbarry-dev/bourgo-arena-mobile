import 'dart:async';
import 'package:bourgo_arena_mobile/domain/core/failure.dart';
import 'package:bourgo_arena_mobile/domain/entities/user.dart';
import 'package:bourgo_arena_mobile/domain/usecases/auth/login_use_case.dart';
import 'package:bourgo_arena_mobile/presentation/auth/login/viewmodels/login_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bourgo_arena_mobile/core/utils/result.dart';
import 'package:mocktail/mocktail.dart';
import 'package:checks/checks.dart';

import '../../../data/repositories/repository_test_fixtures.dart';

class MockLoginUseCase extends Mock implements LoginUseCase {}

class MockBuildContext extends Mock implements BuildContext {}

void main() {
  late MockLoginUseCase mockLoginUseCase;
  late LoginViewModel viewModel;

  setUpAll(() {
    registerFallbackValue(MockBuildContext());
  });

  setUp(() {
    mockLoginUseCase = MockLoginUseCase();
    viewModel = LoginViewModel(mockLoginUseCase);
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
    final user = testUserEntity();
    when(
      () => mockLoginUseCase(any(), any()),
    ).thenAnswer((_) async => Success(user));

    // set controller values
    viewModel.identifierController.text = 'alex@example.com';
    viewModel.passwordController.text = 'secret123';

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

    verify(() => mockLoginUseCase('alex@example.com', 'secret123')).called(1);
    check(viewModel.isLoading).isFalse();
  });

  testWidgets('shows SnackBar with failure message on failure', (tester) async {
    when(
      () => mockLoginUseCase(any(), any()),
    ).thenAnswer((_) async => FailureResult(AuthFailure('bad')));

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

    // SnackBar shows asynchronously; settle animations
    await tester.pumpAndSettle();

    check(find.text('bad').evaluate()).isNotEmpty();
    verify(() => mockLoginUseCase('alex@example.com', 'wrong')).called(1);
    check(viewModel.isLoading).isFalse();
  });

  testWidgets('isLoading resets to false on failure result', (tester) async {
    final completer = Completer<Result<User, Failure>>();
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

    completer.complete(FailureResult(AuthFailure('failed')));
    await loginFuture;

    check(viewModel.isLoading).isFalse();
  });

  group('LoginViewModel - State Management', () {
    test('isLoading lifecycle and notifyListeners count', () async {
      final user = testUserEntity();
      when(
        () => mockLoginUseCase(any(), any()),
      ).thenAnswer((_) async => Success(user));

      viewModel.identifierController.text = 'alex@example.com';
      viewModel.passwordController.text = 'password';

      // We need to bypass form validation for simple state test or use testWidgets
      // Let's use testWidgets to ensure form is present
    });

    testWidgets('isLoading lifecycle and notifyListeners count', (
      tester,
    ) async {
      final user = testUserEntity();
      final completer = Completer<Result<User, Failure>>();
      when(
        () => mockLoginUseCase(any(), any()),
      ).thenAnswer((_) => completer.future);

      viewModel.identifierController.text = 'alex@example.com';
      viewModel.passwordController.text = 'password';

      int notifyCount = 0;
      viewModel.addListener(() => notifyCount++);

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
      check(notifyCount).equals(1); // setLoading(true)

      completer.complete(Success(user));
      await loginFuture;

      check(viewModel.isLoading).isFalse();
      check(notifyCount).equals(2); // setLoading(false)
    });

    testWidgets('double submit prevention', (tester) async {
      final user = testUserEntity();
      final completer = Completer<Result<User, Failure>>();
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

      // First call
      final firstCall = viewModel.login(ctx);
      check(viewModel.isLoading).isTrue();

      // Second call while first is still loading
      await viewModel.login(ctx);

      // Verify use case only called once
      verify(() => mockLoginUseCase(any(), any())).called(1);

      completer.complete(Success(user));
      await firstCall;
    });
  });
}
