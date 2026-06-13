import 'package:bourgo_arena_mobile/core/base/base_view_model.dart';
import 'package:bourgo_arena_mobile/core/utils/result.dart';
import 'package:bourgo_arena_mobile/domain/core/failure.dart';
import 'package:bourgo_arena_mobile/domain/entities/user.dart';
import 'package:bourgo_arena_mobile/domain/repositories/auth_repository.dart';
import 'package:bourgo_arena_mobile/domain/usecases/auth/logout_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/auth/delete_account_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/booking/get_ongoing_reservations_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/event/get_my_events_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/payment/get_full_payment_history_use_case.dart';
import 'package:bourgo_arena_mobile/presentation/auth/auth_state_notifier.dart';
import 'package:bourgo_arena_mobile/presentation/main_layout.dart';
import 'dart:developer' as developer;

/// ViewModel for the Profile screen.
class ProfileViewModel extends BaseViewModel {
  final AuthRepository _authRepository;
  final LogoutUseCase _logoutUseCase;
  final DeleteAccountUseCase _deleteAccountUseCase;
  final AuthStateNotifier _authStateNotifier;
  final GetOngoingReservationsUseCase _getOngoingReservationsUseCase;
  final GetFullPaymentHistoryUseCase _getFullPaymentHistoryUseCase;
  final GetMyEventsUseCase _getMyEventsUseCase;

  bool _isLoading = false;
  int _ongoingReservationsCount = 0;
  int _successfulPaymentsCount = 0;
  int _myEventsCount = 0;

  /// The user's profile data, sourced from the global AuthStateNotifier.
  User? get user => _authStateNotifier.currentUser;

  /// Whether data is currently being loaded.
  bool get isLoading => _isLoading;

  /// The count of ongoing reservations for the current user.
  int get ongoingReservationsCount => _ongoingReservationsCount;

  /// The count of successfully completed payments.
  int get successfulPaymentsCount => _successfulPaymentsCount;

  /// The count of the user's event participations.
  int get myEventsCount => _myEventsCount;

  /// Creates a new [ProfileViewModel] instance.
  ProfileViewModel({
    required AuthRepository authRepository,
    required LogoutUseCase logoutUseCase,
    required DeleteAccountUseCase deleteAccountUseCase,
    required AuthStateNotifier authStateNotifier,
    required GetOngoingReservationsUseCase getOngoingReservationsUseCase,
    required GetFullPaymentHistoryUseCase getFullPaymentHistoryUseCase,
    required GetMyEventsUseCase getMyEventsUseCase,
  }) : _authRepository = authRepository,
       _logoutUseCase = logoutUseCase,
       _deleteAccountUseCase = deleteAccountUseCase,
       _authStateNotifier = authStateNotifier,
       _getOngoingReservationsUseCase = getOngoingReservationsUseCase,
       _getFullPaymentHistoryUseCase = getFullPaymentHistoryUseCase,
       _getMyEventsUseCase = getMyEventsUseCase {
    _authStateNotifier.addListener(notifyListeners);
    if (user == null) {
      loadProfile();
    } else {
      _fetchTier();
    }
    _loadCounts();
  }

  Future<void> _loadCounts() async {
    final results = await Future.wait([
      _getOngoingReservationsUseCase(),
      _getFullPaymentHistoryUseCase.execute(),
      _getMyEventsUseCase(),
    ]);

    (results[0] as Result<List<dynamic>, Failure>).fold(
      onSuccess: (reservations) {
        _ongoingReservationsCount = reservations.length;
      },
      onFailure: (_) {},
    );

    (results[1] as Result<List<dynamic>, Failure>).fold(
      onSuccess: (payments) {
        _successfulPaymentsCount = payments
            .where(
              (p) =>
                  p.status.toLowerCase() == 'success' ||
                  p.status.toLowerCase() == 'paid',
            )
            .length;
      },
      onFailure: (_) {},
    );

    (results[2] as Result<List<dynamic>, Failure>).fold(
      onSuccess: (participants) {
        _myEventsCount = participants
            .where((p) => p.status != 'withdrawn')
            .length;
      },
      onFailure: (_) {},
    );

    notifyListeners();
  }

  Future<void> _fetchTier() async {
    final tierResult = await _authRepository.getMemberTier();
    tierResult.fold(
      onSuccess: (_) {},
      onFailure: (failure) {
        developer.log('Failed to fetch member tier: $failure');
      },
    );
  }

  @override
  void dispose() {
    _authStateNotifier.removeListener(notifyListeners);
    super.dispose();
  }

  /// Loads the user profile from the auth repository.
  /// This will trigger an update in the global AuthStateNotifier.
  Future<void> loadProfile({bool showLoading = true}) async {
    if (!_authStateNotifier.isAuthenticated) return;

    if (showLoading) {
      _isLoading = true;
    }
    clearError();
    notifyListeners();

    try {
      final result = await _authRepository.getUserProfile();
      result.fold(
        onSuccess: (session) {
          clearError();
          _fetchTier();
        },
        onFailure: (failure) {
          setErrorMessage(failure.message);
          developer.log('Error loading profile: $failure');
        },
      );
    } catch (e, stackTrace) {
      developer.log('Error loading profile', error: e, stackTrace: stackTrace);
    } finally {
      if (showLoading) {
        _isLoading = false;
      }
      notifyListeners();
    }
  }

  /// Refreshes only the Profile screen data endpoints.
  Future<void> reloadProfile() async {
    await loadProfile(showLoading: false);
    await _loadCounts();
  }

  /// Logs out the user.
  Future<Result<void, Failure>> logout() async {
    final result = await _logoutUseCase();
    if (result.isSuccess) {
      // Reset the MainLayout tab to Home to prevent landing on Profile tab upon next login
      MainLayout.tabController.value = 0;
    }
    return result;
  }

  /// Deletes the user's account with confirmation password.
  Future<bool> deleteAccount({required String password}) async {
    _isLoading = true;
    clearError();
    notifyListeners();

    final result = await _deleteAccountUseCase.execute(password: password);
    return result.fold(
      onSuccess: (_) {
        _isLoading = false;
        notifyListeners();
        return true;
      },
      onFailure: (failure) {
        _isLoading = false;
        setErrorMessage(failure.message);
        notifyListeners();
        return false;
      },
    );
  }
}
