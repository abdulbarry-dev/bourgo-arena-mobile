import 'package:bourgo_arena_mobile/core/base/base_view_model.dart';
import 'package:bourgo_arena_mobile/domain/core/paginated_result.dart';
import 'package:bourgo_arena_mobile/domain/entities/child_booking.dart';
import 'package:bourgo_arena_mobile/domain/usecases/family/complete_child_booking_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/family/get_child_bookings_use_case.dart';
import 'dart:developer' as developer;

class ChildBookingsViewModel extends BaseViewModel {
  final GetChildBookingsUseCase _getChildBookingsUseCase;
  final CompleteChildBookingUseCase _completeChildBookingUseCase;

  List<ChildBooking> _bookings = [];
  bool _isLoading = false;
  bool _isLoadingMore = false;
  int _currentPage = 1;
  String _filter = 'all';
  String _childId = '';
  PaginatedResult<ChildBooking>? _pagination;

  ChildBookingsViewModel({
    required GetChildBookingsUseCase getChildBookingsUseCase,
    required CompleteChildBookingUseCase completeChildBookingUseCase,
  })  : _getChildBookingsUseCase = getChildBookingsUseCase,
        _completeChildBookingUseCase = completeChildBookingUseCase;

  List<ChildBooking> get bookings => _bookings;
  bool get isLoading => _isLoading;
  bool get isLoadingMore => _isLoadingMore;
  String get filter => _filter;
  bool get hasMore => _pagination?.hasMore ?? false;

  Future<void> load({
    required String childId,
    String filter = 'all',
  }) async {
    _childId = childId;
    _filter = filter;
    _isLoading = true;
    _currentPage = 1;
    _bookings = [];
    notifyListeners();

    try {
      final result = await _getChildBookingsUseCase(
        childId: childId,
        filter: filter,
      );
      result.when(
        success: (paginated) {
          _bookings = paginated.data;
          _pagination = paginated;
          _currentPage = paginated.currentPage;
          clearError();
        },
        failure: (failure) {
          setErrorMessage(failure.message);
          developer.log('Failed to load child bookings: ${failure.message}');
        },
      );
    } catch (e) {
      setErrorMessage('An unexpected error occurred');
      developer.log('Error loading child bookings: $e');
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
      final result = await _getChildBookingsUseCase(
        childId: _childId,
        filter: _filter,
        page: _currentPage + 1,
      );
      result.when(
        success: (paginated) {
          _bookings.addAll(paginated.data);
          _pagination = paginated;
          _currentPage = paginated.currentPage;
        },
        failure: (failure) {
          developer.log('Failed to load more bookings: ${failure.message}');
        },
      );
    } catch (e) {
      developer.log('Error loading more bookings: $e');
    } finally {
      _isLoadingMore = false;
      notifyListeners();
    }
  }

  Future<bool> markComplete({
    required String childId,
    required String bookingId,
  }) async {
    try {
      final result = await _completeChildBookingUseCase(
        childId: childId,
        bookingId: bookingId,
      );
      bool success = false;
      result.when(
        success: (updated) {
          final index = _bookings.indexWhere((b) => b.id == bookingId);
          if (index != -1) {
            _bookings[index] = updated;
          }
          success = true;
          clearError();
          notifyListeners();
        },
        failure: (failure) {
          setErrorMessage(failure.message);
          developer.log('Failed to complete booking: ${failure.message}');
        },
      );
      return success;
    } catch (e) {
      setErrorMessage('Failed to complete booking');
      developer.log('Error completing booking: $e');
      return false;
    }
  }
}
