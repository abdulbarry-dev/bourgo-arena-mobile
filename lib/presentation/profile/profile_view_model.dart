import 'package:bourgo_arena_mobile/core/utils/result.dart';
import 'package:bourgo_arena_mobile/domain/core/failure.dart';
import 'package:bourgo_arena_mobile/domain/entities/user.dart';
import 'package:bourgo_arena_mobile/domain/usecases/auth/logout_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/user/get_user_profile_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/user/update_user_profile_use_case.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as developer;

/// ViewModel for the Profile screen.
class ProfileViewModel extends ChangeNotifier {
  final GetUserProfileUseCase _getUserProfileUseCase;
  final UpdateUserProfileUseCase _updateUserProfileUseCase;
  final LogoutUseCase _logoutUseCase;

  User? _user;
  bool _isLoading = false;
  String? _errorMessage;

  /// The user's profile data.
  User? get user => _user;

  /// Whether data is currently being loaded.
  bool get isLoading => _isLoading;

  /// Error message if loading or updating fails.
  String? get errorMessage => _errorMessage;

  /// Creates a new [ProfileViewModel] instance.
  ProfileViewModel({
    required GetUserProfileUseCase getUserProfileUseCase,
    required UpdateUserProfileUseCase updateUserProfileUseCase,
    required LogoutUseCase logoutUseCase,
  }) : _getUserProfileUseCase = getUserProfileUseCase,
       _updateUserProfileUseCase = updateUserProfileUseCase,
       _logoutUseCase = logoutUseCase {
    loadProfile();
  }

  /// Loads the user profile from the data service.
  Future<void> loadProfile() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final result = await _getUserProfileUseCase();
      result.when(
        success: (data) {
          _user = data;
          _errorMessage = null;
        },
        failure: (failure) {
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

  /// Updates the user's profile.
  Future<Result<User, Failure>> updateProfile(User updatedUser) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final result = await _updateUserProfileUseCase(updatedUser);

    result.when(
      success: (data) {
        _user = data;
        _errorMessage = null;
      },
      failure: (failure) {
        _errorMessage = failure.message;
      },
    );

    _isLoading = false;
    notifyListeners();
    return result;
  }

  /// Logs out the user.
  Future<Result<void, Failure>> logout() async {
    return _logoutUseCase();
  }
}
