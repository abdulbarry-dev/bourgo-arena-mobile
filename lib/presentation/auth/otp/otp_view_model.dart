import 'dart:developer' as developer;
import 'package:bourgo_arena_mobile/domain/usecases/auth/send_otp_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/auth/verify_otp_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/auth/get_verification_status_use_case.dart';
import 'package:flutter/material.dart';

/// ViewModel for the OTP Verification screen.
class OtpViewModel extends ChangeNotifier {
  final VerifyOtpUseCase _verifyOtpUseCase;
  final SendOtpUseCase _sendOtpUseCase;
  final GetVerificationStatusUseCase _getVerificationStatusUseCase;

  OtpViewModel(
    this._verifyOtpUseCase,
    this._sendOtpUseCase,
    this._getVerificationStatusUseCase,
  );

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  /// Verifies the OTP code for the given identifier.
  /// Also checks verification status to determine if additional verification is needed.
  Future<void> verify({
    required String identifier,
    required String code,
    required VoidCallback onSuccess,
    required Function(String unverifiedMethod, String? email, String? phone)
    onAdditionalVerificationNeeded,
  }) async {
    if (code.length == 6) {
      setLoading(true);
      _errorMessage = null;
      notifyListeners();

      developer.log('Verifying OTP: $code for $identifier');
      final result = await _verifyOtpUseCase(identifier, code);

      setLoading(false);

      result.fold(
        onSuccess: (isValid) async {
          if (isValid) {
            // After successful verification, check status to see if additional verification needed
            final statusResult = await _getVerificationStatusUseCase();
            statusResult.fold(
              onSuccess: (status) {
                if (!status.isFullyVerified &&
                    status.unverifiedMethod != null) {
                  // Additional verification needed
                  onAdditionalVerificationNeeded(
                    status.unverifiedMethod!,
                    status.email,
                    status.phone,
                  );
                } else {
                  // All verifications complete
                  onSuccess();
                }
              },
              onFailure: (failure) {
                // If status check fails, still consider verification successful
                // and proceed (backend will enforce additional verification requirement)
                onSuccess();
              },
            );
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
