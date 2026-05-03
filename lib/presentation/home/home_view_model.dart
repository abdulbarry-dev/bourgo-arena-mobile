import 'package:bourgo_arena_mobile/data/models/course.dart';
import 'package:bourgo_arena_mobile/data/services/activity_service.dart';
import 'package:bourgo_arena_mobile/data/services/data_service.dart';
import 'package:bourgo_arena_mobile/domain/entities/activity.dart';
import 'package:flutter/material.dart';

/// ViewModel for the Home screen.
class HomeViewModel extends ChangeNotifier {
  final ActivityService _activityService;
  final DataService _dataService;

  HomeViewModel({
    required ActivityService activityService,
    required DataService dataService,
  }) : _activityService = activityService,
       _dataService = dataService;

  int _currentIndex = 0;
  int get currentIndex => _currentIndex;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  List<Activity> _activities = [];
  List<Activity> get activities => _activities;

  List<Course> _todayCourses = [];
  List<Course> get todayCourses => _todayCourses;

  void setTab(int index) {
    _currentIndex = index;
    notifyListeners();
  }

  /// Loads all data required for the home screen.
  Future<void> loadHomeData() async {
    _isLoading = true;
    notifyListeners();

    try {
      // Load activities via ActivityService (Domain Entities)
      await _activityService.fetchActivities();
      _activities = _activityService.activities;

      // Load courses via DataService (for now)
      final allCourses = await _dataService.getCourses();
      final today = DateTime.now().weekday;
      _todayCourses = allCourses.where((c) => c.dayOfWeek == today).toList();
    } catch (e) {
      // In a real app, handle error
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
