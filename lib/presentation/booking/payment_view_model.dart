import 'dart:developer' as developer;

import 'package:bourgo_arena_mobile/domain/repositories/reservation_repository.dart';
import 'package:flutter/material.dart';

/// Loading state for payment flow.
enum PaymentState { idle, initiating, awaitingVerification, verified, failed }

/// ViewModel managing the payment initiation and verification flow.
class PaymentViewModel extends ChangeNotifier {
  final ReservationRepository _reservationRepository;
  final String reservationId;

  PaymentState _state = PaymentState.idle;
  String? _paymentUrl;
  String? _paymentId;
  String? _errorMessage;
  String? _paymentStatus;

  /// Creates a new [PaymentViewModel].
  PaymentViewModel({
    required ReservationRepository reservationRepository,
    required this.reservationId,
  }) : _reservationRepository = reservationRepository;

  /// Current payment flow state.
  PaymentState get state => _state;

  /// URL to open in a browser for payment.
  String? get paymentUrl => _paymentUrl;

  /// Payment reference ID returned by the gateway.
  String? get paymentId => _paymentId;

  /// Error message if any step failed.
  String? get errorMessage => _errorMessage;

  /// Final payment status returned by verification.
  String? get paymentStatus => _paymentStatus;

  /// Initiates the payment process via POST /reservations/{id}/payment/initiate.
  Future<void> initiatePayment() async {
    _state = PaymentState.initiating;
    _errorMessage = null;
    notifyListeners();

    final result = await _reservationRepository.initiatePayment(
      reservationId,
    );

    result.when(
      success: (data) {
        _paymentUrl = data['payment_url'] as String? ?? data['url'] as String?;
        _paymentId =
            data['payment_id'] as String? ?? data['reference'] as String?;
        _state = PaymentState.awaitingVerification;
        developer.log(
          'PaymentViewModel: initiated url=$_paymentUrl id=$_paymentId',
        );
      },
      failure: (failure) {
        developer.log('PaymentViewModel: initiate failed ${failure.message}');
        _errorMessage = failure.message;
        _state = PaymentState.failed;
      },
    );
    notifyListeners();
  }

  /// Verifies the payment status after the user returns from the gateway.
  Future<void> verifyPayment() async {
    if (_paymentId == null) return;
    _state = PaymentState.awaitingVerification;
    notifyListeners();

    final result = await _reservationRepository.verifyPayment(
      reservationId,
      _paymentId!,
    );

    result.when(
      success: (status) {
        _paymentStatus = status;
        _state = status == 'paid' ? PaymentState.verified : PaymentState.failed;
      },
      failure: (failure) {
        developer.log('PaymentViewModel: verify failed ${failure.message}');
        _errorMessage = failure.message;
        _state = PaymentState.failed;
      },
    );
    notifyListeners();
  }
}
