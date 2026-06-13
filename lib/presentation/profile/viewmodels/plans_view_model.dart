import 'package:bourgo_arena_mobile/core/base/base_view_model.dart';
import 'package:bourgo_arena_mobile/domain/entities/plan.dart';
import 'package:bourgo_arena_mobile/domain/usecases/subscription/get_plans_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/subscription/get_active_subscriptions_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/family/get_child_subscriptions_use_case.dart';
import 'package:bourgo_arena_mobile/domain/core/failure.dart';
import 'package:bourgo_arena_mobile/core/utils/result.dart';

class PlansViewModel extends BaseViewModel {
  final GetPlansUseCase _getPlansUseCase;
  final GetActiveSubscriptionsUseCase _getActiveSubscriptionsUseCase;
  final GetChildSubscriptionsUseCase? _getChildSubscriptionsUseCase;
  final String? childId;

  bool _isLoading = false;
  List<Plan> _plans = [];
  Set<String> _activePlanIds = {};

  PlansViewModel({
    required GetPlansUseCase getPlansUseCase,
    required GetActiveSubscriptionsUseCase getActiveSubscriptionsUseCase,
    GetChildSubscriptionsUseCase? getChildSubscriptionsUseCase,
    this.childId,
  }) : _getPlansUseCase = getPlansUseCase,
       _getActiveSubscriptionsUseCase = getActiveSubscriptionsUseCase,
       _getChildSubscriptionsUseCase = getChildSubscriptionsUseCase {
    loadPlans();
  }

  bool get isLoading => _isLoading;
  List<Plan> get plans => _plans;
  Set<String> get activePlanIds => _activePlanIds;

  Map<String, String> get availableServices {
    final services = <String, String>{};
    for (final plan in _plans) {
      if (plan.service != null) {
        services[plan.service!.id] = plan.service!.name ?? '';
      }
    }
    return services;
  }

  bool isPlanActive(String planId) => _activePlanIds.contains(planId);

  Future<void> loadPlans() async {
    _isLoading = true;
    clearError();
    notifyListeners();

    try {
      final Future<Result<dynamic, Failure>> subsFuture;
      final cid = childId;
      final getChildSubs = _getChildSubscriptionsUseCase;
      if (cid != null && getChildSubs != null) {
        subsFuture = getChildSubs(childId: cid).then(
          (res) => res.fold(
            onSuccess: (paginated) => Result.success(paginated.data),
            onFailure: (f) => FailureResult(f),
          ),
        );
      } else {
        subsFuture = _getActiveSubscriptionsUseCase.execute().then(
          (res) => res.fold(
            onSuccess: (list) => Result.success(list),
            onFailure: (f) => FailureResult(f),
          ),
        );
      }

      final results = await Future.wait([_getPlansUseCase(), subsFuture]);

      final plansResult = results[0];
      final subsResult = results[1];

      plansResult.when(
        success: (plansData) {
          _plans = plansData as List<Plan>;
        },
        failure: (failure) {
          setErrorMessage((failure as dynamic).message);
        },
      );

      subsResult.when(
        success: (subsData) {
          _activePlanIds = (subsData as List<dynamic>)
              .where(
                (sub) =>
                    sub.plan != null && sub.status.toLowerCase() == 'active',
              )
              .map((sub) => sub.plan!.id.toString())
              .toSet();
        },
        failure: (_) {},
      );
    } catch (e) {
      setErrorMessage(e.toString());
    }

    _isLoading = false;
    notifyListeners();
  }
}
