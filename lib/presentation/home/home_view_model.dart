import 'package:bourgo_arena_mobile/domain/entities/activity.dart';
import 'package:bourgo_arena_mobile/domain/entities/course.dart';
import 'package:bourgo_arena_mobile/domain/entities/service.dart';
import 'package:bourgo_arena_mobile/domain/entities/event.dart';
import 'package:bourgo_arena_mobile/domain/usecases/activity/get_activities_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/course/get_courses_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/service/get_services_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/event/event_use_cases.dart';
import 'package:bourgo_arena_mobile/core/base/base_view_model.dart';

class HomeViewModel extends BaseViewModel {
  final GetActivitiesUseCase _getActivitiesUseCase;
  final GetCoursesUseCase _getCoursesUseCase;
  final GetServicesUseCase _getServicesUseCase;
  final GetEventsUseCase _getEventsUseCase;

  bool _isDisposed = false;

  HomeViewModel({
    required GetActivitiesUseCase getActivitiesUseCase,
    required GetCoursesUseCase getCoursesUseCase,
    required GetServicesUseCase getServicesUseCase,
    required GetEventsUseCase getEventsUseCase,
  }) : _getActivitiesUseCase = getActivitiesUseCase,
       _getCoursesUseCase = getCoursesUseCase,
       _getServicesUseCase = getServicesUseCase,
       _getEventsUseCase = getEventsUseCase;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  List<Event> _events = [];
  List<Event> get events => _events;
  bool _eventsLoading = true;
  bool get eventsLoading => _eventsLoading;
  String? _eventsError;
  String? get eventsError => _eventsError;

  List<Course> _courses = [];
  List<Course> get courses => _courses;
  bool _coursesLoading = true;
  bool get coursesLoading => _coursesLoading;
  String? _coursesError;
  String? get coursesError => _coursesError;

  List<Activity> _activities = [];
  List<Activity> get activities => _activities;
  bool _activitiesLoading = true;
  bool get activitiesLoading => _activitiesLoading;
  String? _activitiesError;
  String? get activitiesError => _activitiesError;

  List<Service> _services = [];
  List<Service> get services => _services;
  bool _servicesLoading = true;
  bool get servicesLoading => _servicesLoading;
  String? _servicesError;
  String? get servicesError => _servicesError;

  Future<void> loadHomeData() async {
    if (_isDisposed) return;
    _isLoading = true;
    notifyListeners();

    await Future.wait([
      _loadEvents(),
      _loadCourses(),
      _loadActivities(),
      _loadServices(),
    ]);

    if (!_isDisposed) {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _loadEvents() async {
    _eventsLoading = true;
    _eventsError = null;
    notifyListeners();
    final result = await _getEventsUseCase();
    if (_isDisposed) return;
    result.when(
      success: (data) {
        _events = data.take(5).toList();
      },
      failure: (f) {
        _eventsError = f.message;
      },
    );
    _eventsLoading = false;
    notifyListeners();
  }

  Future<void> _loadCourses() async {
    _coursesLoading = true;
    _coursesError = null;
    notifyListeners();
    final result = await _getCoursesUseCase();
    if (_isDisposed) return;
    result.when(
      success: (data) {
        _courses = data.take(5).toList();
      },
      failure: (f) {
        _coursesError = f.message;
      },
    );
    _coursesLoading = false;
    notifyListeners();
  }

  Future<void> _loadActivities() async {
    _activitiesLoading = true;
    _activitiesError = null;
    notifyListeners();
    final result = await _getActivitiesUseCase();
    if (_isDisposed) return;
    result.when(
      success: (data) {
        _activities = data.take(5).toList();
      },
      failure: (f) {
        _activitiesError = f.message;
      },
    );
    _activitiesLoading = false;
    notifyListeners();
  }

  Future<void> _loadServices() async {
    _servicesLoading = true;
    _servicesError = null;
    notifyListeners();
    final result = await _getServicesUseCase();
    if (_isDisposed) return;
    result.when(
      success: (data) {
        _services = data.take(5).toList();
      },
      failure: (f) {
        _servicesError = f.message;
      },
    );
    _servicesLoading = false;
    notifyListeners();
  }

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }
}
