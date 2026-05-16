import 'package:bourgo_arena_mobile/domain/entities/subscription.dart';
import 'package:bourgo_arena_mobile/domain/usecases/subscription/get_active_subscription_use_case.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as developer;

/// ViewModel for the Subscription screen.
class SubscriptionViewModel extends ChangeNotifier {
  final GetActiveSubscriptionUseCase _getActiveSubscriptionUseCase;

  Subscription? _subscription;
  bool _isLoading = false;
  String? _errorMessage;

  Subscription? get subscription => _subscription;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  SubscriptionViewModel({
    required GetActiveSubscriptionUseCase getActiveSubscriptionUseCase,
  }) : _getActiveSubscriptionUseCase = getActiveSubscriptionUseCase {
    loadSubscription();
  }

  Future<void> loadSubscription() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final result = await _getActiveSubscriptionUseCase.execute();
      result.when(
        success: (data) {
          _subscription = data;
        },
        failure: (failure) {
          _errorMessage = failure.message;
          developer.log('Error loading subscription: ${failure.message}');
        },
      );
    } catch (e, stackTrace) {
      _errorMessage = null;
      developer.log(
        'Error loading subscription',
        error: e,
        stackTrace: stackTrace,
      );
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
