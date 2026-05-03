import 'package:bourgo_arena_mobile/domain/entities/activity.dart';
import 'package:bourgo_arena_mobile/domain/repositories/activity_repository.dart';
import 'package:flutter/foundation.dart';
import 'dart:developer' as developer;

/// Service for managing activities and related business logic.
class ActivityService extends ChangeNotifier {
  final ActivityRepository _activityRepository;
  List<Activity> _activities = [];
  bool _isLoading = false;

  ActivityService(this._activityRepository);

  /// List of available activities.
  List<Activity> get activities => _activities;

  /// Whether activities are currently being loaded.
  bool get isLoading => _isLoading;

  /// Fetches the list of activities from the repository.
  Future<void> fetchActivities() async {
    _isLoading = true;
    notifyListeners();
    try {
      _activities = await _activityRepository.getActivities();
      developer.log('ActivityService: Fetched ${_activities.length} activities');
    } catch (e, stack) {
      developer.log('ActivityService: Error fetching activities: $e', error: e, stackTrace: stack);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Retrieves an activity by its [id].
  Future<Activity> getActivity(String id) {
    return _activityRepository.getActivityById(id);
  }
}
