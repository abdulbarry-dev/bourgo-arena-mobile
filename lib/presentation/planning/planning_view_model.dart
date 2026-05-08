import 'package:bourgo_arena_mobile/core/constants/app_constants.dart';
import 'package:bourgo_arena_mobile/domain/entities/course.dart';
import 'package:bourgo_arena_mobile/domain/usecases/course/get_courses_use_case.dart';
import 'package:flutter/material.dart';

/// ViewModel for the Planning (Course Schedule) screen.
class PlanningViewModel extends ChangeNotifier {
  final GetCoursesUseCase _getCoursesUseCase;

  List<Course> _allCourses = [];
  List<Course> _filteredCourses = [];
  bool _isLoading = false;
  int _selectedDay = 1; // Monday by default
  String _selectedCategory = AppConstants.planningCategoryAll;

  /// List of courses filtered by the selected day and category.
  List<Course> get courses => _filteredCourses;

  /// Whether data is currently being loaded.
  bool get isLoading => _isLoading;

  /// Currently selected day of the week (1-7).
  int get selectedDay => _selectedDay;

  /// Currently selected category filter.
  String get selectedCategory => _selectedCategory;

  /// Creates a new [PlanningViewModel] instance.
  PlanningViewModel({required GetCoursesUseCase getCoursesUseCase})
    : _getCoursesUseCase = getCoursesUseCase {
    loadCourses();
  }

  /// Loads courses from the data service.
  Future<void> loadCourses() async {
    _isLoading = true;
    notifyListeners();

    try {
      final result = await _getCoursesUseCase();
      result.when(
        success: (data) {
          _allCourses = data;
          _filter();
        },
        failure: (failure) {
          // Handle error
        },
      );
    } catch (e) {
      // Handle error
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Updates the selected day and refreshes the filter.
  void selectDay(int day) {
    _selectedDay = day;
    _filter();
    notifyListeners();
  }

  /// Updates the selected category and refreshes the filter.
  void selectCategory(String category) {
    _selectedCategory = category;
    _filter();
    notifyListeners();
  }

  void _filter() {
    _filteredCourses = _allCourses.where((course) {
      final matchesDay = course.dayOfWeek == _selectedDay;
      final matchesCategory =
          _selectedCategory == AppConstants.planningCategoryAll ||
          course.category == _selectedCategory;
      return matchesDay && matchesCategory;
    }).toList();
  }
}
