import 'package:bourgo_arena_mobile/data/models/child_profile_model.dart';
import 'package:flutter/material.dart';

/// ViewModel for the Family Onboarding screen.
class FamilyOnboardingViewModel extends ChangeNotifier {
  final List<ChildProfileModel> _members = [];
  final TextEditingController nameController = TextEditingController();
  final TextEditingController birthDateController = TextEditingController();

  DateTime? _selectedBirthDate;
  String? _selectedGender;
  String? _nameError;
  String? _genderError;
  String? _birthDateError;

  /// Returns the list of added members.
  List<ChildProfileModel> get members => List.unmodifiable(_members);

  /// Returns the currently selected birth date.
  DateTime? get selectedBirthDate => _selectedBirthDate;

  /// Returns the currently selected gender.
  String? get selectedGender => _selectedGender;
  String? get nameError => _nameError;
  String? get genderError => _genderError;
  String? get birthDateError => _birthDateError;

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
    _nameError = nameController.text.trim().isEmpty ? 'Required' : null;
    _birthDateError = _selectedBirthDate == null ? 'Required' : null;
    _genderError = _selectedGender == null ? 'Required' : null;

    if (_nameError != null || _birthDateError != null || _genderError != null) {
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
    _nameError = null;
    _genderError = null;
    _birthDateError = null;
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
