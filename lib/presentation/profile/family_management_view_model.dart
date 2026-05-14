import 'package:bourgo_arena_mobile/domain/entities/child_profile.dart';
import 'package:bourgo_arena_mobile/domain/entities/user.dart';
import 'package:bourgo_arena_mobile/domain/usecases/auth/verify_otp_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/auth/request_family_account_otp_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/family/add_child_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/family/get_children_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/family/remove_child_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/user/get_user_profile_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/user/update_user_profile_use_case.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as developer;

/// ViewModel for managing family account and children profiles.
class FamilyManagementViewModel extends ChangeNotifier {
  final GetUserProfileUseCase _getUserProfileUseCase;
  final UpdateUserProfileUseCase _updateUserProfileUseCase;
  final VerifyOtpUseCase _verifyOtpUseCase;
  final RequestFamilyAccountOtpUseCase _requestFamilyAccountOtpUseCase;
  final GetChildrenUseCase _getChildrenUseCase;
  final AddChildUseCase _addChildUseCase;
  final RemoveChildUseCase _removeChildUseCase;

  User? _user;
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
  String? _errorMessage;

  /// Creates a new [FamilyManagementViewModel] instance.
  FamilyManagementViewModel({
    required GetUserProfileUseCase getUserProfileUseCase,
    required UpdateUserProfileUseCase updateUserProfileUseCase,
    required VerifyOtpUseCase verifyOtpUseCase,
    required RequestFamilyAccountOtpUseCase requestFamilyAccountOtpUseCase,
    required GetChildrenUseCase getChildrenUseCase,
    required AddChildUseCase addChildUseCase,
    required RemoveChildUseCase removeChildUseCase,
  }) : _getUserProfileUseCase = getUserProfileUseCase,
       _updateUserProfileUseCase = updateUserProfileUseCase,
       _verifyOtpUseCase = verifyOtpUseCase,
       _requestFamilyAccountOtpUseCase = requestFamilyAccountOtpUseCase,
       _getChildrenUseCase = getChildrenUseCase,
       _addChildUseCase = addChildUseCase,
       _removeChildUseCase = removeChildUseCase {
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

  /// Selected gender for the child being added.
  String? get selectedChildGender => _selectedChildGender;

  /// Selected birth date for the child being added.
  DateTime? get selectedChildBirthDate => _selectedChildBirthDate;

  /// Whether the child's first name has an error.
  bool get hasChildFirstNameError => _hasChildFirstNameError;

  /// Whether the child's last name has an error.
  bool get hasChildLastNameError => _hasChildLastNameError;

  /// Whether the child's gender selection has an error.
  bool get hasChildGenderError => _hasChildGenderError;

  /// Whether the child's birth date has an error.
  bool get hasChildBirthDateError => _hasChildBirthDateError;

  /// Last error message encountered.
  String? get errorMessage => _errorMessage;

  /// Sets the error message manually.
  void setErrorMessage(String? message) {
    _errorMessage = message;
    notifyListeners();
  }

  Future<void> _loadProfile() async {
    _isLoading = true;
    notifyListeners();

    final result = await _getUserProfileUseCase();
    result.when(
      success: (user) async {
        _user = user;
        // Optionally sync children separately if needed,
        // though /user/profile should include them.
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
  Future<bool> requestFamilyAccountOtp() async {
    if (_user == null) return false;

    final result = await _requestFamilyAccountOtpUseCase();
    return result.fold(
      onSuccess: (_) {
        _isOtpSent = true;
        _errorMessage = null;
        notifyListeners();
        return true;
      },
      onFailure: (failure) {
        _errorMessage = failure.message;
        notifyListeners();
        return false;
      },
    );
  }

  /// Verifies the OTP and enables family account.
  Future<bool> verifyFamilyAccountOtp(String otp) async {
    if (_user == null) return false;

    _isVerifyingOtp = true;
    notifyListeners();

    final identifier = _user!.phone?.isNotEmpty == true
        ? _user!.phone!
        : _user!.email;

    final result = await _verifyOtpUseCase(identifier, otp);

    return result.fold(
      onSuccess: (success) async {
        if (success) {
          final updatedUser = _user!.copyWith(isParentAccount: true);
          final updateResult = await _updateUserProfileUseCase(updatedUser);

          updateResult.when(
            success: (user) {
              _user = user;
              _isOtpSent = false;
            },
            failure: (failure) {
              developer.log(
                'Failed to update parent status: ${failure.message}',
              );
            },
          );
        }
        _isVerifyingOtp = false;
        notifyListeners();
        return success;
      },
      onFailure: (failure) {
        _errorMessage = failure.message;
        _isVerifyingOtp = false;
        notifyListeners();
        return false;
      },
    );
  }

  Future<bool> disableFamilyAccount() async {
    if (_user == null) return false;

    final updatedUser = _user!.copyWith(isParentAccount: false, children: []);

    final result = await _updateUserProfileUseCase(updatedUser);
    return result.fold(
      onSuccess: (user) {
        _user = user;
        _errorMessage = null;
        notifyListeners();
        return true;
      },
      onFailure: (failure) {
        _errorMessage = failure.message;
        notifyListeners();
        return false;
      },
    );
  }

  /// Sets the selected gender for the child.
  void setChildGender(String? gender) {
    _selectedChildGender = gender;
    notifyListeners();
  }

  /// Sets the selected birth date for the child.
  void setChildBirthDate(DateTime date) {
    _selectedChildBirthDate = date;
    notifyListeners();
  }

  /// Clears the child addition form.
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

  /// Validates and adds a child from the form state.
  Future<bool> addChildFromForm() async {
    if (_user == null) return false;

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

    final result = await _addChildUseCase.execute(
      firstName: childFirstNameController.text.trim(),
      lastName: childLastNameController.text.trim(),
      birthDate: _selectedChildBirthDate!,
      gender: _selectedChildGender!,
    );

    return result.fold(
      onSuccess: (newChild) {
        if (_user != null) {
          final updatedChildren = List<ChildProfile>.from(_user!.children)
            ..add(newChild);
          _user = _user!.copyWith(children: updatedChildren);
        }
        _errorMessage = null;
        clearChildForm();
        return true;
      },
      onFailure: (failure) {
        _errorMessage = failure.message;
        notifyListeners();
        return false;
      },
    );
  }

  Future<bool> removeChild(String childId) async {
    if (_user == null) return false;

    final result = await _removeChildUseCase.execute(childId);

    return result.fold(
      onSuccess: (_) {
        if (_user != null) {
          final updatedChildren = _user!.children
              .where((c) => c.id != childId)
              .toList();
          _user = _user!.copyWith(children: updatedChildren);
        }
        _errorMessage = null;
        notifyListeners();
        return true;
      },
      onFailure: (failure) {
        _errorMessage = failure.message;
        notifyListeners();
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
