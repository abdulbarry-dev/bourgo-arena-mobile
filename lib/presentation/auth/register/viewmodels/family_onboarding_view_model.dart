import 'package:bourgo_arena_mobile/domain/entities/child_profile.dart';
import 'package:flutter/material.dart';

/// ViewModel for the Family Onboarding screen.
class FamilyOnboardingViewModel extends ChangeNotifier {
  final List<ChildProfile> _members = [];
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController birthDateController = TextEditingController();

  DateTime? _selectedBirthDate;
  String? _selectedGender;
  bool _hasFirstNameError = false;
  bool _hasLastNameError = false;
  bool _hasGenderError = false;
  bool _hasBirthDateError = false;

  /// Returns the list of added members.
  List<ChildProfile> get members => List.unmodifiable(_members);

  /// Returns the currently selected birth date.
  DateTime? get selectedBirthDate => _selectedBirthDate;

  /// Returns the currently selected gender.
  String? get selectedGender => _selectedGender;
  bool get hasFirstNameError => _hasFirstNameError;
  bool get hasLastNameError => _hasLastNameError;
  bool get hasGenderError => _hasGenderError;
  bool get hasBirthDateError => _hasBirthDateError;

  /// Sets the selected birth date.
  void setBirthDate(DateTime? date) {
    _selectedBirthDate = date;
    notifyListeners();
  }

  /// Sets the selected gender.
  void setGender(String? gender) {
    _selectedGender = gender;
    notifyListeners();
  }

  /// Adds a new member to the list.
  void addMember() {
    _hasFirstNameError = firstNameController.text.trim().isEmpty;
    _hasLastNameError = lastNameController.text.trim().isEmpty;
    _hasBirthDateError = _selectedBirthDate == null;
    _hasGenderError = _selectedGender == null;

    if (_hasFirstNameError ||
        _hasLastNameError ||
        _hasBirthDateError ||
        _hasGenderError) {
      notifyListeners();
      return;
    }

    final firstName = firstNameController.text.trim();
    final lastName = lastNameController.text.trim();

    _members.add(
      ChildProfile(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        firstName: firstName,
        lastName: lastName,
        birthDate: _selectedBirthDate!,
        gender: _selectedGender,
      ),
    );

    // Reset form
    firstNameController.clear();
    lastNameController.clear();
    birthDateController.clear();
    _selectedBirthDate = null;
    _selectedGender = null;
    _hasFirstNameError = false;
    _hasLastNameError = false;
    _hasGenderError = false;
    _hasBirthDateError = false;
    notifyListeners();
  }

  /// Removes a member from the list.
  void removeMember(int index) {
    if (index >= 0 && index < _members.length) {
      _members.removeAt(index);
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
