import 'package:bourgo_arena_mobile/domain/usecases/auth/forgot_password_use_case.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// ViewModel for the Forgot Password screen.
class ForgotPasswordViewModel extends ChangeNotifier {
  final ForgotPasswordUseCase _forgotPasswordUseCase;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController identifierController = TextEditingController();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  ForgotPasswordViewModel(this._forgotPasswordUseCase);

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<void> sendCode(BuildContext context) async {
    if (formKey.currentState?.validate() ?? false) {
      setLoading(true);

      final result = await _forgotPasswordUseCase(identifierController.text);

      setLoading(false);

      if (context.mounted) {
        result.fold(
          onSuccess: (_) {
            context.push(
              '/otp',
              extra: {
                'destination': identifierController.text,
                'isPasswordReset': true,
              },
            );
          },
          onFailure: (failure) {
            // If the error indicates email not verified, we could handle it here.
            // But based on requirements, if account is not verified, redirect to OTP.
            // Assuming the backend returns a specific failure or state for this.
            if (failure.message.contains('verified') ||
                failure.message.contains('verification')) {
              context.push(
                '/otp',
                extra: {'destination': identifierController.text},
              );
            } else {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(failure.message)));
            }
          },
        );
      }
    }
  }

  @override
  void dispose() {
    identifierController.dispose();
    super.dispose();
  }
}
