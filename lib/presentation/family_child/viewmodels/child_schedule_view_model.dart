import 'package:bourgo_arena_mobile/core/base/base_view_model.dart';
import 'package:bourgo_arena_mobile/domain/entities/schedule_item.dart';
import 'package:bourgo_arena_mobile/domain/usecases/family/get_child_schedule_use_case.dart';
import 'dart:developer' as developer;

class ChildScheduleViewModel extends BaseViewModel {
  final GetChildScheduleUseCase _getChildScheduleUseCase;

  List<ScheduleItem> _items = [];
  bool _isLoading = false;

  ChildScheduleViewModel({
    required GetChildScheduleUseCase getChildScheduleUseCase,
  }) : _getChildScheduleUseCase = getChildScheduleUseCase;

  List<ScheduleItem> get items => _items;
  bool get isLoading => _isLoading;

  Future<void> load({
    required String childId,
    required String from,
    required String to,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      final result = await _getChildScheduleUseCase(
        childId: childId,
        from: from,
        to: to,
      );
      result.when(
        success: (items) {
          _items = items;
          clearError();
        },
        failure: (failure) {
          setErrorMessage(failure.message);
          developer.log('Failed to load child schedule: ${failure.message}');
        },
      );
    } catch (e) {
      setErrorMessage('An unexpected error occurred');
      developer.log('Error loading child schedule: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
