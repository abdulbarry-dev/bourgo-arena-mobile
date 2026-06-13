import 'package:bourgo_arena_mobile/domain/core/failure.dart';
import 'package:bourgo_arena_mobile/domain/usecases/auth/forgot_password_use_case.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../common/widgets/app_toast.dart';

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

  /// Sends the password reset code.
  Future<void> sendCode(BuildContext context) async {
    if (!(formKey.currentState?.validate() ?? false)) return;
    setLoading(true);

    final result = await _forgotPasswordUseCase(identifierController.text);

    setLoading(false);

    if (!context.mounted) return;
    result.fold(
      onSuccess: (_) => _handleSuccess(context),
      onFailure: (failure) => _handleFailure(context, failure),
    );
  }

  void _handleSuccess(BuildContext context) {
    context.push(
      '/otp',
      extra: {
        'destination': identifierController.text,
        'isPasswordReset': true,
      },
    );
  }

  void _handleFailure(BuildContext context, Failure failure) {
    final isUnverified =
        failure.state == 'pending_verification' ||
        failure.message.contains('verified') ||
        failure.message.contains('verification');
    if (isUnverified) {
      context.push(
        '/otp',
        extra: {
          'destination': identifierController.text,
          'isPasswordReset': false,
        },
      );
    } else {
      AppToast.show(context, failure.message, type: AppToastType.error);
    }
  }

  @override
  void dispose() {
    identifierController.dispose();
    super.dispose();
  }
}
