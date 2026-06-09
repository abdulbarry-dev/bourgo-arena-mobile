import 'package:bourgo_arena_mobile/core/base/base_view_model.dart';
import 'package:bourgo_arena_mobile/domain/entities/subscription.dart';
import 'package:bourgo_arena_mobile/domain/usecases/subscription/get_active_subscriptions_use_case.dart';
import 'dart:developer' as developer;

/// ViewModel for the Subscription screen.
class SubscriptionViewModel extends BaseViewModel {
  final GetActiveSubscriptionsUseCase _getActiveSubscriptionsUseCase;

  Subscription? _subscription;
  bool _isLoading = false;

  Subscription? get subscription => _subscription;
  bool get isLoading => _isLoading;

  SubscriptionViewModel({
    required GetActiveSubscriptionsUseCase getActiveSubscriptionsUseCase,
  }) : _getActiveSubscriptionsUseCase = getActiveSubscriptionsUseCase {
    loadSubscription();
  }

  Future<void> loadSubscription() async {
    _isLoading = true;
    clearError();
    notifyListeners();

    try {
      final result = await _getActiveSubscriptionsUseCase.execute();
      result.when(
        success: (data) {
          _subscription = data.firstOrNull;
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
      setErrorMessage(e.toString());
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
