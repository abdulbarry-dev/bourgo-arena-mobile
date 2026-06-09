import 'package:bourgo_arena_mobile/core/base/base_view_model.dart';
import 'package:bourgo_arena_mobile/core/utils/result.dart';
import 'package:bourgo_arena_mobile/domain/core/failure.dart';
import 'package:bourgo_arena_mobile/domain/entities/activity.dart';
import 'package:bourgo_arena_mobile/domain/entities/reservation.dart';
import 'package:bourgo_arena_mobile/domain/usecases/activity/get_activities_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/booking/get_user_bookings_use_case.dart';
import 'package:bourgo_arena_mobile/presentation/auth/auth_state_notifier.dart';
import 'dart:developer' as developer;

/// ViewModel for the Activities screen.
class ActivitiesViewModel extends BaseViewModel {
  final GetActivitiesUseCase _getActivitiesUseCase;
  final GetUserBookingsUseCase _getUserBookingsUseCase;
  final AuthStateNotifier _authStateNotifier;

  List<Activity> _activities = [];
  List<Reservation> _reservations = [];
  bool _isLoading = false;

  /// Creates a new [ActivitiesViewModel] instance.
  ActivitiesViewModel({
    required GetActivitiesUseCase getActivitiesUseCase,
    required GetUserBookingsUseCase getUserBookingsUseCase,
    required AuthStateNotifier authStateNotifier,
  }) : _getActivitiesUseCase = getActivitiesUseCase,
       _getUserBookingsUseCase = getUserBookingsUseCase,
       _authStateNotifier = authStateNotifier;

  /// List of all activities.
  List<Activity> get activities => _activities;

  /// List of activities categorized as sports (training, technique, conditioning).
  List<Activity> get sports => _activities.where((a) => _isSport(a)).toList();

  /// List of activities categorized as well-being (recovery, mobility, mindfulness).
  List<Activity> get wellbeing =>
      _activities.where((a) => !_isSport(a)).toList();

  static const _sportFeatures = {
    'coaching',
    'technique',
    'conditioning',
    'high-intensity',
    'pad-work',
    'court-hire',
    'equipment',
    'cardio',
  };

  bool _isSport(Activity a) {
    if (a.features.isEmpty) {
      final lower = '${a.title} ${a.description}'.toLowerCase();
      return lower.contains('sport') ||
          lower.contains('football') ||
          lower.contains('padel') ||
          lower.contains('tennis') ||
          lower.contains('boxing') ||
          lower.contains('training');
    }
    return a.features.any((f) => _sportFeatures.contains(f.toLowerCase()));
  }

  /// List of user's reservations.
  List<Reservation> get reservations => _reservations;

  /// Whether the data is being loaded.
  bool get isLoading => _isLoading;

  /// Loads all activities and user bookings if authenticated.
  Future<void> loadData() async {
    developer.log('ActivitiesViewModel: loadData() started');
    _isLoading = true;
    clearError();
    notifyListeners();

    try {
      final activitiesResult = await _getActivitiesUseCase();

      // Critical check: Activities are essential for the screen
      if (activitiesResult is Success<List<Activity>, Failure>) {
        _activities = activitiesResult.data;
      } else {
        developer.log('ActivitiesViewModel: activities load failed');
        setErrorMessage('activities_loading_failed');
        _isLoading = false;
        notifyListeners();
        return;
      }

      if (_authStateNotifier.isAuthenticated) {
        final bookingsResult = await _getUserBookingsUseCase();
        bookingsResult.when(
          success: (data) => _reservations = data,
          failure: (failure) => developer.log(
            'ActivitiesViewModel: Error loading bookings: ${failure.message}',
          ),
        );
      }

      developer.log(
        'ActivitiesViewModel: loadData() finished, activities=${_activities.length}, reservations=${_reservations.length}',
      );
    } catch (e, stack) {
      developer.log(
        'ActivitiesViewModel: Error loading data: $e',
        error: e,
        stackTrace: stack,
      );
      setErrorMessage('loading_failed');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
