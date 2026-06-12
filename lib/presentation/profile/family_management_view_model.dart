import 'package:bourgo_arena_mobile/core/base/base_view_model.dart';
import 'package:bourgo_arena_mobile/domain/entities/user.dart';
import 'package:bourgo_arena_mobile/domain/entities/otp_delivery_method.dart';
import 'package:bourgo_arena_mobile/domain/usecases/auth/auth_use_cases.dart';
import 'package:bourgo_arena_mobile/domain/entities/verification_status.dart';
import 'package:bourgo_arena_mobile/domain/usecases/family/add_child_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/family/get_children_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/family/remove_child_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/family/disable_family_feature_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/user/get_user_profile_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/family/enable_family_feature_use_case.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as developer;

/// ViewModel for managing family account and children profiles.
class FamilyManagementViewModel extends BaseViewModel {
  final GetUserProfileUseCase _getUserProfileUseCase;
  final GetVerificationStatusUseCase _getVerificationStatusUseCase;
  final EnableFamilyFeatureUseCase _enableFamilyFeatureUseCase;
  final VerifyOtpUseCase _verifyOtpUseCase;
  final RequestFamilyAccountOtpUseCase _requestFamilyAccountOtpUseCase;
  final GetChildrenUseCase _getChildrenUseCase;
  final AddChildUseCase _addChildUseCase;
  final RemoveChildUseCase _removeChildUseCase;
  final DisableFamilyFeatureUseCase _disableFamilyFeatureUseCase;

  User? _user;
  bool _isLoading = true;
  bool _isOtpSent = false;
  bool _isVerifyingOtp = false;
  OtpDeliveryMethod? _selectedOtpMethod;
  String? _selectedOtpIdentifier;
  String? _otpRequestMessage;

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

  /// Creates a new [FamilyManagementViewModel] instance.
  FamilyManagementViewModel({
    required GetUserProfileUseCase getUserProfileUseCase,
    required GetVerificationStatusUseCase getVerificationStatusUseCase,
    required EnableFamilyFeatureUseCase enableFamilyFeatureUseCase,
    required VerifyOtpUseCase verifyOtpUseCase,
    required RequestFamilyAccountOtpUseCase requestFamilyAccountOtpUseCase,
    required GetChildrenUseCase getChildrenUseCase,
    required AddChildUseCase addChildUseCase,
    required RemoveChildUseCase removeChildUseCase,
    required DisableFamilyFeatureUseCase disableFamilyFeatureUseCase,
  }) : _getUserProfileUseCase = getUserProfileUseCase,
       _getVerificationStatusUseCase = getVerificationStatusUseCase,
       _enableFamilyFeatureUseCase = enableFamilyFeatureUseCase,
       _verifyOtpUseCase = verifyOtpUseCase,
       _requestFamilyAccountOtpUseCase = requestFamilyAccountOtpUseCase,
       _getChildrenUseCase = getChildrenUseCase,
       _addChildUseCase = addChildUseCase,
       _removeChildUseCase = removeChildUseCase,
       _disableFamilyFeatureUseCase = disableFamilyFeatureUseCase {
    _loadProfile();
  }

  /// Current user profile.
  User? get user => _user;

  /// Whether the initial profile is loading.
  bool get isLoading => _isLoading;

  /// Whether an OTP has been sent.
  bool get isOtpSent => _isOtpSent;

  /// Whether an OTP is currently being verified.
  bool get isVerifyingOtp => _isVerifyingOtp;
  OtpDeliveryMethod? get selectedOtpMethod => _selectedOtpMethod;
  String? get selectedOtpIdentifier => _selectedOtpIdentifier;
  String? get otpRequestMessage => _otpRequestMessage;

  String? get selectedChildGender => _selectedChildGender;
  DateTime? get selectedChildBirthDate => _selectedChildBirthDate;
  bool get hasChildFirstNameError => _hasChildFirstNameError;
  bool get hasChildLastNameError => _hasChildLastNameError;
  bool get hasChildGenderError => _hasChildGenderError;
  bool get hasChildBirthDateError => _hasChildBirthDateError;

  void setChildGender(String? gender) {
    _selectedChildGender = gender;
    _hasChildGenderError = false;
    notifyListeners();
  }

  void setChildBirthDate(DateTime birthDate) {
    _selectedChildBirthDate = birthDate;
    _hasChildBirthDateError = false;
    childBirthDateController.text = birthDate.toIso8601String().split('T')[0];
    notifyListeners();
  }

  bool _validateChildForm() {
    _hasChildFirstNameError = childFirstNameController.text.trim().isEmpty;
    _hasChildLastNameError = childLastNameController.text.trim().isEmpty;
    _hasChildGenderError = _selectedChildGender == null;
    _hasChildBirthDateError = _selectedChildBirthDate == null;
    notifyListeners();
    return !_hasChildFirstNameError &&
        !_hasChildLastNameError &&
        !_hasChildGenderError &&
        !_hasChildBirthDateError;
  }

  /// Fetches the user's current verification status.
  Future<VerificationStatus?> getVerificationStatus() async {
    final result = await _getVerificationStatusUseCase();
    return result.fold(
      onSuccess: (status) => status,
      onFailure: (failure) {
        setErrorMessage(failure.message);
        return null;
      },
    );
  }

