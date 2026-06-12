import 'package:bourgo_arena_mobile/core/base/base_view_model.dart';
import 'package:bourgo_arena_mobile/domain/entities/child_profile.dart';
import 'package:bourgo_arena_mobile/domain/usecases/family/add_child_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/family/update_child_use_case.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as developer;

/// ViewModel for adding/editing a child profile.
class AddEditChildViewModel extends BaseViewModel {
  final AddChildUseCase _addChildUseCase;
  final UpdateChildUseCase _updateChildUseCase;
  final ChildProfile? _existingChild;

  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final birthDateController = TextEditingController();

  String? _selectedGender;
  DateTime? _selectedBirthDate;
  String? _avatarFilePath;
  bool _isSubmitting = false;

  bool _hasFirstNameError = false;
  bool _hasLastNameError = false;
  bool _hasGenderError = false;
  bool _hasBirthDateError = false;

  AddEditChildViewModel({
    required AddChildUseCase addChildUseCase,
    required UpdateChildUseCase updateChildUseCase,
    ChildProfile? child,
  }) : _addChildUseCase = addChildUseCase,
       _updateChildUseCase = updateChildUseCase,
       _existingChild = child {
    if (child != null) {
      _initializeFromChild(child);
    }
  }

  // Getters
  String? get selectedGender => _selectedGender;
  DateTime? get selectedBirthDate => _selectedBirthDate;
  String? get avatarFilePath => _avatarFilePath;
  bool get isSubmitting => _isSubmitting;
  bool get isEditing => _existingChild != null;
  bool get hasFirstNameError => _hasFirstNameError;
  bool get hasLastNameError => _hasLastNameError;
  bool get hasGenderError => _hasGenderError;
  bool get hasBirthDateError => _hasBirthDateError;

  void setAvatarFilePath(String? path) {
    _avatarFilePath = path;
    notifyListeners();
  }

  void _initializeFromChild(ChildProfile child) {
    firstNameController.text = child.firstName;
    lastNameController.text = child.lastName;
    _selectedGender = child.gender;
    _selectedBirthDate = child.birthDate;
    birthDateController.text = child.birthDate.toString().split(' ')[0];
  }

  void setGender(String? gender) {
    _selectedGender = gender;
    _hasGenderError = false;
    notifyListeners();
  }

  void setBirthDate(DateTime date) {
    _selectedBirthDate = date;
    _hasBirthDateError = false;
    birthDateController.text = date.toString().split(' ')[0];
    notifyListeners();
  }

  bool _validateForm() {
    _hasFirstNameError = firstNameController.text.trim().isEmpty;
    _hasLastNameError = lastNameController.text.trim().isEmpty;
    _hasGenderError = _selectedGender == null;
    _hasBirthDateError = _selectedBirthDate == null;

    notifyListeners();
    return !_hasFirstNameError &&
        !_hasLastNameError &&
        !_hasGenderError &&
        !_hasBirthDateError;
  }

  Future<bool> submitChild() async {
    if (!_validateForm()) {
      return false;
    }

    _isSubmitting = true;
    notifyListeners();

    try {
      final firstName = firstNameController.text.trim();
      final lastName = lastNameController.text.trim();

      final result = isEditing
          ? await _updateChildUseCase.execute(
              id: _existingChild!.id,
              firstName: firstName,
              lastName: lastName,
              gender: _selectedGender!,
              birthDate: _selectedBirthDate!,
              avatarFilePath: _avatarFilePath,
            )
          : await _addChildUseCase.execute(
              firstName: firstName,
              lastName: lastName,
              gender: _selectedGender!,
              birthDate: _selectedBirthDate!,
              avatarFilePath: _avatarFilePath,
            );

      bool success = false;
      result.when(
        success: (_) {
          success = true;
          clearError();
        },
        failure: (failure) {
          setErrorMessage(failure.message);
          developer.log('Failed to save child: ${failure.message}');
        },
      );
      return success;
    } catch (e) {
      setErrorMessage('Failed to save child');
      developer.log('Error saving child: $e');
      return false;
    } finally {
      _isSubmitting = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    birthDateController.dispose();
    super.dispose();
  }
}
