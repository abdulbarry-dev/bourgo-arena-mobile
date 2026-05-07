import 'package:bourgo_arena_mobile/data/models/child_profile_model.dart';
import 'package:flutter/material.dart';

/// ViewModel for the Family Onboarding screen.
class FamilyOnboardingViewModel extends ChangeNotifier {
  final List<ChildProfileModel> _members = [];
  final TextEditingController nameController = TextEditingController();
  final TextEditingController birthDateController = TextEditingController();

  DateTime? _selectedBirthDate;
  String? _selectedGender;
  bool _hasNameError = false;
  bool _hasGenderError = false;
  bool _hasBirthDateError = false;

  /// Returns the list of added members.
  List<ChildProfileModel> get members => List.unmodifiable(_members);

  /// Returns the currently selected birth date.
  DateTime? get selectedBirthDate => _selectedBirthDate;

  /// Returns the currently selected gender.
  String? get selectedGender => _selectedGender;
  bool get hasNameError => _hasNameError;
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
    _hasNameError = nameController.text.trim().isEmpty;
    _hasBirthDateError = _selectedBirthDate == null;
    _hasGenderError = _selectedGender == null;

    if (_hasNameError || _hasBirthDateError || _hasGenderError) {
      notifyListeners();
      return;
    }

    final name = nameController.text.trim();
    // Split name into first and last name if possible,
    // otherwise use name as first name and empty as last name.
    final parts = name.split(' ');
    final firstName = parts[0];
    final lastName = parts.length > 1 ? parts.sublist(1).join(' ') : '';

    _members.add(
      ChildProfileModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        firstName: firstName,
        lastName: lastName,
        birthDate: _selectedBirthDate!,
        gender: _selectedGender,
      ),
    );

    // Reset form
    nameController.clear();
    birthDateController.clear();
    _selectedBirthDate = null;
    _selectedGender = null;
    _hasNameError = false;
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
    nameController.dispose();
    birthDateController.dispose();
    super.dispose();
  }
}
