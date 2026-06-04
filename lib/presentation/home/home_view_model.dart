import 'package:bourgo_arena_mobile/domain/entities/activity.dart';
import 'package:bourgo_arena_mobile/domain/entities/course.dart' as entity;
import 'package:bourgo_arena_mobile/domain/usecases/activity/get_activities_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/course/get_courses_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/service/get_services_use_case.dart';
import 'package:bourgo_arena_mobile/domain/entities/service.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as developer;

/// ViewModel for the Home screen.
class HomeViewModel extends ChangeNotifier {
  final GetActivitiesUseCase _getActivitiesUseCase;
  final GetCoursesUseCase _getCoursesUseCase;
  final GetServicesUseCase _getServicesUseCase;
  bool _isDisposed = false;

  HomeViewModel({
    required GetActivitiesUseCase getActivitiesUseCase,
    required GetCoursesUseCase getCoursesUseCase,
    required GetServicesUseCase getServicesUseCase,
  }) : _getActivitiesUseCase = getActivitiesUseCase,
       _getCoursesUseCase = getCoursesUseCase,
       _getServicesUseCase = getServicesUseCase;
  int _currentIndex = 0;
  int get currentIndex => _currentIndex;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  List<Activity> _activities = [];
  List<Activity> get activities => _activities;

  List<Service> _services = [];
  List<Service> get services => _services;

  List<entity.Course> _todayCourses = [];
  List<entity.Course> get todayCourses => _todayCourses;

  void setTab(int index) {
    _currentIndex = index;
    if (!_isDisposed) {
      notifyListeners();
    }
  }

  /// Loads all data required for the home screen.
  Future<void> loadHomeData() async {
    developer.log('HomeViewModel: loadHomeData() started');
    if (_isDisposed) {
      developer.log(
        'HomeViewModel: loadHomeData() called on disposed instance, skipping',
      );
      return;
    }

    _isLoading = true;
    if (!_isDisposed) {
      notifyListeners();
    }

    try {
      // Load activities via Use Case
      final activitiesResult = await _getActivitiesUseCase();
      if (!_isDisposed) {
        activitiesResult.when(
          success: (data) => _activities = data,
          failure: (failure) =>
              developer.log('Error loading activities: $failure'),
        );
      }

      // Load services via Use Case
      final servicesResult = await _getServicesUseCase();
      if (!_isDisposed) {
        servicesResult.when(
          success: (data) => _services = data,
          failure: (failure) =>
              developer.log('Error loading services: $failure'),
        );
      }

      // Load courses via Use Case
      final coursesResult = await _getCoursesUseCase();
      if (!_isDisposed) {
        coursesResult.when(
          success: (data) {
            final today = DateTime.now().weekday;
            final todays = data.where((c) => c.dayOfWeek == today).toList();
            if (todays.isEmpty && data.isNotEmpty) {
              _todayCourses = data.take(3).toList();
            } else {
              _todayCourses = todays;
            }
          },
          failure: (failure) =>
              developer.log('Error loading courses: $failure'),
        );
      }

      developer.log(
        'Home Data Loaded: ${_activities.length} activities, ${_services.length} services, ${_todayCourses.length} courses',
      );
    } catch (e, stack) {
      developer.log('Error loading home data: $e', error: e, stackTrace: stack);
    } finally {
      if (!_isDisposed) {
        _isLoading = false;
        notifyListeners();
      }
    }
  }

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }
}
