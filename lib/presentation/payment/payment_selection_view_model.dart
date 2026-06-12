import 'package:bourgo_arena_mobile/domain/core/failure.dart';
import 'package:bourgo_arena_mobile/domain/entities/subscription.dart';
import 'package:bourgo_arena_mobile/domain/repositories/payment_repository.dart';
import 'package:bourgo_arena_mobile/domain/usecases/subscription/subscribe_to_plan_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/loyalty/pay_with_loyalty_use_case.dart';
import 'package:flutter/foundation.dart';

enum PaymentSelectionState {
  idle,
  subscribing,
  initiating,
  awaitingVerification,
  verified,
  loyaltyPaying,
  loyaltySuccess,
  failed,
}

class PaymentSelectionViewModel extends ChangeNotifier {
  final PaymentRepository _paymentRepository;
  final SubscribeToPlanUseCase _subscribeToPlanUseCase;
  final PayWithLoyaltyUseCase _payWithLoyaltyUseCase;

  PaymentSelectionState _state = PaymentSelectionState.idle;
  String? _errorMessage;
  String? _paymentUrl;
  String? _paymentReference;
  int? _subscriptionId;
  bool _isProcessing = false;

  PaymentSelectionViewModel({
    required PaymentRepository paymentRepository,
    required SubscribeToPlanUseCase subscribeToPlanUseCase,
    required PayWithLoyaltyUseCase payWithLoyaltyUseCase,
  }) : _paymentRepository = paymentRepository,
       _subscribeToPlanUseCase = subscribeToPlanUseCase,
       _payWithLoyaltyUseCase = payWithLoyaltyUseCase;

  PaymentSelectionState get state => _state;
  String? get errorMessage => _errorMessage;
  String? get paymentUrl => _paymentUrl;
  bool get isProcessing => _isProcessing;

  bool _isChildOnlyPlanError(Failure failure) {
    if (failure is! ValidationFailure) return false;
    final msg = failure.message.toLowerCase();
    return msg.contains('children only') || msg.contains('child only');
  }

  Future<void> subscribeAndPay({
    required String planId,
    required double amount,
    required String provider,
    String? description,
  }) async {
    if (_isProcessing) return;
    _isProcessing = true;

    _state = PaymentSelectionState.subscribing;
    _errorMessage = null;
    notifyListeners();

    final subResult = await _subscribeToPlanUseCase(planId);

    final subscription = subResult.fold<Subscription?>(
      onSuccess: (sub) => sub,
      onFailure: (failure) {
        if (_isChildOnlyPlanError(failure)) {
          _errorMessage = 'This plan is for children only. Please go back and select a child.';
        } else {
          _errorMessage = failure.message;
        }
        _state = PaymentSelectionState.failed;
        _isProcessing = false;
        notifyListeners();
        return null;
      },
    );

    if (subscription == null) return;

    _subscriptionId = int.tryParse(subscription.id);
    if (provider == 'loyalty') {
      await _payWithLoyalty(amount: amount, description: description);
    } else {
      await _initiateKonnectPayment(amount: amount, description: description);
    }
  }

  Future<void> _payWithLoyalty({
    required double amount,
    String? description,
  }) async {
    if (_subscriptionId == null) {
      _errorMessage = 'Missing subscription ID for loyalty payment.';
      _state = PaymentSelectionState.failed;
      _isProcessing = false;
      notifyListeners();
      return;
    }

    _state = PaymentSelectionState.loyaltyPaying;
    notifyListeners();

    final result = await _payWithLoyaltyUseCase(
      type: 'subscription',
      id: _subscriptionId!,
    );

    result.fold(
      onSuccess: (data) {
        _state = PaymentSelectionState.loyaltySuccess;
        _isProcessing = false;
        notifyListeners();
      },
      onFailure: (failure) {
        _errorMessage = failure.message;
        _state = PaymentSelectionState.failed;
        _isProcessing = false;
        notifyListeners();
      },
    );
  }

  Future<void> _initiateKonnectPayment({
    required double amount,
    String? description,
  }) async {
    _state = PaymentSelectionState.initiating;
    notifyListeners();

    final result = await _paymentRepository.initiatePayment(
      amount: amount,
      provider: 'konnect',
      description: description,
      type: 'subscription',
      subscriptionId: _subscriptionId,
      successUrl: 'bourgo://payment/success',
      failureUrl: 'bourgo://payment/failure',
    );

    result.fold(
      onSuccess: (data) {
        _paymentUrl = data['payment_url'] as String?;
        _paymentReference = data['payment_reference'] as String?;
        _state = PaymentSelectionState.awaitingVerification;
        _isProcessing = false;
        notifyListeners();
      },
      onFailure: (failure) async {
        if (failure.message.toLowerCase().contains(
          'credentials not configured',
        )) {
          final retryResult = await _paymentRepository.initiatePayment(
            amount: amount,
            provider: 'test',
            description: description,
            type: 'subscription',
            subscriptionId: _subscriptionId,
            successUrl: 'bourgo://payment/success',
            failureUrl: 'bourgo://payment/failure',
          );

          retryResult.fold(
            onSuccess: (retryData) {
              _paymentUrl = retryData['payment_url'] as String?;
              _paymentReference = retryData['payment_reference'] as String?;
              _state = PaymentSelectionState.awaitingVerification;
              _isProcessing = false;
              notifyListeners();
            },
            onFailure: (retryFailure) {
              _errorMessage = retryFailure.message;
              _state = PaymentSelectionState.failed;
              _isProcessing = false;
              notifyListeners();
            },
          );
        } else {
          _errorMessage = failure.message;
          _state = PaymentSelectionState.failed;
          _isProcessing = false;
          notifyListeners();
        }
      },
    );
  }

  Future<void> verifyPayment() async {
    if (_paymentReference == null) {
      _errorMessage = 'Missing payment reference for verification.';
      _state = PaymentSelectionState.failed;
      notifyListeners();
      return;
    }

    _state = PaymentSelectionState.awaitingVerification;
    notifyListeners();

    final result = await _paymentRepository.verifyPayment(
      paymentReference: _paymentReference,
    );

    result.fold(
      onSuccess: (data) {
        final status = data['status'];
        if (status == 'paid') {
          _state = PaymentSelectionState.verified;
        } else {
          _errorMessage = 'Payment was not successful. Status: $status';
          _state = PaymentSelectionState.failed;
        }
      },
      onFailure: (failure) {
        _errorMessage = failure.message;
        _state = PaymentSelectionState.failed;
      },
    );

    notifyListeners();
  }

  void reset() {
    _state = PaymentSelectionState.idle;
    _errorMessage = null;
    _paymentUrl = null;
    _paymentReference = null;
    _subscriptionId = null;
    _isProcessing = false;
    notifyListeners();
  }
}
