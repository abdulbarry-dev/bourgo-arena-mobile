import 'package:bourgo_arena_mobile/core/base/base_view_model.dart';
import 'package:bourgo_arena_mobile/domain/core/paginated_result.dart';
import 'package:bourgo_arena_mobile/domain/entities/child_booking.dart';
import 'package:bourgo_arena_mobile/domain/entities/course.dart';
import 'package:bourgo_arena_mobile/domain/usecases/family/book_child_session_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/family/get_child_available_sessions_use_case.dart';
import 'dart:developer' as developer;

class ChildSessionsViewModel extends BaseViewModel {
  final GetChildAvailableSessionsUseCase _getChildAvailableSessionsUseCase;
  final BookChildSessionUseCase _bookChildSessionUseCase;

  List<CourseSession> _sessions = [];
  bool _isLoading = false;
  PaginatedResult<CourseSession>? _pagination;

  ChildSessionsViewModel({
    required GetChildAvailableSessionsUseCase getChildAvailableSessionsUseCase,
    required BookChildSessionUseCase bookChildSessionUseCase,
  })  : _getChildAvailableSessionsUseCase = getChildAvailableSessionsUseCase,
        _bookChildSessionUseCase = bookChildSessionUseCase;

  List<CourseSession> get sessions => _sessions;
  bool get isLoading => _isLoading;
  bool get hasMore => _pagination?.hasMore ?? false;

  Future<void> load(String childId) async {
    _isLoading = true;
    notifyListeners();

    try {
      final result = await _getChildAvailableSessionsUseCase(childId: childId);
      result.when(
        success: (paginated) {
          _sessions = paginated.data;
          _pagination = paginated;
          clearError();
        },
        failure: (failure) {
          setErrorMessage(failure.message);
          developer.log('Failed to load child sessions: ${failure.message}');
        },
      );
    } catch (e) {
      setErrorMessage('An unexpected error occurred');
      developer.log('Error loading child sessions: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<ChildBooking?> bookSession({
    required String childId,
    required String sessionId,
    required String date,
  }) async {
    try {
      final result = await _bookChildSessionUseCase(
        childId: childId,
        sessionId: sessionId,
        date: date,
      );
      ChildBooking? booking;
      result.when(
        success: (b) {
          booking = b;
          clearError();
        },
        failure: (failure) {
          setErrorMessage(failure.message);
          developer.log('Failed to book child session: ${failure.message}');
        },
      );
      return booking;
    } catch (e) {
      setErrorMessage('Failed to book session');
      developer.log('Error booking child session: $e');
      return null;
    }
  }
}
