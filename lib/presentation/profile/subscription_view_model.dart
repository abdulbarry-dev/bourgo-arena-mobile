import 'package:bourgo_arena_mobile/core/base/base_view_model.dart';
import 'package:bourgo_arena_mobile/domain/entities/subscription.dart';
import 'package:bourgo_arena_mobile/domain/usecases/subscription/get_active_subscription_use_case.dart';
import 'dart:developer' as developer;

/// ViewModel for the Subscription screen.
class SubscriptionViewModel extends BaseViewModel {
  final GetActiveSubscriptionUseCase _getActiveSubscriptionUseCase;

  Subscription? _subscription;
  bool _isLoading = false;

  Subscription? get subscription => _subscription;
  bool get isLoading => _isLoading;

  SubscriptionViewModel({
    required GetActiveSubscriptionUseCase getActiveSubscriptionUseCase,
  }) : _getActiveSubscriptionUseCase = getActiveSubscriptionUseCase {
    loadSubscription();
  }

  Future<void> loadSubscription() async {
    _isLoading = true;
    clearError();
    notifyListeners();

    try {
      final result = await _getActiveSubscriptionUseCase.execute();
      result.when(
        success: (data) {
          _subscription = data;
        },
        failure: (failure) {
          setErrorMessage(failure.message);
          developer.log('Error loading subscription: ${failure.message}');
        },
      );
    } catch (e, stackTrace) {
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
