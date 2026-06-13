import 'package:bourgo_arena_mobile/core/utils/result.dart';
import 'package:bourgo_arena_mobile/domain/core/app_error_code.dart';
import 'package:bourgo_arena_mobile/domain/core/failure.dart';
import 'package:bourgo_arena_mobile/domain/entities/subscription.dart';
import 'package:bourgo_arena_mobile/domain/repositories/payment_repository.dart';
import 'package:bourgo_arena_mobile/domain/usecases/subscription/subscribe_to_plan_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/loyalty/pay_with_loyalty_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/user/get_user_profile_use_case.dart';
import 'package:bourgo_arena_mobile/presentation/payment/payment_selection_view_model.dart';
import 'package:checks/checks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:bourgo_arena_mobile/core/di/locator.dart';
import 'package:bourgo_arena_mobile/presentation/auth/auth_state_notifier.dart';
import 'package:bourgo_arena_mobile/domain/entities/auth_session.dart';
import 'package:bourgo_arena_mobile/domain/entities/auth_state.dart';

class MockPaymentRepository extends Mock implements PaymentRepository {}

class MockSubscribeToPlanUseCase extends Mock
    implements SubscribeToPlanUseCase {}

class MockPayWithLoyaltyUseCase extends Mock implements PayWithLoyaltyUseCase {}

class MockAuthStateNotifier extends Mock implements AuthStateNotifier {}

class MockGetUserProfileUseCase extends Mock implements GetUserProfileUseCase {}

Subscription testSubscription({String id = '43', String status = 'pending'}) {
  return Subscription(
    id: id,
    plan: null,
    service: null,
    status: status,
    startsAt: null,
    endsAt: null,
    daysRemaining: 0,
    paymentMethod: 'konnect',
    amountPaid: 0.0,
    receiptUrl: null,
  );
}

void main() {
  late MockPaymentRepository mockPaymentRepository;
  late MockSubscribeToPlanUseCase mockSubscribe;
  late MockPayWithLoyaltyUseCase mockLoyalty;
  late PaymentSelectionViewModel viewModel;

  setUp(() {
    mockPaymentRepository = MockPaymentRepository();
    mockSubscribe = MockSubscribeToPlanUseCase();
    mockLoyalty = MockPayWithLoyaltyUseCase();
    final mockAuthNotifier = MockAuthStateNotifier();
    final mockGetUserProfileUseCase = MockGetUserProfileUseCase();

    when(() => mockAuthNotifier.session).thenReturn(
      const AuthSession(user: null, state: AuthState.unauthenticated),
    );
    when(() => mockGetUserProfileUseCase()).thenAnswer(
      (_) async => Result.failure(
        ServerFailure(AppErrorCode.serverError, 'no profile mock'),
      ),
    );

    locator.allowReassignment = true;
    if (!locator.isRegistered<AuthStateNotifier>()) {
      locator.registerSingleton<AuthStateNotifier>(mockAuthNotifier);
    } else {
      locator.unregister<AuthStateNotifier>();
      locator.registerSingleton<AuthStateNotifier>(mockAuthNotifier);
    }

    if (!locator.isRegistered<GetUserProfileUseCase>()) {
      locator.registerSingleton<GetUserProfileUseCase>(
        mockGetUserProfileUseCase,
      );
    } else {
      locator.unregister<GetUserProfileUseCase>();
      locator.registerSingleton<GetUserProfileUseCase>(
        mockGetUserProfileUseCase,
      );
    }

    viewModel = PaymentSelectionViewModel(
      paymentRepository: mockPaymentRepository,
      subscribeToPlanUseCase: mockSubscribe,
      payWithLoyaltyUseCase: mockLoyalty,
    );
  });

  group('PaymentSelectionViewModel', () {
    test('initial state is idle', () {
      check(viewModel.state).equals(PaymentSelectionState.idle);
      check(viewModel.errorMessage).isNull();
    });

    test('subscribeAndPay Konnect success', () async {
      final sub = testSubscription();
      when(
        () => mockSubscribe('3'),
      ).thenAnswer((_) async => Result<Subscription, Failure>.success(sub));
      when(
        () => mockPaymentRepository.initiatePayment(
          amount: 150.0,
          provider: 'konnect',
          description: 'desc',
          type: 'subscription',
          subscriptionId: any(named: 'subscriptionId'),
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

      await viewModel.subscribeAndPay(
        planId: '3',
        amount: 150.0,
        provider: 'konnect',
        description: 'desc',
      );

      check(viewModel.state).equals(PaymentSelectionState.awaitingVerification);
      check(viewModel.paymentUrl).equals('https://gateway.com');
      check(viewModel.errorMessage).isNull();
    });

    test('subscribeAndPay Loyalty success', () async {
      final sub = testSubscription(id: '43');
      when(
        () => mockSubscribe('3'),
      ).thenAnswer((_) async => Result<Subscription, Failure>.success(sub));
      when(() => mockLoyalty(type: 'subscription', id: 43)).thenAnswer(
        (_) async => Result<Map<String, dynamic>, Failure>.success({
          'status': 'paid',
          'points_used': 15000,
        }),
      );

      await viewModel.subscribeAndPay(
        planId: '3',
        amount: 150.0,
        provider: 'loyalty',
        description: 'desc',
      );

      check(viewModel.state).equals(PaymentSelectionState.loyaltySuccess);
      check(viewModel.errorMessage).isNull();
      verify(() => mockLoyalty(type: 'subscription', id: 43)).called(1);
    });

    test('subscribeAndPay subscription failure', () async {
      when(() => mockSubscribe('99')).thenAnswer(
        (_) async => Result<Subscription, Failure>.failure(
          const ValidationFailure(
            AppErrorCode.validationFailed,
            'Plan not found',
          ),
        ),
      );

      await viewModel.subscribeAndPay(
        planId: '99',
        amount: 100.0,
        provider: 'konnect',
        description: 'desc',
      );

      check(viewModel.state).equals(PaymentSelectionState.failed);
      check(viewModel.errorMessage).equals('Plan not found');
    });

    test('reset returns to idle', () async {
      final sub = testSubscription();
      when(
        () => mockSubscribe('3'),
      ).thenAnswer((_) async => Result<Subscription, Failure>.success(sub));
      when(
        () => mockLoyalty(
          type: 'subscription',
          id: any(named: 'id'),
        ),
      ).thenAnswer(
        (_) async =>
            Result<Map<String, dynamic>, Failure>.success({'status': 'paid'}),
      );

      await viewModel.subscribeAndPay(
        planId: '3',
        amount: 100.0,
        provider: 'loyalty',
        description: 'desc',
      );
      check(viewModel.state).equals(PaymentSelectionState.loyaltySuccess);

      viewModel.reset();
      check(viewModel.state).equals(PaymentSelectionState.idle);
      check(viewModel.errorMessage).isNull();
      check(viewModel.isProcessing).isFalse();
    });

    test('verifyPayment sets verified on paid status', () async {
      final sub = testSubscription();
      when(
        () => mockSubscribe('3'),
      ).thenAnswer((_) async => Result<Subscription, Failure>.success(sub));
      when(
        () => mockPaymentRepository.initiatePayment(
          amount: any(named: 'amount'),
          provider: any(named: 'provider'),
          description: any(named: 'description'),
          type: any(named: 'type'),
          subscriptionId: any(named: 'subscriptionId'),
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

      await viewModel.subscribeAndPay(
        planId: '3',
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
