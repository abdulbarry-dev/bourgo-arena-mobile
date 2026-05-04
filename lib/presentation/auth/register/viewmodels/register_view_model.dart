import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// ViewModel for the Registration screen.
class RegisterViewModel extends ChangeNotifier {
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

  void register(BuildContext context) {
    if (formKey.currentState?.validate() ?? false) {
      setLoading(true);
      // Simulate API call with all fields
      // In a real app, we would send firstName, lastName, email, phone, password, birthDate, isParentAccount
      Future.delayed(const Duration(seconds: 2), () {
        if (context.mounted) {
          setLoading(false);
          context.push('/otp', extra: emailController.text);
        }
      });
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
