import 'package:bourgo_arena_mobile/domain/core/failure.dart';
import 'package:bourgo_arena_mobile/domain/usecases/auth/login_use_case.dart';
import 'package:bourgo_arena_mobile/presentation/auth/login/viewmodels/login_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bourgo_arena_mobile/core/utils/result.dart';
import 'package:mocktail/mocktail.dart';

import '../../data/repositories/repository_test_fixtures.dart';

class MockLoginUseCase extends Mock implements LoginUseCase {}

void main() {
  late MockLoginUseCase mockLoginUseCase;
  late LoginViewModel viewModel;

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
    expect(viewModel.isLoading, isFalse);
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
    expect(viewModel.isLoading, isFalse);
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

    expect(find.text('bad'), findsOneWidget);
    verify(() => mockLoginUseCase('alex@example.com', 'wrong')).called(1);
  });
}
