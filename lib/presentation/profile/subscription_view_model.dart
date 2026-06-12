import 'package:bourgo_arena_mobile/core/utils/result.dart';
import 'package:bourgo_arena_mobile/core/base/base_view_model.dart';
import 'package:bourgo_arena_mobile/domain/core/failure.dart';
import 'package:bourgo_arena_mobile/domain/entities/child_profile.dart';
import 'package:bourgo_arena_mobile/domain/entities/subscription.dart';
import 'package:bourgo_arena_mobile/domain/usecases/family/get_children_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/subscription/get_active_subscriptions_use_case.dart';
import 'dart:developer' as developer;

class MemberSubscription {
  final Subscription subscription;

  const MemberSubscription({required this.subscription});
}

class SubscriptionViewModel extends BaseViewModel {
  final GetActiveSubscriptionsUseCase _getActiveSubscriptionsUseCase;
  final GetChildrenUseCase _getChildrenUseCase;

  List<MemberSubscription> _memberSubscriptions = [];
  bool _isLoading = false;

  List<MemberSubscription> get memberSubscriptions => _memberSubscriptions;
  bool get isLoading => _isLoading;

  SubscriptionViewModel({
    required GetActiveSubscriptionsUseCase getActiveSubscriptionsUseCase,
    required GetChildrenUseCase getChildrenUseCase,
  }) : _getActiveSubscriptionsUseCase = getActiveSubscriptionsUseCase,
       _getChildrenUseCase = getChildrenUseCase {
    loadSubscription();
  }

  Future<void> loadSubscription() async {
    _isLoading = true;
    clearError();
    notifyListeners();

    try {
      final results = await Future.wait([
        _getActiveSubscriptionsUseCase.execute(),
        _getChildrenUseCase.execute(),
      ]);

      final subResult = results[0] as Result<List<Subscription>, Failure>;
      final childrenResult = results[1] as Result<List<ChildProfile>, Failure>;

      await subResult.when(
        success: (data) {
          Set<String> childSubIds = {};
          childrenResult.when(
            success: (children) {
              for (final child in children) {
                if (child.hasActiveSubscription &&
                    child.activeSubscription != null) {
                  childSubIds.add(child.activeSubscription!.id);
                }
              }
            },
            failure: (_) {},
          );

          _memberSubscriptions = data
              .where((sub) => !childSubIds.contains(sub.id))
              .map((sub) => MemberSubscription(subscription: sub))
              .toList();
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
