import 'package:bourgo_arena_mobile/core/utils/result.dart';
import 'package:bourgo_arena_mobile/domain/usecases/auth/login_use_case.dart';
import 'package:flutter/material.dart';

/// ViewModel for the Login screen.
class LoginViewModel extends ChangeNotifier {
  final LoginUseCase _loginUseCase;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController identifierController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  LoginViewModel(this._loginUseCase);

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<void> login(BuildContext context) async {
    if (formKey.currentState?.validate() ?? false) {
      setLoading(true);

      final result = await _loginUseCase(
        identifierController.text,
        passwordController.text,
      );

      setLoading(false);

      if (result case Failure failure) {
        if (context.mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(failure.message)));
        }
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
