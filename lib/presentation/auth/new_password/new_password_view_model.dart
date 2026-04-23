import 'package:flutter/material.dart';

/// ViewModel for the New Password screen.
class NewPasswordViewModel extends ChangeNotifier {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void resetPassword(BuildContext context) {
    if (formKey.currentState?.validate() ?? false) {
      setLoading(true);
      // Simulate API call
      Future.delayed(const Duration(seconds: 2), () {
        setLoading(false);
        // Navigate to Login or Success
      });
    }
  }

  @override
  void dispose() {
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }
}
