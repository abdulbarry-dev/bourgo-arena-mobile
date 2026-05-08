import 'package:bourgo_arena_mobile/core/utils/result.dart';
import 'package:bourgo_arena_mobile/domain/core/failure.dart';
import 'package:bourgo_arena_mobile/domain/entities/activity.dart';
import 'package:bourgo_arena_mobile/domain/entities/reservation.dart';
import 'package:bourgo_arena_mobile/domain/usecases/activity/get_activities_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/booking/get_user_bookings_use_case.dart';
import 'package:flutter/material.dart';

/// ViewModel for the Activities screen.
class ActivitiesViewModel extends ChangeNotifier {
  final GetActivitiesUseCase _getActivitiesUseCase;
  final GetUserBookingsUseCase _getUserBookingsUseCase;

  List<Activity> _activities = [];
  List<Reservation> _reservations = [];
  bool _isLoading = false;
  String? _error;

  /// Creates a new [ActivitiesViewModel] instance.
  ActivitiesViewModel({
    required GetActivitiesUseCase getActivitiesUseCase,
    required GetUserBookingsUseCase getUserBookingsUseCase,
  }) : _getActivitiesUseCase = getActivitiesUseCase,
       _getUserBookingsUseCase = getUserBookingsUseCase;

  /// List of all activities.
  List<Activity> get activities => _activities;

  /// List of user's reservations.
  List<Reservation> get reservations => _reservations;

  /// Whether the data is being loaded.
  bool get isLoading => _isLoading;

  /// Error message if any.
  String? get error => _error;

  /// Loads all activities and reservations.
  Future<void> loadData() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final results = await Future.wait([
        _getActivitiesUseCase(),
        _getUserBookingsUseCase(),
      ]);

      final activitiesResult = results[0] as Result<List<Activity>, Failure>;
      final bookingsResult = results[1] as Result<List<Reservation>, Failure>;

      activitiesResult.when(
        success: (data) => _activities = data,
        failure: (failure) => _error = 'activities_loading_failed',
      );

      bookingsResult.when(
        success: (data) => _reservations = data,
        failure: (failure) => _error = 'bookings_loading_failed',
      );
    } catch (e) {
      _error = 'loading_failed';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
