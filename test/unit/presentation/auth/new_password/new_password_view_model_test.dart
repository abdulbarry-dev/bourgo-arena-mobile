import 'package:bourgo_arena_mobile/core/utils/result.dart';
import 'package:bourgo_arena_mobile/domain/usecases/auth/reset_password_use_case.dart';
import 'package:bourgo_arena_mobile/l10n/app_localizations.dart';
import 'package:bourgo_arena_mobile/presentation/auth/new_password/new_password_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:checks/checks.dart';
import 'package:mocktail/mocktail.dart';
import 'package:go_router/go_router.dart';

class MockResetPasswordUseCase extends Mock implements ResetPasswordUseCase {}

void main() {
  late NewPasswordViewModel viewModel;
  late MockResetPasswordUseCase mockResetPasswordUseCase;

  setUp(() {
    mockResetPasswordUseCase = MockResetPasswordUseCase();
    viewModel = NewPasswordViewModel(
      identifier: 'test@example.com',
      otp: '123456',
      resetPasswordUseCase: mockResetPasswordUseCase,
    );
  });

  tearDown(() {
    viewModel.dispose();
  });

  group('NewPasswordViewModel', () {
    test('initial state', () {
      check(viewModel.isLoading).isFalse();
      check(viewModel.identifier).equals('test@example.com');
      check(viewModel.otp).equals('123456');
    });

    test('setLoading updates state', () {
      viewModel.setLoading(true);
      check(viewModel.isLoading).isTrue();

      viewModel.setLoading(false);
      check(viewModel.isLoading).isFalse();
    });

    testWidgets('resetPassword does nothing if form is invalid', (
      tester,
    ) async {
      final router = GoRouter(
        routes: [GoRoute(path: '/', builder: (_, _) => Container())],
      );
      await tester.pumpWidget(MaterialApp.router(routerConfig: router));
      final context = tester.element(find.byType(Container));

      await viewModel.resetPassword(context);
      check(viewModel.isLoading).isFalse();
      verifyNever(
        () => mockResetPasswordUseCase(
          identifier: any(named: 'identifier'),
          otp: any(named: 'otp'),
          newPassword: any(named: 'newPassword'),
        ),
      );
    });

    testWidgets('resetPassword sets loading, navigates to /login on success', (
      tester,
    ) async {
      viewModel.passwordController.text = 'newPassword123';
      when(
        () => mockResetPasswordUseCase(
          identifier: any(named: 'identifier'),
          otp: any(named: 'otp'),
          newPassword: any(named: 'newPassword'),
        ),
      ).thenAnswer((_) async => const Success(null));

      String? capturedPath;

      final router = GoRouter(
        initialLocation: '/',
        routes: [
          GoRoute(
            path: '/',
            builder: (context, state) => Scaffold(
              body: Form(
                key: viewModel.formKey,
                child: TextFormField(
                  controller: viewModel.passwordController,
                  validator: (value) =>
                      (value == null || value.isEmpty) ? 'error' : null,
                ),
              ),
            ),
          ),
          GoRoute(
            path: '/login',
            builder: (context, state) {
              capturedPath = '/login';
              return const SizedBox();
            },
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

      final context = tester.element(find.byType(Form));

      await viewModel.resetPassword(context);
      await tester.pumpAndSettle();

      verify(
        () => mockResetPasswordUseCase(
          identifier: 'test@example.com',
          otp: '123456',
          newPassword: 'newPassword123',
        ),
      ).called(1);
      check(viewModel.isLoading).isFalse();
      check(capturedPath).equals('/login');
    });
  });
}
