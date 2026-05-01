import 'package:bourgo_arena_mobile/core/constants.dart';
import 'package:flutter/material.dart';
import 'package:bourgo_arena_mobile/data/models/activity.dart';
import 'package:bourgo_arena_mobile/data/models/time_slot.dart';
import 'package:bourgo_arena_mobile/data/services/data_service.dart';

/// ViewModel for the multi-step booking flow.
class BookingViewModel extends ChangeNotifier {
  final DataService _dataService;

  int _currentStep = 0;
  Activity? _selectedActivity;
  DateTime _selectedDate = DateTime.now();
  TimeSlot? _selectedSlot;
  String _paymentMethod = AppConstants.paymentMethodCardId;

  List<Activity> _activities = [];
  List<TimeSlot> _availableSlots = [];
  bool _isLoading = false;

  /// Creates a new [BookingViewModel] instance.
  BookingViewModel({
    required DataService dataService,
    Activity? initialActivity,
  }) : _dataService = dataService,
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
    notifyListeners();
    _activities = await _dataService.getActivities();
    _isLoading = false;
    notifyListeners();
  }

  Future<void> _loadSlots() async {
    if (_selectedActivity == null) return;
    _isLoading = true;
    notifyListeners();
    // In a real app, we'd pass the date too.
    final activity = _selectedActivity;
    if (activity != null) {
      _availableSlots = await _dataService.getTimeSlots(activity.id);
    }
    _isLoading = false;
    notifyListeners();
  }
}
