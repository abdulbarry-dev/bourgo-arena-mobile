import 'package:bourgo_arena_mobile/core/base/base_view_model.dart';
import 'package:bourgo_arena_mobile/domain/core/paginated_result.dart';
import 'package:bourgo_arena_mobile/domain/entities/completed_item.dart';
import 'package:bourgo_arena_mobile/domain/usecases/family/get_child_completed_items_use_case.dart';
import 'dart:developer' as developer;

class ChildCompletedViewModel extends BaseViewModel {
  final GetChildCompletedItemsUseCase _getChildCompletedItemsUseCase;

  List<CompletedItem> _items = [];
  bool _isLoading = false;
  PaginatedResult<CompletedItem>? _pagination;

  ChildCompletedViewModel({
    required GetChildCompletedItemsUseCase getChildCompletedItemsUseCase,
  }) : _getChildCompletedItemsUseCase = getChildCompletedItemsUseCase;

  List<CompletedItem> get items => _items;
  bool get isLoading => _isLoading;
  bool get hasMore => _pagination?.hasMore ?? false;

  Future<void> load(String childId) async {
    _isLoading = true;
    notifyListeners();

    try {
      final result = await _getChildCompletedItemsUseCase(childId: childId);
      result.when(
        success: (paginated) {
          _items = paginated.data;
          _pagination = paginated;
          clearError();
        },
        failure: (failure) {
          setErrorMessage(failure.message);
          developer.log('Failed to load completed items: ${failure.message}');
        },
      );
    } catch (e) {
      setErrorMessage('An unexpected error occurred');
      developer.log('Error loading completed items: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
