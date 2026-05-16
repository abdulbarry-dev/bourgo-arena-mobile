import 'package:bourgo_arena_mobile/domain/entities/child_profile.dart';
import 'package:bourgo_arena_mobile/domain/usecases/family/add_child_use_case.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as developer;

/// ViewModel for adding/editing a child profile.
class AddEditChildViewModel extends ChangeNotifier {
  final AddChildUseCase _addChildUseCase;

  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final birthDateController = TextEditingController();

  String? _selectedGender;
  DateTime? _selectedBirthDate;
  bool _isSubmitting = false;
  String? _errorMessage;

  bool _hasFirstNameError = false;
  bool _hasLastNameError = false;
  bool _hasGenderError = false;
  bool _hasBirthDateError = false;

  AddEditChildViewModel({
    required AddChildUseCase addChildUseCase,
    ChildProfile? child,
  }) : _addChildUseCase = addChildUseCase {
    if (child != null) {
      _initializeFromChild(child);
    }
  }

  // Getters
  String? get selectedGender => _selectedGender;
  DateTime? get selectedBirthDate => _selectedBirthDate;
  bool get isSubmitting => _isSubmitting;
  String? get errorMessage => _errorMessage;
  bool get hasFirstNameError => _hasFirstNameError;
  bool get hasLastNameError => _hasLastNameError;
  bool get hasGenderError => _hasGenderError;
  bool get hasBirthDateError => _hasBirthDateError;

  void _initializeFromChild(ChildProfile child) {
    firstNameController.text = child.name.split(' ').first;
    lastNameController.text = child.name.split(' ').length > 1
        ? child.name.split(' ').skip(1).join(' ')
        : '';
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
      final fullName = '$firstName $lastName';

      final result = await _addChildUseCase.execute(
        firstName: firstName,
        lastName: lastName,
        gender: _selectedGender!,
        birthDate: _selectedBirthDate!,
      );

      bool success = false;
      result.when(
        success: (_) {
          success = true;
          _errorMessage = null;
        },
        failure: (failure) {
          _errorMessage = failure.message;
          developer.log('Failed to add child: ${failure.message}');
        },
      );
      return success;
    } catch (e) {
      _errorMessage = 'Failed to add child';
      developer.log('Error adding child: $e');
      return false;
    } finally {
      _isSubmitting = false;
      notifyListeners();
    }
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    birthDateController.dispose();
    super.dispose();
  }
}
