import 'package:bourgo_arena_mobile/domain/entities/user.dart';
import 'package:bourgo_arena_mobile/domain/usecases/user/get_user_profile_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/user/update_user_profile_use_case.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as developer;

/// ViewModel for the Edit Profile screen.
class EditProfileViewModel extends ChangeNotifier {
  final GetUserProfileUseCase _getUserProfileUseCase;
  final UpdateUserProfileUseCase _updateUserProfileUseCase;

  User? _user;
  bool _isLoading = true;
  bool _isSaving = false;

  EditProfileViewModel({
    required GetUserProfileUseCase getUserProfileUseCase,
    required UpdateUserProfileUseCase updateUserProfileUseCase,
  }) : _getUserProfileUseCase = getUserProfileUseCase,
       _updateUserProfileUseCase = updateUserProfileUseCase {
    _loadProfile();
  }

  User? get user => _user;
  bool get isLoading => _isLoading;
  bool get isSaving => _isSaving;

  Future<void> _loadProfile() async {
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

  /// Saves the updated profile information.
  Future<bool> saveProfile({
    required String firstName,
    required String lastName,
    required String email,
    required String phone,
    DateTime? birthDate,
  }) async {
    if (_user == null) return false;

    _isSaving = true;
    notifyListeners();

    try {
      final updatedUser = _user!.copyWith(
        firstName: firstName,
        lastName: lastName,
        email: email,
        phone: phone,
        birthDate: birthDate,
      );
      final result = await _updateUserProfileUseCase(updatedUser);
      return result.when(
        success: (data) {
          _user = data;
          return true;
        },
        failure: (failure) => false,
      );
    } catch (e) {
      return false;
    } finally {
      _isSaving = false;
      notifyListeners();
    }
  }
}
