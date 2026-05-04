import 'package:bourgo_arena_mobile/core/constants/app_constants.dart';
import 'package:bourgo_arena_mobile/data/services/activity_service.dart';
import 'package:bourgo_arena_mobile/domain/entities/activity.dart';
import 'package:bourgo_arena_mobile/domain/entities/time_slot.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as developer;

/// ViewModel for the multi-step booking flow.
class BookingViewModel extends ChangeNotifier {
  final ActivityService _activityService;

  int _currentStep = 0;
  Activity? _selectedActivity;
  DateTime _selectedDate = DateTime.now();
  TimeSlot? _selectedSlot;
  String _paymentMethod = AppConstants.paymentMethodCardId;

  List<Activity> _activities = [];
  List<TimeSlot> _availableSlots = [];
  bool _isLoading = false;
  String? _error;

  /// Creates a new [BookingViewModel] instance.
  BookingViewModel({
    required ActivityService activityService,
    Activity? initialActivity,
  }) : _activityService = activityService,
       _selectedActivity = initialActivity {
    if (_selectedActivity != null) {
      _currentStep = 1;
      _loadSlots();
    } else {
      _loadActivities();
    }
  }

  int get currentStep => _currentStep;
  Activity? get selectedActivity => _selectedActivity;
  DateTime get selectedDate => _selectedDate;
  TimeSlot? get selectedSlot => _selectedSlot;
  String get paymentMethod => _paymentMethod;
  List<Activity> get activities => _activities;
  List<TimeSlot> get availableSlots => _availableSlots;
  bool get isLoading => _isLoading;
  String? get error => _error;

  void nextStep() {
    if (_currentStep < 2) {
      _currentStep++;
      notifyListeners();
    }
  }

  void previousStep() {
    if (_currentStep > 0) {
      _currentStep--;
      notifyListeners();
    }
  }

  void selectActivity(Activity activity) {
    _selectedActivity = activity;
    _currentStep = 1;
    _loadSlots();
    notifyListeners();
  }

  void selectDate(DateTime date) {
    _selectedDate = date;
    _selectedSlot = null;
    _loadSlots();
    notifyListeners();
  }

  void selectSlot(TimeSlot slot) {
    _selectedSlot = slot;
    notifyListeners();
  }

  void setPaymentMethod(String method) {
    _paymentMethod = method;
    notifyListeners();
  }

  Future<void> _loadActivities() async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      await _activityService.fetchActivities();
      _activities = _activityService.activities;
    } catch (e) {
      _error = 'activities_loading_failed';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _loadSlots() async {
    final activity = _selectedActivity;
    if (activity == null) return;

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      developer.log(
        'BookingViewModel: Loading slots for activity: ${activity.id}',
      );
      // In a real app, we'd pass the date too to the service.
      _availableSlots = await _activityService.getTimeSlots(activity.id);
      developer.log(
        'BookingViewModel: Loaded ${_availableSlots.length} slots for ${activity.id}',
      );
    } catch (e, stack) {
      developer.log(
        'BookingViewModel: Error loading slots: $e',
        error: e,
        stackTrace: stack,
      );
      _error = 'slots_loading_failed';
      _availableSlots = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
