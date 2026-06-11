import 'package:bourgo_arena_mobile/core/base/base_view_model.dart';
import 'package:bourgo_arena_mobile/domain/entities/child_profile.dart';
import 'package:bourgo_arena_mobile/domain/usecases/family/get_child_profile_use_case.dart';
import 'dart:developer' as developer;

class ChildProfileViewModel extends BaseViewModel {
  final GetChildProfileUseCase _getChildProfileUseCase;

  ChildProfile? _profile;
  bool _isLoading = false;

  ChildProfileViewModel({
    required GetChildProfileUseCase getChildProfileUseCase,
  }) : _getChildProfileUseCase = getChildProfileUseCase;

  ChildProfile? get profile => _profile;
  bool get isLoading => _isLoading;

  Future<void> load(String childId) async {
    _isLoading = true;
    notifyListeners();

    try {
      final result = await _getChildProfileUseCase(childId);
      result.when(
        success: (profile) {
          _profile = profile;
          clearError();
        },
        failure: (failure) {
          setErrorMessage(failure.message);
          developer.log('Failed to load child profile: ${failure.message}');
        },
      );
    } catch (e) {
      setErrorMessage('An unexpected error occurred');
      developer.log('Error loading child profile: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
