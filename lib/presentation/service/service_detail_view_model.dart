import 'package:bourgo_arena_mobile/core/base/base_view_model.dart';
import 'package:bourgo_arena_mobile/core/utils/result.dart';
import 'package:bourgo_arena_mobile/domain/core/failure.dart';
import 'package:bourgo_arena_mobile/domain/entities/service.dart';
import 'package:bourgo_arena_mobile/domain/usecases/service/get_service_details_use_case.dart';

/// ViewModel for the service detail screen.
///
/// Loads and exposes service information, session availability,
/// and handles booking initiation.
class ServiceDetailViewModel extends BaseViewModel {
  final GetServiceDetailsUseCase _getServiceDetailsUseCase;

  ServiceDetailViewModel({
    required GetServiceDetailsUseCase getServiceDetailsUseCase,
  }) : _getServiceDetailsUseCase = getServiceDetailsUseCase;

  Service? _service;
  bool _isLoading = false;

  Service? get service => _service;
  bool get isLoading => _isLoading;

  void setService(Service s) {
    _service = s;
    notifyListeners();
  }

  Future<void> loadService(int serviceId) async {
    _isLoading = true;
    clearError();
    notifyListeners();

    final result = await _getServiceDetailsUseCase(serviceId);

    if (result is Success<Service, Failure>) {
      _service = result.data;
    } else if (result is FailureResult<Service, Failure>) {
      setErrorMessage(result.failure.message);
    }

    _isLoading = false;
    notifyListeners();
  }
}
