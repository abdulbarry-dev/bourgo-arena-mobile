import 'package:bourgo_arena_mobile/data/services/auth_service.dart';
import 'package:flutter/material.dart';

/// ViewModel for the Login screen.
class LoginViewModel extends ChangeNotifier {
  final AuthService _authService;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController identifierController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  LoginViewModel(this._authService);

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<void> login(BuildContext context) async {
    if (formKey.currentState?.validate() ?? false) {
      setLoading(true);

      // TODO: Replace with real API call in production
      final success = await _authService.login(
        identifierController.text,
        passwordController.text,
      );

      setLoading(false);

      if (!success && context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Invalid credentials')));
      }
      // Note: GoRouter redirect in router.dart will handle navigation on success
    }
  }

  @override
  void dispose() {
    identifierController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
