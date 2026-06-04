import 'package:bourgo_arena_mobile/domain/core/failure.dart';
import 'package:bourgo_arena_mobile/domain/usecases/auth/reset_password_use_case.dart';
import 'package:bourgo_arena_mobile/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// ViewModel for the New Password screen.
class NewPasswordViewModel extends ChangeNotifier {
  final String identifier;
  final String otp;
  final ResetPasswordUseCase _resetPasswordUseCase;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  NewPasswordViewModel({
    required this.identifier,
    required this.otp,
    required ResetPasswordUseCase resetPasswordUseCase,
  }) : _resetPasswordUseCase = resetPasswordUseCase;

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  /// Resets the user's password using the new credentials.
  Future<void> resetPassword(BuildContext context) async {
    if (!(formKey.currentState?.validate() ?? false)) return;
    setLoading(true);

    final result = await _resetPasswordUseCase(
      identifier: identifier,
      otp: otp,
      newPassword: passwordController.text,
    );

    setLoading(false);

    if (!context.mounted) return;
    result.fold(
      onSuccess: (_) => _handleSuccess(context),
      onFailure: (failure) => _handleFailure(context, failure),
    );
  }

  void _handleSuccess(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(AppLocalizations.of(context)!.passwordUpdateSuccess),
      ),
    );
    context.go('/login');
  }

  void _handleFailure(BuildContext context, Failure failure) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(failure.message)));
  }

  @override
  void dispose() {
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }
}
