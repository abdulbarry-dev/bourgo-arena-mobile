import 'package:bourgo_arena_mobile/data/mappers/activity_mapper.dart';
import 'package:bourgo_arena_mobile/data/models/activity_model.dart';
import 'package:bourgo_arena_mobile/data/models/reservation.dart';
import 'package:bourgo_arena_mobile/data/services/data_service.dart';
import 'package:bourgo_arena_mobile/domain/entities/activity.dart';
import 'package:flutter/material.dart';

/// ViewModel for the Activities screen.
class ActivitiesViewModel extends ChangeNotifier {
  final DataService _dataService;

  List<Activity> _activities = [];
  List<Reservation> _reservations = [];
  bool _isLoading = false;
  String? _error;

  /// Creates a new [ActivitiesViewModel] instance.
  ActivitiesViewModel({required DataService dataService})
    : _dataService = dataService;

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
        _dataService.getActivities(),
        _dataService.getReservations(),
      ]);
      _activities = (results[0] as List<ActivityModel>).toEntityList();
      _reservations = results[1] as List<Reservation>;
    } catch (e) {
      _error = 'loading_failed';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
