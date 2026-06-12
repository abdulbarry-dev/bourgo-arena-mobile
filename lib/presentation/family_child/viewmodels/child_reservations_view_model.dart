import 'package:bourgo_arena_mobile/core/base/base_view_model.dart';
import 'package:bourgo_arena_mobile/domain/core/paginated_result.dart';
import 'package:bourgo_arena_mobile/domain/entities/reservation.dart';
import 'package:bourgo_arena_mobile/domain/usecases/family/get_child_reservations_use_case.dart';
import 'dart:developer' as developer;

class ChildReservationsViewModel extends BaseViewModel {
  final GetChildReservationsUseCase _getChildReservationsUseCase;

  List<Reservation> _reservations = [];
  bool _isLoading = false;
  bool _isLoadingMore = false;
  int _currentPage = 1;
  String _filter = 'all';
  String _childId = '';
  PaginatedResult<Reservation>? _pagination;

  ChildReservationsViewModel({
    required GetChildReservationsUseCase getChildReservationsUseCase,
  }) : _getChildReservationsUseCase = getChildReservationsUseCase;

  List<Reservation> get reservations => _reservations;
  bool get isLoading => _isLoading;
  bool get isLoadingMore => _isLoadingMore;
  String get filter => _filter;
  bool get hasMore => _pagination?.hasMore ?? false;

  Future<void> load({required String childId, String filter = 'all'}) async {
    _childId = childId;
    _filter = filter;
    _isLoading = true;
    _currentPage = 1;
    _reservations = [];
    notifyListeners();

    try {
      final result = await _getChildReservationsUseCase(
        childId: childId,
        filter: filter,
      );
      result.when(
        success: (paginated) {
          _reservations = paginated.data;
          _pagination = paginated;
          _currentPage = paginated.currentPage;
          clearError();
        },
        failure: (failure) {
          setErrorMessage(failure.message);
          developer.log(
            'Failed to load child reservations: ${failure.message}',
          );
        },
      );
    } catch (e) {
      setErrorMessage('An unexpected error occurred');
      developer.log('Error loading child reservations: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadMore() async {
    if (_isLoadingMore || !hasMore) return;
    _isLoadingMore = true;
    notifyListeners();

    try {
      final result = await _getChildReservationsUseCase(
        childId: _childId,
        filter: _filter,
        page: _currentPage + 1,
      );
      result.when(
        success: (paginated) {
          _reservations.addAll(paginated.data);
          _pagination = paginated;
          _currentPage = paginated.currentPage;
        },
        failure: (failure) {
          developer.log('Failed to load more reservations: ${failure.message}');
        },
      );
    } catch (e) {
      developer.log('Error loading more reservations: $e');
    } finally {
      _isLoadingMore = false;
      notifyListeners();
    }
  }
}
