import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// ViewModel for the Forgot Password screen.
class ForgotPasswordViewModel extends ChangeNotifier {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController identifierController = TextEditingController();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void sendCode(BuildContext context) {
    if (formKey.currentState?.validate() ?? false) {
      setLoading(true);
      // Simulate API call
      Future.delayed(const Duration(seconds: 2), () {
        if (context.mounted) {
          setLoading(false);
          context.push('/otp', extra: identifierController.text);
        }
      });
    }
  }

  @override
  void dispose() {
    identifierController.dispose();
    super.dispose();
  }
}
