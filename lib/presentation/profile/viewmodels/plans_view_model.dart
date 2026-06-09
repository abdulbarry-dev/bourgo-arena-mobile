import 'package:bourgo_arena_mobile/core/base/base_view_model.dart';
import 'package:bourgo_arena_mobile/domain/entities/plan.dart';
import 'package:bourgo_arena_mobile/domain/usecases/subscription/get_plans_use_case.dart';

class PlansViewModel extends BaseViewModel {
  final GetPlansUseCase _getPlansUseCase;

  bool _isLoading = false;
  List<Plan> _plans = [];

  PlansViewModel({required GetPlansUseCase getPlansUseCase})
    : _getPlansUseCase = getPlansUseCase {
    loadPlans();
  }

  bool get isLoading => _isLoading;
  List<Plan> get plans => _plans;

  Map<String, String> get availableServices {
    final services = <String, String>{};
    for (final plan in _plans) {
      if (plan.service != null) {
        services[plan.service!.id] = plan.service!.name ?? '';
      }
    }
    return services;
  }

  Future<void> loadPlans() async {
    _isLoading = true;
    clearError();
    notifyListeners();

    final result = await _getPlansUseCase();

    result.when(
      success: (plans) {
        _plans = plans;
      },
      failure: (failure) {
        setErrorMessage(failure.message);
      },
    );

    _isLoading = false;
    notifyListeners();
  }
}
