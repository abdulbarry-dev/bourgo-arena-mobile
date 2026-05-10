import 'package:bourgo_arena_mobile/core/constants/app_constants.dart';
import 'package:bourgo_arena_mobile/domain/entities/activity.dart';
import 'package:bourgo_arena_mobile/domain/entities/time_slot.dart';
import 'package:bourgo_arena_mobile/domain/entities/reservation.dart';
import 'package:bourgo_arena_mobile/domain/usecases/activity/get_activities_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/activity/get_time_slots_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/booking/cancel_booking_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/booking/get_user_bookings_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/booking/make_reservation_use_case.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as developer;

/// ViewModel for the multi-step booking flow.
class BookingViewModel extends ChangeNotifier {
  final GetActivitiesUseCase _getActivitiesUseCase;
  final GetTimeSlotsUseCase _getTimeSlotsUseCase;
  final GetUserBookingsUseCase _getUserBookingsUseCase;
  final MakeReservationUseCase _makeReservationUseCase;
  final CancelBookingUseCase _cancelBookingUseCase;

  int _currentStep = 0;
  Activity? _selectedActivity;
  DateTime _selectedDate = DateTime.now();
  TimeSlot? _selectedSlot;
  String _paymentMethod = AppConstants.paymentMethodCardId;

  List<Activity> _activities = [];
  List<TimeSlot> _availableSlots = [];
  List<Reservation> _userBookings = [];
  bool _isLoading = false;
  String? _error;

  /// Creates a new [BookingViewModel] instance.
  BookingViewModel({
    required GetActivitiesUseCase getActivitiesUseCase,
    required GetTimeSlotsUseCase getTimeSlotsUseCase,
    required GetUserBookingsUseCase getUserBookingsUseCase,
    required MakeReservationUseCase makeReservationUseCase,
    required CancelBookingUseCase cancelBookingUseCase,
    Activity? initialActivity,
  }) : _getActivitiesUseCase = getActivitiesUseCase,
       _getTimeSlotsUseCase = getTimeSlotsUseCase,
       _getUserBookingsUseCase = getUserBookingsUseCase,
       _makeReservationUseCase = makeReservationUseCase,
       _cancelBookingUseCase = cancelBookingUseCase,
       _selectedActivity = initialActivity {
    loadUserBookings();
    if (_selectedActivity != null) {
      _currentStep = 1;
      _loadSlots();
    } else {
      _loadActivities();
    }
  }

  /// Current step in the booking flow (0-2).
  int get currentStep => _currentStep;

  /// The activity selected for booking.
  Activity? get selectedActivity => _selectedActivity;

  /// The date selected for booking.
  DateTime get selectedDate => _selectedDate;

  /// The time slot selected for booking.
  TimeSlot? get selectedSlot => _selectedSlot;

  /// The selected payment method identifier.
  String get paymentMethod => _paymentMethod;

  /// List of all available activities.
  List<Activity> get activities => _activities;

  /// Available time slots for the selected activity and date.
  List<TimeSlot> get availableSlots => _availableSlots;

  /// List of bookings for the current user.
  List<Reservation> get userBookings => _userBookings;

  /// Whether data is currently loading.
  bool get isLoading => _isLoading;

  /// Current error message if any.
  String? get error => _error;

  /// Moves to the next step in the flow.
  void nextStep() {
    if (_currentStep < 2) {
      _currentStep++;
      notifyListeners();
    }
  }

  /// Moves to the previous step in the flow.
  void previousStep() {
    if (_currentStep > 0) {
      _currentStep--;
      notifyListeners();
    }
  }

  /// Selects an [activity] and proceeds to the next step.
  void selectActivity(Activity activity) {
    _selectedActivity = activity;
    _currentStep = 1;
    _loadSlots();
    notifyListeners();
  }

  /// Selects a [date] and refreshes available slots.
  void selectDate(DateTime date) {
    _selectedDate = date;
    _selectedSlot = null;
    _loadSlots();
    notifyListeners();
  }

  /// Selects a specific [slot].
  void selectSlot(TimeSlot slot) {
    _selectedSlot = slot;
    notifyListeners();
  }

  /// Sets the [method] of payment.
  void setPaymentMethod(String method) {
    _paymentMethod = method;
    notifyListeners();
  }

  /// Fetches the list of bookings for the current user.
  Future<void> loadUserBookings() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    final result = await _getUserBookingsUseCase();
    result.when(
      success: (bookings) {
        _userBookings = bookings;
      },
      failure: (failure) {
        _error = 'bookings_loading_failed';
        developer.log('Error loading bookings: ${failure.message}');
      },
    );

    _isLoading = false;
    notifyListeners();
  }

  /// Cancels an existing booking by its [id].
  Future<void> cancelBooking(String id) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    final result = await _cancelBookingUseCase(id);
    result.when(
      success: (_) {
        loadUserBookings();
      },
      failure: (failure) {
        _error = 'booking_cancellation_failed';
        developer.log('Error cancelling booking: ${failure.message}');
      },
    );

    _isLoading = false;
    notifyListeners();
  }

  /// Creates a new reservation based on the current selection.
  Future<bool> makeReservation() async {
    final activity = _selectedActivity;
    final slot = _selectedSlot;

    if (activity == null || slot == null) {
      _error = 'missing_selection';
      notifyListeners();
      return false;
    }

    _isLoading = true;
    _error = null;
    notifyListeners();

    final reservation = Reservation(
      id: '', // Will be assigned by backend
      activityId: activity.id,
      activityTitle: activity.category,
      date: _selectedDate.toIso8601String().split('T')[0],
      time: slot.time,
      duration: activity.id == 'padel-1'
          ? '90 min'
          : '60 min', // Mock logic for demo
      price: activity.basePrice,
      status: 'confirmed',
      paymentStatus: 'paid',
      qrCode: 'mock-qr-code',
    );

    final result = await _makeReservationUseCase(reservation);
    bool success = false;

    result.when(
      success: (data) {
        success = true;
        _resetForm();
      },
      failure: (failure) {
        _error = 'reservation_failed';
        developer.log('Error making reservation: ${failure.message}');
      },
    );

    _isLoading = false;
    notifyListeners();
    return success;
  }

  void _resetForm() {
    _selectedActivity = null;
    _selectedSlot = null;
    _currentStep = 0;
    _availableSlots = [];
  }

  Future<void> _loadActivities() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    final result = await _getActivitiesUseCase();
    result.when(
      success: (activities) {
        _activities = activities;
      },
      failure: (failure) {
        _error = 'activities_loading_failed';
        developer.log('Error loading activities: ${failure.message}');
      },
    );

    _isLoading = false;
    notifyListeners();
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

      final result = await _getTimeSlotsUseCase(activity.id);
      result.when(
        success: (slots) {
          _availableSlots = slots;
          developer.log(
            'BookingViewModel: Loaded ${_availableSlots.length} slots for ${activity.id}',
          );
        },
        failure: (failure) {
          _error = 'slots_loading_failed';
          _availableSlots = [];
          developer.log('Error loading slots: ${failure.message}');
        },
      );
    } catch (e, stack) {
      developer.log(
        'BookingViewModel: Unexpected error loading slots: $e',
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
