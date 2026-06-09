import 'package:bourgo_arena_mobile/core/base/base_view_model.dart';
import 'package:bourgo_arena_mobile/core/constants/app_constants.dart';
import 'package:bourgo_arena_mobile/domain/entities/activity.dart';
import 'package:bourgo_arena_mobile/domain/entities/family_member.dart';
import 'package:bourgo_arena_mobile/domain/entities/member_tier.dart';
import 'package:bourgo_arena_mobile/domain/entities/time_slot.dart';
import 'package:bourgo_arena_mobile/domain/entities/reservation.dart';
import 'package:bourgo_arena_mobile/domain/usecases/activity/get_activities_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/activity/get_time_slots_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/booking/cancel_booking_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/booking/get_user_bookings_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/booking/make_reservation_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/family/get_family_members_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/loyalty/get_member_tier_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/loyalty/project_points_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/pricing/get_contextual_price_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/user/get_user_profile_use_case.dart';
import 'dart:developer' as developer;

/// ViewModel for the multi-step booking flow.
class BookingViewModel extends BaseViewModel {
  final GetActivitiesUseCase _getActivitiesUseCase;
  final GetTimeSlotsUseCase _getTimeSlotsUseCase;
  final GetUserBookingsUseCase _getUserBookingsUseCase;
  final MakeReservationUseCase _makeReservationUseCase;
  final CancelBookingUseCase _cancelBookingUseCase;
  final GetFamilyMembersUseCase _getFamilyMembersUseCase;
  final GetUserProfileUseCase _getUserProfileUseCase;
  final GetContextualPriceUseCase _getContextualPriceUseCase;
  final GetMemberTierUseCase _getMemberTierUseCase;
  final ProjectPointsUseCase _projectPointsUseCase;

  int _currentStep = 0;
  Activity? _selectedActivity;
  DateTime _selectedDate = DateTime.now();
  TimeSlot? _selectedSlot;
  String _paymentMethod = AppConstants.paymentMethodCardId;

  List<Activity> _activities = [];
  List<TimeSlot> _availableSlots = [];
  List<Reservation> _userBookings = [];
  List<FamilyMember> _familyMembers = [];
  FamilyMember? _selectedMember;
  bool _isFamilyAccount = false;
  MemberTier _memberTier = MemberTier.public;

  double? _contextualPrice;
  bool _isPricingLoading = false;
  bool _isLoading = false;

  String? _depositUrl;
  int? _depositPaymentId;
  String? _createdReservationId;

  /// Creates a new [BookingViewModel] instance.
  BookingViewModel({
    required GetActivitiesUseCase getActivitiesUseCase,
    required GetTimeSlotsUseCase getTimeSlotsUseCase,
    required GetUserBookingsUseCase getUserBookingsUseCase,
    required MakeReservationUseCase makeReservationUseCase,
    required CancelBookingUseCase cancelBookingUseCase,
    required GetFamilyMembersUseCase getFamilyMembersUseCase,
    required GetUserProfileUseCase getUserProfileUseCase,
    required GetContextualPriceUseCase getContextualPriceUseCase,
    required GetMemberTierUseCase getMemberTierUseCase,
    required ProjectPointsUseCase projectPointsUseCase,
    Activity? initialActivity,
  }) : _getActivitiesUseCase = getActivitiesUseCase,
       _getTimeSlotsUseCase = getTimeSlotsUseCase,
       _getUserBookingsUseCase = getUserBookingsUseCase,
       _makeReservationUseCase = makeReservationUseCase,
       _cancelBookingUseCase = cancelBookingUseCase,
       _getFamilyMembersUseCase = getFamilyMembersUseCase,
       _getUserProfileUseCase = getUserProfileUseCase,
       _getContextualPriceUseCase = getContextualPriceUseCase,
       _getMemberTierUseCase = getMemberTierUseCase,
       _projectPointsUseCase = projectPointsUseCase,
       _selectedActivity = initialActivity {
    loadUserBookings();
    _initializeFamilyContext();
  }

  /// Current step in the booking flow (0-2).
  int get currentStep => _currentStep;

  int get totalSteps => _isFamilyAccount ? 5 : 4;
  int get paymentStepIndex => totalSteps - 1;

  /// The activity selected for booking.
  Activity? get selectedActivity => _selectedActivity;

  List<FamilyMember> get familyMembers => _familyMembers;
  FamilyMember? get selectedMember => _selectedMember;
  bool get isFamilyAccount => _isFamilyAccount;

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

  bool get isPricingLoading => _isPricingLoading;

  double get priceToPay =>
      _contextualPrice ?? _selectedActivity?.basePrice ?? 0;
  bool get hasContextualPrice => _contextualPrice != null;
  MemberTier get memberTier => _memberTier;

  String? get depositUrl => _depositUrl;
  int? get depositPaymentId => _depositPaymentId;
  String? get createdReservationId => _createdReservationId;
  bool get requiresDeposit => _depositUrl != null;
  int get projectedPoints {
    if (_paymentMethod == AppConstants.paymentMethodWalletId) {
      return 0;
    }
    return _projectPointsUseCase(amount: priceToPay, tier: _memberTier);
  }

