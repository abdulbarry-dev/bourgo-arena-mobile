import 'package:bourgo_arena_mobile/domain/repositories/payment_repository.dart';
import 'package:bourgo_arena_mobile/core/di/locator.dart';
import 'package:bourgo_arena_mobile/presentation/auth/auth_state_notifier.dart';
import 'package:flutter/foundation.dart';

enum PaymentSelectionState {
  idle,
  initiating,
  awaitingVerification,
  verified,
  failed,
}

class PaymentSelectionViewModel extends ChangeNotifier {
  final PaymentRepository paymentRepository;

  PaymentSelectionState _state = PaymentSelectionState.idle;
  String? _errorMessage;
  String? _paymentUrl;
  String? _paymentReference;

  PaymentSelectionViewModel({required this.paymentRepository});

  PaymentSelectionState get state => _state;
  String? get errorMessage => _errorMessage;
  String? get paymentUrl => _paymentUrl;

  Future<void> initiatePayment({
    required double amount,
    required String provider,
    String? description,
  }) async {
    _state = PaymentSelectionState.initiating;
    _errorMessage = null;
    notifyListeners();

    final result = await paymentRepository.initiatePayment(
      amount: amount,
      provider: provider,
      description: description,
      successUrl: 'bourgo://payment/success',
      failureUrl: 'bourgo://payment/failure',
    );

    result.fold(
      onSuccess: (data) {
        _paymentUrl = data['payment_url'] as String?;
        _paymentReference = data['payment_reference'] as String?;
        _state = PaymentSelectionState.awaitingVerification;
        notifyListeners();
      },
      onFailure: (failure) async {
        if (failure.message.toLowerCase().contains(
          'credentials not configured',
        )) {
          // Fallback to sandbox test provider
          final retryResult = await paymentRepository.initiatePayment(
            amount: amount,
            provider: 'test',
            description: description,
            successUrl: 'bourgo://payment/success',
            failureUrl: 'bourgo://payment/failure',
          );

          retryResult.fold(
            onSuccess: (retryData) {
              _paymentUrl = retryData['payment_url'] as String?;
              _paymentReference = retryData['payment_reference'] as String?;
              _state = PaymentSelectionState.awaitingVerification;
              notifyListeners();
            },
            onFailure: (retryFailure) {
              _errorMessage = retryFailure.message;
              _state = PaymentSelectionState.failed;
              notifyListeners();
            },
          );
        } else {
          _errorMessage = failure.message;
          _state = PaymentSelectionState.failed;
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

    final result = await paymentRepository.verifyPayment(
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
    notifyListeners();
  }
}
