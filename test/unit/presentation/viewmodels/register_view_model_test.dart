import 'dart:async';
import 'package:bourgo_arena_mobile/core/utils/result.dart';
import 'package:bourgo_arena_mobile/domain/core/failure.dart';
import 'package:bourgo_arena_mobile/domain/usecases/auth/register_use_case.dart';
import 'package:bourgo_arena_mobile/presentation/auth/register/viewmodels/register_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockRegisterUseCase extends Mock implements RegisterUseCase {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late MockRegisterUseCase mockRegisterUseCase;
  late RegisterViewModel viewModel;

  setUp(() {
    mockRegisterUseCase = MockRegisterUseCase();
    viewModel = RegisterViewModel(mockRegisterUseCase);
  });

  group('RegisterViewModel -', () {
    testWidgets('initial state is correct', (tester) async {
      expect(viewModel.isLoading, isFalse);
      expect(viewModel.errorMessage, isNull);
      expect(viewModel.isParentAccount, isFalse);
    });

    testWidgets('form validation blocks submission', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Form(
              key: viewModel.formKey,
              child: TextFormField(validator: (value) => 'error'),
            ),
          ),
        ),
      );

      bool successCalled = false;
      await viewModel.register(onSuccess: (_) => successCalled = true);

      verifyNever(
        () => mockRegisterUseCase(
          firstName: any(named: 'firstName'),
          lastName: any(named: 'lastName'),
          email: any(named: 'email'),
          phone: any(named: 'phone'),
          password: any(named: 'password'),
          isFamilyAccount: any(named: 'isFamilyAccount'),
        ),
      );
      expect(successCalled, isFalse);
    });

    testWidgets('calls RegisterUseCase with correct params on valid form', (
      tester,
    ) async {
      when(
        () => mockRegisterUseCase(
          firstName: any(named: 'firstName'),
          lastName: any(named: 'lastName'),
          email: any(named: 'email'),
          phone: any(named: 'phone'),
          password: any(named: 'password'),
          isFamilyAccount: any(named: 'isFamilyAccount'),
        ),
      ).thenAnswer((_) async => const Success(null));

      viewModel.firstNameController.text = 'John';
      viewModel.lastNameController.text = 'Doe';
      viewModel.emailController.text = 'john@example.com';
      viewModel.phoneController.text = '123456789';
      viewModel.passwordController.text = 'password123';
      viewModel.setParentAccount(true);

      // Build a minimal form to satisfy validate()
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Form(
              key: viewModel.formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: viewModel.firstNameController,
                    validator: (v) => v!.isEmpty ? 'error' : null,
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      Map<String, dynamic>? capturedData;
      await viewModel.register(onSuccess: (data) => capturedData = data);

      verify(
        () => mockRegisterUseCase(
          firstName: 'John',
          lastName: 'Doe',
          email: 'john@example.com',
          phone: '123456789',
          password: 'password123',
          isFamilyAccount: true,
        ),
      ).called(1);

      expect(capturedData, isNotNull);
      expect(capturedData!['firstName'], 'John');
      expect(capturedData!['isParentAccount'], isTrue);
    });

    testWidgets('propagates failure as error state', (tester) async {
      when(
        () => mockRegisterUseCase(
          firstName: any(named: 'firstName'),
          lastName: any(named: 'lastName'),
          email: any(named: 'email'),
          phone: any(named: 'phone'),
          password: any(named: 'password'),
          isFamilyAccount: any(named: 'isFamilyAccount'),
        ),
      ).thenAnswer(
        (_) async => FailureResult(AuthFailure('Registration failed')),
      );

      viewModel.firstNameController.text = 'John';

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Form(
              key: viewModel.formKey,
              child: TextFormField(
                controller: viewModel.firstNameController,
                validator: (v) => null, // always valid for this test
              ),
            ),
          ),
        ),
      );

      await viewModel.register(onSuccess: (_) {});

      expect(viewModel.errorMessage, 'Registration failed');
      expect(viewModel.isLoading, isFalse);
    });

    testWidgets('sets loading state during async call', (tester) async {
      // Use a completer to control the timing of the response
      final completer = Completer<Result<void, Failure>>();

      when(
        () => mockRegisterUseCase(
          firstName: any(named: 'firstName'),
          lastName: any(named: 'lastName'),
          email: any(named: 'email'),
          phone: any(named: 'phone'),
          password: any(named: 'password'),
          isFamilyAccount: any(named: 'isFamilyAccount'),
        ),
      ).thenAnswer((_) => completer.future);

      viewModel.firstNameController.text = 'John';

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Form(
              key: viewModel.formKey,
              child: TextFormField(
                controller: viewModel.firstNameController,
                validator: (v) => null,
              ),
            ),
          ),
        ),
      );

      final future = viewModel.register(onSuccess: (_) {});

      expect(viewModel.isLoading, isTrue);

      completer.complete(const Success(null));
      await future;

      expect(viewModel.isLoading, isFalse);
    });
  });
}
