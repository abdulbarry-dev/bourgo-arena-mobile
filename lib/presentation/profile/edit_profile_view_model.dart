import 'package:bourgo_arena_mobile/domain/entities/user.dart';
import 'package:bourgo_arena_mobile/domain/repositories/auth_repository.dart';
import 'package:bourgo_arena_mobile/domain/usecases/user/update_user_profile_use_case.dart';
import 'package:bourgo_arena_mobile/presentation/auth/auth_state_notifier.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as developer;

/// ViewModel for the Edit Profile screen.
class EditProfileViewModel extends ChangeNotifier {
  final UpdateUserProfileUseCase _updateUserProfileUseCase;
  final AuthRepository _authRepository;
  final AuthStateNotifier _authStateNotifier;

  bool _isLoading = true;
  bool _isSaving = false;

  EditProfileViewModel({
    required UpdateUserProfileUseCase updateUserProfileUseCase,
    required AuthRepository authRepository,
    required AuthStateNotifier authStateNotifier,
  }) : _updateUserProfileUseCase = updateUserProfileUseCase,
       _authRepository = authRepository,
       _authStateNotifier = authStateNotifier {
    _authStateNotifier.addListener(notifyListeners);
    _loadProfile();
  }

  /// The user's profile data, sourced from the global AuthStateNotifier.
  User? get user => _authStateNotifier.currentUser;

  bool get isLoading => _isLoading;
  bool get isSaving => _isSaving;

  @override
  void dispose() {
    _authStateNotifier.removeListener(notifyListeners);
    super.dispose();
  }

  Future<void> _loadProfile() async {
    if (user != null) {
      _isLoading = false;
      notifyListeners();
      return;
    }

    try {
      // Use the auth repository to fetch the profile so it updates the global state
      await _authRepository.getUserProfile();
    } catch (e, stackTrace) {
      developer.log('Error loading profile', error: e, stackTrace: stackTrace);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Saves the updated profile information.
  Future<bool> saveProfile({
    required String firstName,
    required String lastName,
    required String email,
    required String phone,
    DateTime? birthDate,
  }) async {
    if (user == null) return false;

    _isSaving = true;
    notifyListeners();

    try {
      final updatedUser = user!.copyWith(
        firstName: firstName,
        lastName: lastName,
        email: email,
        phone: phone,
        birthDate: birthDate,
      );
      final result = await _updateUserProfileUseCase(updatedUser);
      return await result.fold(
        onSuccess: (data) async {
          // After a successful update, refresh the global session state
          // to ensure all other view models (like ProfileViewModel) stay in sync.
          await _authRepository.getUserProfile();
          return true;
        },
        onFailure: (failure) => false,
      );
    } catch (e) {
      return false;
    } finally {
      _isSaving = false;
      notifyListeners();
    }
  }
}
