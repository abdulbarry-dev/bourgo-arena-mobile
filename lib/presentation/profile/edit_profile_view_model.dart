import 'package:bourgo_arena_mobile/data/models/user_profile.dart';
import 'package:bourgo_arena_mobile/data/services/data_service.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as developer;

/// ViewModel for the Edit Profile screen.
class EditProfileViewModel extends ChangeNotifier {
  final DataService _dataService;

  UserProfile? _profile;
  bool _isLoading = true;
  bool _isSaving = false;

  EditProfileViewModel({required DataService dataService})
    : _dataService = dataService {
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

  Future<bool> saveProfile({
    required String name,
    required String email,
    required String phone,
  }) async {
    if (_profile == null) return false;

    _isSaving = true;
    notifyListeners();

    try {
      final updatedProfile = _profile!.copyWith(
        name: name,
        email: email,
        phone: phone,
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
