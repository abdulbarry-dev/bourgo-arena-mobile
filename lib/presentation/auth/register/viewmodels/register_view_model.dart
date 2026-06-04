import 'package:bourgo_arena_mobile/core/base/base_view_model.dart';
import 'package:bourgo_arena_mobile/domain/usecases/auth/register_use_case.dart';
import 'package:flutter/material.dart';

/// ViewModel for the Registration screen.
class RegisterViewModel extends BaseViewModel {
  final RegisterUseCase _registerUseCase;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController birthDateController = TextEditingController();

  DateTime? _selectedBirthDate;
  DateTime? get selectedBirthDate => _selectedBirthDate;

  String? _selectedGender;
  String? get selectedGender => _selectedGender;

  bool _isParentAccount = false;
  bool get isParentAccount => _isParentAccount;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  RegisterViewModel(this._registerUseCase);

  void setBirthDate(DateTime? date) {
    _selectedBirthDate = date;
    notifyListeners();
  }

  void setGender(String? gender) {
    _selectedGender = gender;
    notifyListeners();
  }

  void setParentAccount(bool value) {
    _isParentAccount = value;
    notifyListeners();
  }

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<void> register({
    required void Function(Map<String, dynamic> data) onSuccess,
  }) async {
    if (formKey.currentState?.validate() ?? false) {
      if (_selectedBirthDate == null || _selectedGender == null) {
        setErrorMessage("Please complete all fields");
        return;
      }

      setLoading(true);
      clearError();

      final result = await _registerUseCase(
        firstName: firstNameController.text,
        lastName: lastNameController.text,
        email: emailController.text,
        phone: phoneController.text,
        password: passwordController.text,
        gender: _selectedGender!,
        birthDate: _selectedBirthDate!,
        isFamilyAccount: _isParentAccount,
      );

      setLoading(false);

      result.fold(
        onSuccess: (_) {
          final registrationData = {
            'firstName': firstNameController.text,
            'lastName': lastNameController.text,
            'email': emailController.text,
            'phone': phoneController.text,
            'gender': _selectedGender,
            'birthDate': _selectedBirthDate,
            'isParentAccount': _isParentAccount,
          };
          onSuccess(registrationData);
        },
        onFailure: (failure) {
          setErrorMessage(failure.message);
        },
      );
    }
  }

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    birthDateController.dispose();
    super.dispose();
  }
}
