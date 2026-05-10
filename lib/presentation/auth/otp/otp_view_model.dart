import 'package:bourgo_arena_mobile/domain/usecases/auth/send_otp_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/auth/verify_otp_use_case.dart';
import 'package:flutter/material.dart';

/// ViewModel for the OTP Verification screen.
class OtpViewModel extends ChangeNotifier {
  final VerifyOtpUseCase _verifyOtpUseCase;
  final SendOtpUseCase _sendOtpUseCase;

  OtpViewModel(this._verifyOtpUseCase, this._sendOtpUseCase);

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  /// Verifies the OTP code for the given identifier.
  Future<void> verify({
    required String identifier,
    required String code,
    required VoidCallback onSuccess,
  }) async {
    if (code.length == 4) {
      setLoading(true);
      _errorMessage = null;
      notifyListeners();

      final result = await _verifyOtpUseCase(identifier, code);

      setLoading(false);

      result.fold(
        onSuccess: (isValid) {
          if (isValid) {
            onSuccess();
          } else {
            _errorMessage = 'Invalid verification code';
            notifyListeners();
          }
        },
        onFailure: (failure) {
          _errorMessage = failure.message;
          notifyListeners();
        },
      );
    }
  }

  /// Resends the OTP code to the given identifier.
  Future<void> resend(String identifier) async {
    setLoading(true);
    _errorMessage = null;
    notifyListeners();

    final result = await _sendOtpUseCase(identifier);

    setLoading(false);

    result.fold(
      onSuccess: (_) {
        // Handle resend success (e.g., show a toast/snackbar if needed)
      },
      onFailure: (failure) {
        _errorMessage = failure.message;
        notifyListeners();
      },
    );
  }
}
