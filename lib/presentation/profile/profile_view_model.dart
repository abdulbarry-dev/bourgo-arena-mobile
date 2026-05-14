import 'package:bourgo_arena_mobile/core/utils/result.dart';
import 'package:bourgo_arena_mobile/domain/core/failure.dart';
import 'package:bourgo_arena_mobile/domain/entities/user.dart';
import 'package:bourgo_arena_mobile/domain/repositories/auth_repository.dart';
import 'package:bourgo_arena_mobile/domain/usecases/auth/logout_use_case.dart';
import 'package:bourgo_arena_mobile/presentation/auth/auth_state_notifier.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as developer;

/// ViewModel for the Profile screen.
class ProfileViewModel extends ChangeNotifier {
  final AuthRepository _authRepository;
  final LogoutUseCase _logoutUseCase;
  final AuthStateNotifier _authStateNotifier;

  bool _isLoading = false;
  String? _errorMessage;

  /// The user's profile data, sourced from the global AuthStateNotifier.
  User? get user => _authStateNotifier.currentUser;

  /// Whether data is currently being loaded.
  bool get isLoading => _isLoading;

  /// Error message if loading or updating fails.
  String? get errorMessage => _errorMessage;

  /// Creates a new [ProfileViewModel] instance.
  ProfileViewModel({
    required AuthRepository authRepository,
    required LogoutUseCase logoutUseCase,
    required AuthStateNotifier authStateNotifier,
  }) : _authRepository = authRepository,
       _logoutUseCase = logoutUseCase,
       _authStateNotifier = authStateNotifier {
    _authStateNotifier.addListener(notifyListeners);
    if (user == null) {
      loadProfile();
    }
  }

  @override
  void dispose() {
    _authStateNotifier.removeListener(notifyListeners);
    super.dispose();
  }

  /// Loads the user profile from the auth repository.
  /// This will trigger an update in the global AuthStateNotifier.
  Future<void> loadProfile() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final result = await _authRepository.getUserProfile();
      result.fold(
        onSuccess: (session) {
          _errorMessage = null;
        },
        onFailure: (failure) {
          _errorMessage = failure.message;
          developer.log('Error loading profile: $failure');
        },
      );
    } catch (e, stackTrace) {
      _errorMessage = 'An unexpected error occurred';
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
}
