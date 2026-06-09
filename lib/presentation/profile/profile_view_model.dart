import 'package:bourgo_arena_mobile/core/base/base_view_model.dart';
import 'package:bourgo_arena_mobile/core/utils/result.dart';
import 'package:bourgo_arena_mobile/domain/core/failure.dart';
import 'package:bourgo_arena_mobile/domain/entities/user.dart';
import 'package:bourgo_arena_mobile/domain/repositories/auth_repository.dart';
import 'package:bourgo_arena_mobile/domain/usecases/auth/logout_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/auth/delete_account_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/booking/get_ongoing_reservations_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/payment/get_full_payment_history_use_case.dart';
import 'package:bourgo_arena_mobile/presentation/auth/auth_state_notifier.dart';
import 'dart:developer' as developer;

/// ViewModel for the Profile screen.
class ProfileViewModel extends BaseViewModel {
  final AuthRepository _authRepository;
  final LogoutUseCase _logoutUseCase;
  final DeleteAccountUseCase _deleteAccountUseCase;
  final AuthStateNotifier _authStateNotifier;
  final GetOngoingReservationsUseCase _getOngoingReservationsUseCase;
  final GetFullPaymentHistoryUseCase _getFullPaymentHistoryUseCase;

  bool _isLoading = false;
  int _ongoingReservationsCount = 0;
  int _successfulPaymentsCount = 0;

  /// The user's profile data, sourced from the global AuthStateNotifier.
  User? get user => _authStateNotifier.currentUser;

  /// Whether data is currently being loaded.
  bool get isLoading => _isLoading;

  /// The count of ongoing reservations for the current user.
  int get ongoingReservationsCount => _ongoingReservationsCount;

  /// The count of successfully completed payments.
  int get successfulPaymentsCount => _successfulPaymentsCount;

  /// Creates a new [ProfileViewModel] instance.
  ProfileViewModel({
    required AuthRepository authRepository,
    required LogoutUseCase logoutUseCase,
    required DeleteAccountUseCase deleteAccountUseCase,
    required AuthStateNotifier authStateNotifier,
    required GetOngoingReservationsUseCase getOngoingReservationsUseCase,
    required GetFullPaymentHistoryUseCase getFullPaymentHistoryUseCase,
  }) : _authRepository = authRepository,
       _logoutUseCase = logoutUseCase,
       _deleteAccountUseCase = deleteAccountUseCase,
       _authStateNotifier = authStateNotifier,
       _getOngoingReservationsUseCase = getOngoingReservationsUseCase,
       _getFullPaymentHistoryUseCase = getFullPaymentHistoryUseCase {
    _authStateNotifier.addListener(notifyListeners);
    if (user == null) {
      loadProfile();
    } else {
      _fetchTier();
    }
    _loadCounts();
  }

  Future<void> _loadCounts() async {
    final reservationResult = await _getOngoingReservationsUseCase();
    reservationResult.fold(
      onSuccess: (reservations) {
        _ongoingReservationsCount = reservations.length;
      },
      onFailure: (_) {},
    );

    final paymentResult = await _getFullPaymentHistoryUseCase.execute();
    paymentResult.fold(
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
  Future<void> loadProfile() async {
    if (!_authStateNotifier.isAuthenticated) return;

    _isLoading = true;
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
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Logs out the user.
  Future<Result<void, Failure>> logout() async {
    return _logoutUseCase();
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
