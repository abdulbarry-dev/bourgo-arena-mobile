import 'dart:async';
import 'package:bourgo_arena_mobile/core/utils/result.dart';
import 'package:bourgo_arena_mobile/domain/core/failure.dart';
import 'package:bourgo_arena_mobile/domain/usecases/auth/register_use_case.dart';
import 'package:bourgo_arena_mobile/presentation/auth/register/viewmodels/register_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:checks/checks.dart';

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
      check(viewModel.isLoading).isFalse();
      check(viewModel.errorMessage).isNull();
      check(viewModel.isParentAccount).isFalse();
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
          gender: any(named: 'gender'),
          birthDate: any(named: 'birthDate'),
          isFamilyAccount: any(named: 'isFamilyAccount'),
        ),
      );
      check(successCalled).isFalse();
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
          gender: any(named: 'gender'),
          birthDate: any(named: 'birthDate'),
          isFamilyAccount: any(named: 'isFamilyAccount'),
        ),
      ).thenAnswer((_) async => const Success(null));

      viewModel.firstNameController.text = 'John';
      viewModel.lastNameController.text = 'Doe';
      viewModel.emailController.text = 'john@example.com';
      viewModel.phoneController.text = '123456789';
      viewModel.passwordController.text = 'password123';
      viewModel.setGender('male');
      viewModel.setBirthDate(DateTime.utc(1990, 1, 1));
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
          gender: 'male',
          birthDate: DateTime.utc(1990, 1, 1),
          isFamilyAccount: true,
        ),
      ).called(1);

      final data = check(capturedData).isNotNull();
      data['firstName'].equals('John');
      data['isParentAccount'].isA<bool>().isTrue();
    });

    testWidgets('propagates failure as error state', (tester) async {
      when(
        () => mockRegisterUseCase(
          firstName: any(named: 'firstName'),
          lastName: any(named: 'lastName'),
          email: any(named: 'email'),
          phone: any(named: 'phone'),
          password: any(named: 'password'),
          gender: any(named: 'gender'),
          birthDate: any(named: 'birthDate'),
          isFamilyAccount: any(named: 'isFamilyAccount'),
        ),
      ).thenAnswer(
        (_) async => FailureResult(AuthFailure('Registration failed')),
      );

      viewModel.firstNameController.text = 'John';
      viewModel.setGender('male');
      viewModel.setBirthDate(DateTime.utc(1990, 1, 1));

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

      check(viewModel.errorMessage).isNotNull().equals('Registration failed');
      check(viewModel.isLoading).isFalse();
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
          gender: any(named: 'gender'),
          birthDate: any(named: 'birthDate'),
          isFamilyAccount: any(named: 'isFamilyAccount'),
        ),
      ).thenAnswer((_) => completer.future);

      viewModel.firstNameController.text = 'John';
      viewModel.setGender('male');
      viewModel.setBirthDate(DateTime.utc(1990, 1, 1));

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

      check(viewModel.isLoading).isTrue();

      completer.complete(const Success(null));
      await future;

      check(viewModel.isLoading).isFalse();
    });

    testWidgets('resets loading state even on failure', (tester) async {
      final completer = Completer<Result<void, Failure>>();

      when(
        () => mockRegisterUseCase(
          firstName: any(named: 'firstName'),
          lastName: any(named: 'lastName'),
          email: any(named: 'email'),
          phone: any(named: 'phone'),
          password: any(named: 'password'),
          gender: any(named: 'gender'),
          birthDate: any(named: 'birthDate'),
          isFamilyAccount: any(named: 'isFamilyAccount'),
        ),
      ).thenAnswer((_) => completer.future);

      viewModel.firstNameController.text = 'John';
      viewModel.setGender('male');
      viewModel.setBirthDate(DateTime.utc(1990, 1, 1));

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

      check(viewModel.isLoading).isTrue();

      completer.complete(FailureResult(AuthFailure('failed')));
      await future;

      check(viewModel.isLoading).isFalse();
      check(viewModel.errorMessage).isNotNull().equals('failed');
    });
  });
}
