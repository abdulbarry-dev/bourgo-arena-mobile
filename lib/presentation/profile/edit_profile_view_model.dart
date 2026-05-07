import 'package:bourgo_arena_mobile/data/models/user_profile.dart';
import 'package:bourgo_arena_mobile/data/services/auth_service.dart';
import 'package:bourgo_arena_mobile/data/services/data_service.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as developer;

/// ViewModel for the Edit Profile screen.
class EditProfileViewModel extends ChangeNotifier {
  final DataService _dataService;

  UserProfile? _profile;
  bool _isLoading = true;
  bool _isSaving = false;

  EditProfileViewModel({
    required DataService dataService,
    required AuthService authService,
  }) : _dataService = dataService {
    _loadProfile();
  }

  UserProfile? get profile => _profile;
  bool get isLoading => _isLoading;
  bool get isSaving => _isSaving;

  Future<void> _loadProfile() async {
    try {
      _profile = await _dataService.getUserProfile();
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
    if (_profile == null) return false;

    _isSaving = true;
    notifyListeners();

    try {
      final updatedProfile = _profile!.copyWith(
        firstName: firstName,
        lastName: lastName,
        email: email,
        phone: phone,
        birthDate: birthDate,
      );
      await _dataService.updateProfile(updatedProfile);
      _profile = updatedProfile;
      return true;
    } catch (e) {
      return false;
    } finally {
      _isSaving = false;
      notifyListeners();
    }
  }
}
