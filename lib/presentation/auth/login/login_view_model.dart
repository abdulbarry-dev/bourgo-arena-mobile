import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// ViewModel for the Login screen.
class LoginViewModel extends ChangeNotifier {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController identifierController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void login(BuildContext context) {
    if (formKey.currentState?.validate() ?? false) {
      setLoading(true);
      Future.delayed(const Duration(seconds: 2), () {
        setLoading(false);
        if (context.mounted) {
          context.go('/home');
        }
      });
    }
  }

  @override
  void dispose() {
    identifierController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
