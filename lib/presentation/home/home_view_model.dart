import 'package:bourgo_arena_mobile/domain/entities/activity.dart';
import 'package:bourgo_arena_mobile/domain/entities/course.dart' as entity;
import 'package:bourgo_arena_mobile/domain/usecases/activity/get_activities_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/course/get_courses_use_case.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as developer;

/// ViewModel for the Home screen.
class HomeViewModel extends ChangeNotifier {
  final GetActivitiesUseCase _getActivitiesUseCase;
  final GetCoursesUseCase _getCoursesUseCase;

  HomeViewModel({
    required GetActivitiesUseCase getActivitiesUseCase,
    required GetCoursesUseCase getCoursesUseCase,
  }) : _getActivitiesUseCase = getActivitiesUseCase,
       _getCoursesUseCase = getCoursesUseCase;

  int _currentIndex = 0;
  int get currentIndex => _currentIndex;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  List<Activity> _activities = [];
  List<Activity> get activities => _activities;

  List<entity.Course> _todayCourses = [];
  List<entity.Course> get todayCourses => _todayCourses;

  void setTab(int index) {
    _currentIndex = index;
    notifyListeners();
  }

  /// Loads all data required for the home screen.
  Future<void> loadHomeData() async {
    developer.log('HomeViewModel: loadHomeData() started');
    _isLoading = true;
    notifyListeners();

    try {
      // Load activities via Use Case
      final activitiesResult = await _getActivitiesUseCase();
      activitiesResult.when(
        success: (data) => _activities = data,
        failure: (failure) => developer.log('Error loading activities: $failure'),
      );

      // Load courses via Use Case
      final coursesResult = await _getCoursesUseCase();
      coursesResult.when(
        success: (data) {
          final today = DateTime.now().weekday;
          _todayCourses = data.where((c) => c.dayOfWeek == today).toList();
        },
        failure: (failure) => developer.log('Error loading courses: $failure'),
      );

      developer.log(
        'Home Data Loaded: ${_activities.length} activities, ${_todayCourses.length} courses',
      );
    } catch (e, stack) {
      developer.log('Error loading home data: $e', error: e, stackTrace: stack);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
