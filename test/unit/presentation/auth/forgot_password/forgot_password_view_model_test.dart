import 'package:bourgo_arena_mobile/core/utils/result.dart';
import 'package:bourgo_arena_mobile/domain/core/failure.dart';
import 'package:bourgo_arena_mobile/domain/usecases/auth/forgot_password_use_case.dart';
import 'package:go_router/go_router.dart';
import 'package:bourgo_arena_mobile/presentation/auth/forgot_password/forgot_password_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:checks/checks.dart';
import 'package:mocktail/mocktail.dart';
import 'package:bourgo_arena_mobile/domain/core/app_error_code.dart';

class MockForgotPasswordUseCase extends Mock implements ForgotPasswordUseCase {}

void main() {
  late ForgotPasswordViewModel viewModel;
  late MockForgotPasswordUseCase mockForgotPasswordUseCase;

  setUp(() {
    mockForgotPasswordUseCase = MockForgotPasswordUseCase();
    viewModel = ForgotPasswordViewModel(mockForgotPasswordUseCase);
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
      verifyNever(() => mockForgotPasswordUseCase(any()));
    });

    testWidgets('sendCode sets loading and navigates if form is valid', (
      tester,
    ) async {
      viewModel.identifierController.text = 'test@example.com';
      when(
        () => mockForgotPasswordUseCase(any()),
      ).thenAnswer((_) async => const Success(null));

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

      await viewModel.sendCode(context);

      verify(() => mockForgotPasswordUseCase('test@example.com')).called(1);
      check(viewModel.isLoading).isFalse();
    });

    testWidgets('sendCode shows snackbar on failure', (tester) async {
      viewModel.identifierController.text = 'test@example.com';
      when(() => mockForgotPasswordUseCase(any())).thenAnswer(
        (_) async => FailureResult(
          AuthFailure(AppErrorCode.invalidCredentials, 'error'),
        ),
      );

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
        ],
      );

      await tester.pumpWidget(MaterialApp.router(routerConfig: router));

      final context = tester.element(find.byType(Form));

      await viewModel.sendCode(context);

      await tester.pump();

      check(find.text('error').evaluate()).isNotEmpty();
      check(viewModel.isLoading).isFalse();

      await tester.pumpAndSettle();
      await tester.pump(const Duration(seconds: 5));
    });

    testWidgets('sendCode redirects to /otp with isPasswordReset: false '
        'if error is pending_verification', (tester) async {
      viewModel.identifierController.text = 'test@example.com';
      when(() => mockForgotPasswordUseCase(any())).thenAnswer(
        (_) async => FailureResult(
          AuthFailure(
            AppErrorCode.invalidCredentials,
            'email_not_verified',
            'pending_verification',
          ),
        ),
      );

      String? capturedPath;
      Object? capturedExtra;

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
          GoRoute(
            path: '/otp',
            builder: (context, state) {
              capturedPath = '/otp';
              capturedExtra = state.extra;
              return const SizedBox();
            },
          ),
        ],
      );

      await tester.pumpWidget(MaterialApp.router(routerConfig: router));
      final context = tester.element(find.byType(Form));

      await viewModel.sendCode(context);
      await tester.pumpAndSettle();

      check(capturedPath).equals('/otp');
      final extraMap = check(capturedExtra).isA<Map<String, dynamic>>();
      extraMap
          .has((m) => m['destination'], 'destination')
          .isA<String>()
          .equals('test@example.com');
      extraMap
          .has((m) => m['isPasswordReset'], 'isPasswordReset')
          .isA<bool>()
          .isFalse();
    });
  });
}