  /// Moves to the next step in the flow.
  void nextStep() {
    if (_currentStep < totalSteps - 1) {
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

  /// Selects an [activity] and moves to the detail step.
  void selectActivity(Activity activity) {
    _selectedActivity = activity;
    _currentStep = _isFamilyAccount ? 2 : 1;
    notifyListeners();
  }

  /// Confirms activity selection from detail view, loads slots and moves forward.
  void confirmActivitySelection() {
    _currentStep = _isFamilyAccount ? 3 : 2;
    _loadSlots();
    _loadContextualPrice();
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

  void selectMember(FamilyMember member) {
    _selectedMember = member;
    _contextualPrice = null;
    _loadContextualPrice();
    // If selecting member is the first step, allow moving forward.
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
    clearError();
    notifyListeners();

    final result = await _getUserBookingsUseCase();
    result.when(
      success: (bookings) {
        _userBookings = bookings;
      },
      failure: (failure) {
        setErrorMessage('bookings_loading_failed');
        developer.log('Error loading bookings: ${failure.message}');
      },
    );

    _isLoading = false;
    notifyListeners();
  }

  /// Cancels an existing booking by its [id].
  Future<void> cancelBooking(String id) async {
    _isLoading = true;
    clearError();
    notifyListeners();

    final result = await _cancelBookingUseCase(id);
    result.when(
      success: (_) {
        loadUserBookings();
      },
      failure: (failure) {
        setErrorMessage('booking_cancellation_failed');
        developer.log('Error cancelling booking: ${failure.message}');
      },
    );

    _isLoading = false;
    notifyListeners();
  }

  /// Creates a new reservation based on the current selection.
  /// Returns [true] if the reservation was created (with or without deposit),
  /// and populates [depositUrl] if the backend returned a 10% deposit payment.
  Future<bool> makeReservation() async {
    final activity = _selectedActivity;
    final slot = _selectedSlot;
    final member = _selectedMember;

    if (activity == null || slot == null) {
      setErrorMessage('missing_selection');
      return false;
    }
    if (_isFamilyAccount && member == null) {
      setErrorMessage('missing_member');
      return false;
    }

    _isLoading = true;
    clearError();
    _depositUrl = null;
    _depositPaymentId = null;
    _createdReservationId = null;
    notifyListeners();

    final reservation = Reservation(
      id: '',
      activityId: activity.id,
      activitySlotId: slot.id,
      activityTitle: activity.category,
      memberId: member?.id,
      date: _selectedDate.toIso8601String().split('T')[0],
      time: slot.time,
      duration: activity.id == 'padel-1'
          ? '90 min'
          : '60 min',
      price: priceToPay,
      status: 'confirmed',
      paymentStatus: 'pending',
      qrCode: '',
    );

    final result = await _makeReservationUseCase(reservation);
    bool success = false;

    result.when(
      success: (data) {
        success = true;
        _createdReservationId = data.reservation.id;
        if (data.requiresDeposit) {
          _depositUrl = data.paymentUrl;
          _depositPaymentId = data.depositPaymentId;
        }
        _resetForm();
      },
      failure: (failure) {
        setErrorMessage('reservation_failed');
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
    _currentStep = _isFamilyAccount ? 0 : 0;
    _availableSlots = [];
    _contextualPrice = null;
  }

  Future<void> _loadActivities() async {
    _isLoading = true;
    clearError();
    notifyListeners();

    final result = await _getActivitiesUseCase();
    result.when(
      success: (activities) {
        _activities = activities;
      },
      failure: (failure) {
        setErrorMessage('activities_loading_failed');
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
    clearError();
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
          setErrorMessage('slots_loading_failed');
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
      setErrorMessage('slots_loading_failed');
      _availableSlots = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _initializeFamilyContext() async {
    try {
      final userResult = await _getUserProfileUseCase();
      userResult.when(
        success: (user) {
          _isFamilyAccount = user.isParentAccount;
          _memberTier = _getMemberTierUseCase(
            subscriptionLevel: user.subscriptionLevel,
          );
        },
        failure: (_) => _isFamilyAccount = false,
      );

      if (_isFamilyAccount) {
        final membersResult = await _getFamilyMembersUseCase();
        membersResult.when(
          success: (members) {
            _familyMembers = members;
            _selectedMember ??= members.isNotEmpty ? members.first : null;
          },
          failure: (_) => _familyMembers = [],
        );
      }

      if (_selectedActivity != null) {
        _currentStep = _isFamilyAccount ? 2 : 1;
      } else {
        _currentStep = _isFamilyAccount ? 0 : 0;
        _loadActivities();
      }
    } catch (_) {
      _isFamilyAccount = false;
      _loadActivities();
    } finally {
      notifyListeners();
    }
  }

  Future<void> _loadContextualPrice() async {
    final activity = _selectedActivity;
    final member = _selectedMember;
    if (activity == null) return;
    if (_isFamilyAccount && member == null) return;

    final memberId = member?.id;
    if (memberId == null) return;

    _isPricingLoading = true;
    notifyListeners();

    final result = await _getContextualPriceUseCase(
      activityId: activity.id,
      memberId: memberId,
    );

    result.when(
      success: (price) => _contextualPrice = price,
      failure: (_) => _contextualPrice = null,
    );

    _isPricingLoading = false;
    notifyListeners();
  }
}
