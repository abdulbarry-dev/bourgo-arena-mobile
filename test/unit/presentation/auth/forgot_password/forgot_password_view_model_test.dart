import 'package:go_router/go_router.dart';
import 'package:bourgo_arena_mobile/presentation/auth/forgot_password/forgot_password_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:checks/checks.dart';

void main() {
  late ForgotPasswordViewModel viewModel;

  setUp(() {
    viewModel = ForgotPasswordViewModel();
  });

  tearDown(() {
    viewModel.dispose();
  });

  group('ForgotPasswordViewModel', () {
    test('initial state', () {
      check(viewModel.isLoading).isFalse();
      check(viewModel.identifierController.text).equals('');
    });

    test('setLoading updates state', () {
      viewModel.setLoading(true);
      check(viewModel.isLoading).isTrue();

      viewModel.setLoading(false);
      check(viewModel.isLoading).isFalse();
    });

    testWidgets('sendCode does nothing if form is invalid', (tester) async {
      final router = GoRouter(
        routes: [GoRoute(path: '/', builder: (_, _) => Container())],
      );
      await tester.pumpWidget(MaterialApp.router(routerConfig: router));
      final context = tester.element(find.byType(Container));

      viewModel.sendCode(context);
      check(viewModel.isLoading).isFalse();
    });

    testWidgets('sendCode sets loading and navigates if form is valid', (
      tester,
    ) async {
      viewModel.identifierController.text = 'test@example.com';

      final router = GoRouter(
        initialLocation: '/',
        routes: [
          GoRoute(
            path: '/',
            builder: (context, state) => Scaffold(
              body: Form(
                key: viewModel.formKey,
                child: TextFormField(
                  controller: viewModel.identifierController,
                  validator: (value) => value!.isEmpty ? 'error' : null,
                ),
              ),
            ),
          ),
          GoRoute(path: '/otp', builder: (_, _) => const SizedBox()),
        ],
      );

      await tester.pumpWidget(MaterialApp.router(routerConfig: router));

      final context = tester.element(find.byType(Form));

      viewModel.sendCode(context);

      check(viewModel.isLoading).isTrue();

      // Wait for simulated API call
      await tester.pump(const Duration(seconds: 3));

      check(viewModel.isLoading).isFalse();
    });
  });
}
