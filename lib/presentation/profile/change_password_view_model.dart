import 'package:bourgo_arena_mobile/domain/usecases/auth/update_password_use_case.dart';
import 'package:flutter/material.dart';

/// ViewModel for the Change Password screen.
class ChangePasswordViewModel extends ChangeNotifier {
  final UpdatePasswordUseCase _updatePasswordUseCase;

  bool _isSaving = false;

  ChangePasswordViewModel({required UpdatePasswordUseCase updatePasswordUseCase})
    : _updatePasswordUseCase = updatePasswordUseCase;

  bool get isSaving => _isSaving;

  /// Updates the user's password.
  Future<bool> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    _isSaving = true;
    notifyListeners();

    try {
      final result = await _updatePasswordUseCase(
        currentPassword: currentPassword,
        newPassword: newPassword,
      );
      return result.isSuccess;
    } catch (e) {
      return false;
    } finally {
      _isSaving = false;
      notifyListeners();
    }
  }
}