  Future<bool> addChildFromForm() async {
    if (_user == null || !_validateChildForm()) return false;

    final result = await _addChildUseCase.execute(
      firstName: childFirstNameController.text.trim(),
      lastName: childLastNameController.text.trim(),
      birthDate: _selectedChildBirthDate!,
      gender: _selectedChildGender!,
    );

    bool success = false;
    result.when(
      success: (child) {
        _user = _user!.copyWith(children: [..._user!.children, child]);
        childFirstNameController.clear();
        childLastNameController.clear();
        childBirthDateController.clear();
        _selectedChildGender = null;
        _selectedChildBirthDate = null;
        _hasChildFirstNameError = false;
        _hasChildLastNameError = false;
        _hasChildGenderError = false;
        _hasChildBirthDateError = false;
        clearError();
        success = true;
      },
      failure: (failure) {
        setErrorMessage(failure.message);
        developer.log('Failed to add child: ${failure.message}');
      },
    );

    notifyListeners();
    return success;
  }

  Future<bool> removeChild(String childId) async {
    if (_user == null) return false;

    final result = await _removeChildUseCase.execute(childId);
    bool success = false;
    result.when(
      success: (_) {
        _user = _user!.copyWith(
          children: _user!.children
              .where((child) => child.id != childId)
              .toList(),
        );
        clearError();
        success = true;
      },
      failure: (failure) {
        setErrorMessage(failure.message);
        developer.log('Failed to remove child: ${failure.message}');
      },
    );

    notifyListeners();
    return success;
  }

  Future<void> _loadProfile() async {
    _isLoading = true;
    notifyListeners();

    final result = await _getUserProfileUseCase();
    result.when(
      success: (user) async {
        _user = user;
        if (user.isParentAccount) {
          await _refreshChildren();
        }
      },
      failure: (failure) {
        developer.log(
          'Error loading profile for family management: ${failure.message}',
        );
      },
    );

    _isLoading = false;
    notifyListeners();
  }

  Future<void> _refreshChildren() async {
    if (_user == null) return;

    final result = await _getChildrenUseCase.execute();
    result.when(
      success: (children) {
        _user = _user!.copyWith(children: children);
      },
      failure: (failure) {
        developer.log('Error refreshing children: ${failure.message}');
      },
    );
  }

  /// Requests an OTP to enable family account.
  Future<bool> requestFamilyAccountOtp({
    required OtpDeliveryMethod method,
    required String identifier,
  }) async {
    if (_user == null) return false;

    final normalizedIdentifier = identifier.trim();
    if (normalizedIdentifier.isEmpty) {
      setErrorMessage('No verified contact is available for this method.');
      return false;
    }

    // Defensive: ensure the method is currently verified for this user
    final verificationResult = await _getVerificationStatusUseCase();
    final isMethodVerified = verificationResult.fold(
      onSuccess: (status) {
        if (method == OtpDeliveryMethod.email) return status.emailVerified;
        if (method == OtpDeliveryMethod.phone) return status.phoneVerified;
        return false;
      },
      onFailure: (_) => false,
    );

    if (!isMethodVerified) {
      setErrorMessage('Selected contact method is not verified.');
      return false;
    }

    final result = await _requestFamilyAccountOtpUseCase(method: method);
    return result.fold(
      onSuccess: (message) {
        _selectedOtpMethod = method;
        _selectedOtpIdentifier = normalizedIdentifier;
        _otpRequestMessage = message;
        _isOtpSent = true;
        clearError();
        notifyListeners();
        return true;
      },
      onFailure: (failure) {
        _otpRequestMessage = null;
        setErrorMessage(failure.message);
        return false;
      },
    );
  }

  /// Verifies the OTP and enables family account.
  Future<bool> verifyFamilyAccountOtp(String otp) async {
    if (_user == null) return false;

    _isVerifyingOtp = true;
    notifyListeners();

    final identifier = _selectedOtpIdentifier;
    if (identifier == null || identifier.isEmpty) {
      setErrorMessage('Please request a verification code first.');
      _isVerifyingOtp = false;
      notifyListeners();
      return false;
    }

    final result = await _verifyOtpUseCase(identifier, otp);

    return result.fold(
      onSuccess: (success) async {
        if (!success) {
          _isVerifyingOtp = false;
          notifyListeners();
          return false;
        }

        final enableResult = await _enableFamilyFeatureUseCase();
        final finalSuccess = enableResult.fold(
          onSuccess: (isParentAccount) {
            _user = _user!.copyWith(isParentAccount: isParentAccount);
            _isOtpSent = false;
            _selectedOtpMethod = null;
            _selectedOtpIdentifier = null;
            _otpRequestMessage = null;
            return true;
          },
          onFailure: (failure) {
            setErrorMessage(failure.message);
            developer.log(
              'Failed to enable family feature: ${failure.message}',
            );
            return false;
          },
        );

        _isVerifyingOtp = false;
        notifyListeners();
        return finalSuccess;
      },
      onFailure: (failure) {
        setErrorMessage(failure.message);
        _isVerifyingOtp = false;
        notifyListeners();
        return false;
      },
    );
  }

  Future<bool> disableFamilyAccount() async {
    if (_user == null) return false;

    final result = await _disableFamilyFeatureUseCase();
    return result.fold(
      onSuccess: (_) {
        _user = _user!.copyWith(isParentAccount: false, children: []);
        clearError();
        return true;
      },
      onFailure: (failure) {
        setErrorMessage(failure.message);
        return false;
      },
    );
  }

  @override
  void dispose() {
    childFirstNameController.dispose();
    childLastNameController.dispose();
    childBirthDateController.dispose();
    super.dispose();
  }
}
