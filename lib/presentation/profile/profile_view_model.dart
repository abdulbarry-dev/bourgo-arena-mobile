import 'package:bourgo_arena_mobile/core/utils/result.dart';
import 'package:bourgo_arena_mobile/domain/core/failure.dart';
import 'package:bourgo_arena_mobile/domain/entities/user.dart';
import 'package:bourgo_arena_mobile/domain/usecases/auth/logout_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/user/get_user_profile_use_case.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as developer;

/// ViewModel for the Profile screen.
class ProfileViewModel extends ChangeNotifier {
  final GetUserProfileUseCase _getUserProfileUseCase;
  final LogoutUseCase _logoutUseCase;

  User? _user;
  bool _isLoading = false;

  /// The user's profile data.
  User? get user => _user;

  /// Whether data is currently being loaded.
  bool get isLoading => _isLoading;

  /// Creates a new [ProfileViewModel] instance.
  ProfileViewModel({
    required GetUserProfileUseCase getUserProfileUseCase,
    required LogoutUseCase logoutUseCase,
  }) : _getUserProfileUseCase = getUserProfileUseCase,
       _logoutUseCase = logoutUseCase {
    loadProfile();
  }

  /// Loads the user profile from the data service.
  Future<void> loadProfile() async {
    _isLoading = true;
    notifyListeners();

    try {
      final result = await _getUserProfileUseCase();
      result.when(
        success: (data) => _user = data,
        failure: (failure) => developer.log('Error loading profile: $failure'),
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
}
