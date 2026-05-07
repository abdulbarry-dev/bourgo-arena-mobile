import 'package:bourgo_arena_mobile/data/models/child_profile_model.dart';
import 'package:bourgo_arena_mobile/data/models/user_profile.dart';

import 'package:bourgo_arena_mobile/domain/usecases/auth/verify_otp_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/auth/request_family_account_otp_use_case.dart';
import 'package:bourgo_arena_mobile/data/services/data_service.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as developer;

/// ViewModel for managing family account and children profiles.
class FamilyManagementViewModel extends ChangeNotifier {
  final DataService _dataService;

  final VerifyOtpUseCase _verifyOtpUseCase;
  final RequestFamilyAccountOtpUseCase _requestFamilyAccountOtpUseCase;

  UserProfile? _profile;
  bool _isLoading = true;
  bool _isOtpSent = false;
  bool _isVerifyingOtp = false;

  // --- Family Member Form State ---
  final childFirstNameController = TextEditingController();
  final childLastNameController = TextEditingController();
  final childBirthDateController = TextEditingController();
  String? _selectedChildGender;
  DateTime? _selectedChildBirthDate;

  bool _hasChildFirstNameError = false;
  bool _hasChildLastNameError = false;
  bool _hasChildGenderError = false;
  bool _hasChildBirthDateError = false;

  FamilyManagementViewModel({
    required DataService dataService,
    required VerifyOtpUseCase verifyOtpUseCase,
    required RequestFamilyAccountOtpUseCase requestFamilyAccountOtpUseCase,
  }) : _dataService = dataService,
       _verifyOtpUseCase = verifyOtpUseCase,
       _requestFamilyAccountOtpUseCase = requestFamilyAccountOtpUseCase {
    _loadProfile();
  }

  UserProfile? get profile => _profile;
  bool get isLoading => _isLoading;
  bool get isOtpSent => _isOtpSent;
  bool get isVerifyingOtp => _isVerifyingOtp;

  String? get selectedChildGender => _selectedChildGender;
  DateTime? get selectedChildBirthDate => _selectedChildBirthDate;

  bool get hasChildFirstNameError => _hasChildFirstNameError;
  bool get hasChildLastNameError => _hasChildLastNameError;
  bool get hasChildGenderError => _hasChildGenderError;
  bool get hasChildBirthDateError => _hasChildBirthDateError;

  Future<void> _loadProfile() async {
    try {
      _profile = await _dataService.getUserProfile();
    } catch (e, stackTrace) {
      developer.log(
        'Error loading profile for family management',
        error: e,
        stackTrace: stackTrace,
      );
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Requests an OTP to enable family account.
  Future<bool> requestFamilyAccountOtp() async {
    if (_profile == null) return false;

    final result = await _requestFamilyAccountOtpUseCase();
    return result.fold(
      onSuccess: (_) {
        _isOtpSent = true;
        notifyListeners();
        return true;
      },
      onFailure: (_) => false,
    );
  }

  /// Verifies the OTP and enables family account.
  Future<bool> verifyFamilyAccountOtp(String otp) async {
    if (_profile == null) return false;

    _isVerifyingOtp = true;
    notifyListeners();

    final identifier = _profile!.phone.isNotEmpty
        ? _profile!.phone
        : _profile!.email;
        
    final result = await _verifyOtpUseCase(identifier, otp);
    
    return result.fold(
      onSuccess: (success) async {
        if (success) {
          final updatedProfile = _profile!.copyWith(isParentAccount: true);
          await _dataService.updateProfile(updatedProfile);
          _profile = updatedProfile;
          _isOtpSent = false;
        }
        _isVerifyingOtp = false;
        notifyListeners();
        return success;
      },
      onFailure: (_) {
        _isVerifyingOtp = false;
        notifyListeners();
        return false;
      },
    );
  }

  /// Disables family account features.
  Future<bool> disableFamilyAccount() async {
    if (_profile == null) return false;

    try {
      final updatedProfile = _profile!.copyWith(
        isParentAccount: false,
        children: [],
      );
      await _dataService.updateProfile(updatedProfile);
      _profile = updatedProfile;
      notifyListeners();
      return true;
    } catch (e) {
      return false;
    }
  }

  void setChildGender(String? gender) {
    _selectedChildGender = gender;
    notifyListeners();
  }

  void setChildBirthDate(DateTime date) {
    _selectedChildBirthDate = date;
    notifyListeners();
  }

  void clearChildForm() {
    childFirstNameController.clear();
    childLastNameController.clear();
    childBirthDateController.clear();
    _selectedChildGender = null;
    _selectedChildBirthDate = null;
    _hasChildFirstNameError = false;
    _hasChildLastNameError = false;
    _hasChildGenderError = false;
    _hasChildBirthDateError = false;
    notifyListeners();
  }

  Future<bool> addChildFromForm() async {
    _hasChildFirstNameError = childFirstNameController.text.trim().isEmpty;
    _hasChildLastNameError = childLastNameController.text.trim().isEmpty;
    _hasChildBirthDateError = _selectedChildBirthDate == null;
    _hasChildGenderError = _selectedChildGender == null;

    if (_hasChildFirstNameError ||
        _hasChildLastNameError ||
        _hasChildBirthDateError ||
        _hasChildGenderError) {
      notifyListeners();
      return false;
    }

    final newChild = ChildProfileModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      firstName: childFirstNameController.text.trim(),
      lastName: childLastNameController.text.trim(),
      birthDate: _selectedChildBirthDate!,
      gender: _selectedChildGender!,
    );

    final updatedChildren = List<ChildProfileModel>.from(_profile!.children)
      ..add(newChild);
    final updatedProfile = _profile!.copyWith(children: updatedChildren);

    try {
      await _dataService.updateProfile(updatedProfile);
      _profile = updatedProfile;
      clearChildForm();
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

  @override
  void dispose() {
    childFirstNameController.dispose();
    childLastNameController.dispose();
    childBirthDateController.dispose();
    super.dispose();
  }
}
