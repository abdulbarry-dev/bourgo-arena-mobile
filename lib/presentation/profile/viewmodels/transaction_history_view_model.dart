import 'package:bourgo_arena_mobile/domain/entities/payment.dart';
import 'package:bourgo_arena_mobile/domain/usecases/payment/get_full_payment_history_use_case.dart';
import 'package:flutter/material.dart';

enum HistoryTab { all, reservations, subscriptions }

class PaymentHistoryViewModel extends ChangeNotifier {
  final GetFullPaymentHistoryUseCase _getPaymentHistoryUseCase;

  List<Payment> _payments = [];
  bool _isLoading = false;
  String? _errorMessage;
  HistoryTab _selectedTab = HistoryTab.all;

  List<Payment> get payments => List.unmodifiable(_payments);
  List<Payment> get reservationPayments =>
      _payments.where((p) => p.type.toLowerCase() == 'reservation').toList();
  List<Payment> get subscriptionPayments =>
      _payments.where((p) => p.type.toLowerCase() == 'subscription').toList();
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  HistoryTab get selectedTab => _selectedTab;

  PaymentHistoryViewModel(this._getPaymentHistoryUseCase);

  void selectTab(HistoryTab tab) {
    _selectedTab = tab;
    notifyListeners();
  }

  Future<void> loadTransactions() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final paymentResult = await _getPaymentHistoryUseCase.execute();
    paymentResult.when(
      success: (payments) {
        _payments = payments;
      },
      failure: (failure) {
        _errorMessage = failure.message;
      },
    );

    _isLoading = false;
    notifyListeners();
  }
}
