import 'package:bourgo_arena_mobile/core/base/base_view_model.dart';
import 'package:bourgo_arena_mobile/domain/entities/child_profile.dart';
import 'package:bourgo_arena_mobile/domain/entities/subscription.dart';
import 'package:bourgo_arena_mobile/domain/usecases/family/get_child_subscriptions_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/family/get_children_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/subscription/get_active_subscriptions_use_case.dart';
import 'dart:developer' as developer;

class MemberSubscription {
  final Subscription subscription;
  final String? childId;
  final String? childName;

  const MemberSubscription({
    required this.subscription,
    this.childId,
    this.childName,
  });

  bool get isOwn => childId == null;
}

class SubscriptionViewModel extends BaseViewModel {
  final GetActiveSubscriptionsUseCase _getActiveSubscriptionsUseCase;
  final GetChildrenUseCase _getChildrenUseCase;
  final GetChildSubscriptionsUseCase _getChildSubscriptionsUseCase;

  List<MemberSubscription> _memberSubscriptions = [];
  bool _isLoading = false;

  List<MemberSubscription> get memberSubscriptions => _memberSubscriptions;
  bool get isLoading => _isLoading;

  SubscriptionViewModel({
    required GetActiveSubscriptionsUseCase getActiveSubscriptionsUseCase,
    required GetChildrenUseCase getChildrenUseCase,
    required GetChildSubscriptionsUseCase getChildSubscriptionsUseCase,
  })  : _getActiveSubscriptionsUseCase = getActiveSubscriptionsUseCase,
        _getChildrenUseCase = getChildrenUseCase,
        _getChildSubscriptionsUseCase = getChildSubscriptionsUseCase {
    loadSubscription();
  }

  Future<void> loadSubscription() async {
    _isLoading = true;
    clearError();
    notifyListeners();

    try {
      final result = await _getActiveSubscriptionsUseCase.execute();
      await result.when(
        success: (data) async {
          _memberSubscriptions = await _resolveOwnership(data);
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

  Future<List<MemberSubscription>> _resolveOwnership(
    List<Subscription> subscriptions,
  ) async {
    final childrenResult = await _getChildrenUseCase.execute();
    final children = childrenResult.when(success: (c) => c, failure: (_) => <ChildProfile>[]);

    final childSubIds = <String, ChildProfile>{};
    for (final child in children) {
      final subResult = await _getChildSubscriptionsUseCase.call(
        childId: child.id,
        perPage: 100,
      );
      subResult.when(success: (paginated) {
        for (final sub in paginated.data) {
          childSubIds[sub.id] = child;
        }
      }, failure: (_) {});
    }

    return [
      for (final sub in subscriptions)
        MemberSubscription(
          subscription: sub,
          childId: childSubIds[sub.id]?.id,
          childName: childSubIds[sub.id]?.name,
        ),
    ];
  }
}
