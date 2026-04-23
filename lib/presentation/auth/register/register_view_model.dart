import 'package:flutter/material.dart';

/// ViewModel for the Registration screen.
class RegisterViewModel extends ChangeNotifier {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void register(BuildContext context) {
    if (formKey.currentState?.validate() ?? false) {
      setLoading(true);
      // Simulate API call
      Future.delayed(const Duration(seconds: 2), () {
        setLoading(false);
        // Navigate to OTP
      });
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
