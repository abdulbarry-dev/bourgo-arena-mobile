import 'package:bourgo_arena_mobile/data/models/child_profile_model.dart';
import 'package:bourgo_arena_mobile/data/models/user_profile.dart';
import 'package:bourgo_arena_mobile/data/services/auth_service.dart';
import 'package:bourgo_arena_mobile/data/services/data_service.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as developer;

/// ViewModel for the Edit Profile screen.
class EditProfileViewModel extends ChangeNotifier {
  final DataService _dataService;
  final AuthService _authService;

  UserProfile? _profile;
  bool _isLoading = true;
  bool _isSaving = false;
  bool _isOtpSent = false;
  bool _isVerifyingOtp = false;

  EditProfileViewModel({
    required DataService dataService,
    required AuthService authService,
  }) : _dataService = dataService,
       _authService = authService {
    _loadProfile();
  }

  UserProfile? get profile => _profile;
  bool get isLoading => _isLoading;
  bool get isSaving => _isSaving;
  bool get isOtpSent => _isOtpSent;
  bool get isVerifyingOtp => _isVerifyingOtp;

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

  /// Requests an OTP to enable family account.
  Future<bool> requestFamilyAccountOtp() async {
    if (_profile == null) return false;

    try {
      // Use phone if available, else email
      final identifier = _profile!.phone.isNotEmpty
          ? _profile!.phone
          : _profile!.email;
      await _authService.sendOtp(identifier);
      _isOtpSent = true;
      notifyListeners();
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Verifies the OTP and enables family account.
  Future<bool> verifyFamilyAccountOtp(String otp) async {
    if (_profile == null) return false;

    _isVerifyingOtp = true;
    notifyListeners();

    try {
      final identifier = _profile!.phone.isNotEmpty
          ? _profile!.phone
          : _profile!.email;
      final success = await _authService.verifyOtp(identifier, otp);

      if (success) {
        final updatedProfile = _profile!.copyWith(isParentAccount: true);
        await _dataService.updateProfile(updatedProfile);
        _profile = updatedProfile;
        _isOtpSent = false;
      }
      return success;
    } catch (e) {
      return false;
    } finally {
      _isVerifyingOtp = false;
      notifyListeners();
    }
  }

  /// Adds a child profile.
  Future<bool> addChild(ChildProfileModel child) async {
    if (_profile == null) return false;

    try {
      final updatedChildren = List<ChildProfileModel>.from(_profile!.children)
        ..add(child);
      final updatedProfile = _profile!.copyWith(children: updatedChildren);
      await _dataService.updateProfile(updatedProfile);
      _profile = updatedProfile;
      notifyListeners();
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Removes a child profile.
  Future<bool> removeChild(String childId) async {
    if (_profile == null) return false;

    try {
      final updatedChildren = _profile!.children
          .where((c) => c.id != childId)
          .toList();
      final updatedProfile = _profile!.copyWith(children: updatedChildren);
      await _dataService.updateProfile(updatedProfile);
      _profile = updatedProfile;
      notifyListeners();
      return true;
    } catch (e) {
      return false;
    }
  }
}
