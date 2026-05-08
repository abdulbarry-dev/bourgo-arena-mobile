import 'package:bourgo_arena_mobile/domain/usecases/auth/register_use_case.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// ViewModel for the Registration screen.
class RegisterViewModel extends ChangeNotifier {
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

  bool _isParentAccount = false;
  bool get isParentAccount => _isParentAccount;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  RegisterViewModel(this._registerUseCase);

  void setBirthDate(DateTime? date) {
    _selectedBirthDate = date;
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

  Future<void> register(BuildContext context) async {
    if (formKey.currentState?.validate() ?? false) {
      setLoading(true);

      final result = await _registerUseCase(
        firstName: firstNameController.text,
        lastName: lastNameController.text,
        email: emailController.text,
        phone: phoneController.text,
        password: passwordController.text,
        isFamilyAccount: _isParentAccount,
      );

      setLoading(false);

      if (context.mounted) {
        result.fold(
          onSuccess: (_) {
            // Prepare data for the next onboarding/verification screen
            final registrationData = {
              'firstName': firstNameController.text,
              'lastName': lastNameController.text,
              'email': emailController.text,
              'phone': phoneController.text,
              'isParentAccount': _isParentAccount,
            };

            if (_isParentAccount) {
              context.push('/family-onboarding', extra: registrationData);
            } else {
              context.push('/verification-method', extra: registrationData);
            }
          },
          onFailure: (failure) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(failure.message)));
          },
        );
      }
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
