import 'package:bourgo_arena_mobile/core/base/base_view_model.dart';
import 'package:bourgo_arena_mobile/domain/entities/plan.dart';
import 'package:bourgo_arena_mobile/domain/usecases/subscription/get_plans_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/subscription/get_active_subscriptions_use_case.dart';

class PlansViewModel extends BaseViewModel {
  final GetPlansUseCase _getPlansUseCase;
  final GetActiveSubscriptionsUseCase _getActiveSubscriptionsUseCase;

  bool _isLoading = false;
  List<Plan> _plans = [];
  Set<String> _activePlanIds = {};

  PlansViewModel({
    required GetPlansUseCase getPlansUseCase,
    required GetActiveSubscriptionsUseCase getActiveSubscriptionsUseCase,
  }) : _getPlansUseCase = getPlansUseCase,
       _getActiveSubscriptionsUseCase = getActiveSubscriptionsUseCase {
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
      final results = await Future.wait([
        _getPlansUseCase(),
        _getActiveSubscriptionsUseCase.execute(),
      ]);

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
