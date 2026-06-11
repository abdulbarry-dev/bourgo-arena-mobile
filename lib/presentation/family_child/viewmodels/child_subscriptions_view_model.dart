import 'package:bourgo_arena_mobile/core/base/base_view_model.dart';
import 'package:bourgo_arena_mobile/domain/core/paginated_result.dart';
import 'package:bourgo_arena_mobile/domain/entities/subscription.dart';
import 'package:bourgo_arena_mobile/domain/usecases/family/buy_child_subscription_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/family/get_child_subscriptions_use_case.dart';
import 'dart:developer' as developer;

class ChildSubscriptionsViewModel extends BaseViewModel {
  final GetChildSubscriptionsUseCase _getChildSubscriptionsUseCase;
  final BuyChildSubscriptionUseCase _buyChildSubscriptionUseCase;

  List<Subscription> _subscriptions = [];
  bool _isLoading = false;
  PaginatedResult<Subscription>? _pagination;

  ChildSubscriptionsViewModel({
    required GetChildSubscriptionsUseCase getChildSubscriptionsUseCase,
    required BuyChildSubscriptionUseCase buyChildSubscriptionUseCase,
  })  : _getChildSubscriptionsUseCase = getChildSubscriptionsUseCase,
        _buyChildSubscriptionUseCase = buyChildSubscriptionUseCase;

  List<Subscription> get subscriptions => _subscriptions;
  bool get isLoading => _isLoading;
  bool get hasMore => _pagination?.hasMore ?? false;

  Future<void> load(String childId) async {
    _isLoading = true;
    notifyListeners();

    try {
      final result = await _getChildSubscriptionsUseCase(
        childId: childId,
      );
      result.when(
        success: (paginated) {
          _subscriptions = paginated.data;
          _pagination = paginated;
          clearError();
        },
        failure: (failure) {
          setErrorMessage(failure.message);
          developer.log('Failed to load child subscriptions: ${failure.message}');
        },
      );
    } catch (e) {
      setErrorMessage('An unexpected error occurred');
      developer.log('Error loading child subscriptions: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<Subscription?> buySubscription({
    required String childId,
    required String planId,
    String? startsAt,
  }) async {
    try {
      final result = await _buyChildSubscriptionUseCase(
        childId: childId,
        planId: planId,
        startsAt: startsAt,
      );
      Subscription? subscription;
      result.when(
        success: (sub) {
          subscription = sub;
          clearError();
        },
        failure: (failure) {
          setErrorMessage(failure.message);
          developer.log('Failed to buy child subscription: ${failure.message}');
        },
      );
      return subscription;
    } catch (e) {
      setErrorMessage('Failed to buy subscription');
      developer.log('Error buying child subscription: $e');
      return null;
    }
  }
}
