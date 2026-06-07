import 'package:bourgo_arena_mobile/core/utils/result.dart';
import 'package:bourgo_arena_mobile/domain/core/app_error_code.dart';
import 'package:bourgo_arena_mobile/domain/core/failure.dart';
import 'package:bourgo_arena_mobile/domain/repositories/payment_repository.dart';
import 'package:bourgo_arena_mobile/presentation/payment/payment_selection_view_model.dart';
import 'package:checks/checks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:bourgo_arena_mobile/core/di/locator.dart';
import 'package:bourgo_arena_mobile/presentation/auth/auth_state_notifier.dart';
import 'package:bourgo_arena_mobile/domain/entities/auth_session.dart';
import 'package:bourgo_arena_mobile/domain/entities/auth_state.dart';
import 'package:bourgo_arena_mobile/domain/entities/user.dart';

class MockPaymentRepository extends Mock implements PaymentRepository {}

class MockAuthStateNotifier extends Mock implements AuthStateNotifier {}

void main() {
  late MockPaymentRepository mockPaymentRepository;
  late PaymentSelectionViewModel viewModel;

  setUp(() {
    mockPaymentRepository = MockPaymentRepository();
    final mockAuthNotifier = MockAuthStateNotifier();

    when(() => mockAuthNotifier.session).thenReturn(
      const AuthSession(user: null, state: AuthState.unauthenticated),
    );

    locator.allowReassignment = true;
    if (!locator.isRegistered<AuthStateNotifier>()) {
      locator.registerSingleton<AuthStateNotifier>(mockAuthNotifier);
    } else {
      locator.unregister<AuthStateNotifier>();
      locator.registerSingleton<AuthStateNotifier>(mockAuthNotifier);
    }

    viewModel = PaymentSelectionViewModel(
      paymentRepository: mockPaymentRepository,
    );
  });

  group('PaymentSelectionViewModel', () {
    test('initial state is idle', () {
      check(viewModel.state).equals(PaymentSelectionState.idle);
      check(viewModel.errorMessage).isNull();
    });

    test('initiatePayment success', () async {
      when(
        () => mockPaymentRepository.initiatePayment(
          amount: 100.0,
          provider: 'konnect',
          description: 'desc',
          successUrl: any(named: 'successUrl'),
          failureUrl: any(named: 'failureUrl'),
          firstName: any(named: 'firstName'),
          lastName: any(named: 'lastName'),
          email: any(named: 'email'),
          phone: any(named: 'phone'),
        ),
      ).thenAnswer(
        (_) async => Result<Map<String, dynamic>, Failure>.success({
          'payment_url': 'https://gateway.com',
          'payment_reference': 'ref123',
        }),
      );

      await viewModel.initiatePayment(
        amount: 100.0,
        provider: 'konnect',
        description: 'desc',
      );

      check(viewModel.state).equals(PaymentSelectionState.awaitingVerification);
      check(viewModel.paymentUrl).equals('https://gateway.com');
      check(viewModel.errorMessage).isNull();
    });

    test('initiatePayment failure', () async {
      when(
        () => mockPaymentRepository.initiatePayment(
          amount: 100.0,
          provider: 'konnect',
          description: 'desc',
          successUrl: any(named: 'successUrl'),
          failureUrl: any(named: 'failureUrl'),
          firstName: any(named: 'firstName'),
          lastName: any(named: 'lastName'),
          email: any(named: 'email'),
          phone: any(named: 'phone'),
        ),
      ).thenAnswer(
        (_) async => Result<Map<String, dynamic>, Failure>.failure(
          const ServerFailure(AppErrorCode.serverError, 'Server Error'),
        ),
      );

      await viewModel.initiatePayment(
        amount: 100.0,
        provider: 'konnect',
        description: 'desc',
      );

      check(viewModel.state).equals(PaymentSelectionState.failed);
      check(viewModel.errorMessage).equals('Server Error');
    });

    test('verifyPayment success', () async {
      when(
        () => mockPaymentRepository.initiatePayment(
          amount: 100.0,
          provider: 'konnect',
          description: 'desc',
          successUrl: any(named: 'successUrl'),
          failureUrl: any(named: 'failureUrl'),
          firstName: any(named: 'firstName'),
          lastName: any(named: 'lastName'),
          email: any(named: 'email'),
          phone: any(named: 'phone'),
        ),
      ).thenAnswer(
        (_) async => Result<Map<String, dynamic>, Failure>.success({
          'payment_url': 'https://gateway.com',
          'payment_reference': 'ref123',
        }),
      );

      await viewModel.initiatePayment(
        amount: 100.0,
        provider: 'konnect',
        description: 'desc',
      );

      when(
        () => mockPaymentRepository.verifyPayment(paymentReference: 'ref123'),
      ).thenAnswer(
        (_) async =>
            Result<Map<String, dynamic>, Failure>.success({'status': 'paid'}),
      );

      await viewModel.verifyPayment();

      check(viewModel.state).equals(PaymentSelectionState.verified);
      check(viewModel.errorMessage).isNull();
    });
  });
}
