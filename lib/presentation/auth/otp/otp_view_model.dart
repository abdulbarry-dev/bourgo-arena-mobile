import 'dart:developer' as developer;
import 'package:bourgo_arena_mobile/core/base/base_view_model.dart';
import 'package:bourgo_arena_mobile/domain/usecases/auth/send_otp_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/auth/verify_otp_use_case.dart';
import 'package:bourgo_arena_mobile/domain/usecases/auth/get_verification_status_use_case.dart';
import 'package:flutter/material.dart';

/// ViewModel for the OTP Verification screen.
class OtpViewModel extends BaseViewModel {
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
    required VoidCallback onOnboardingIncomplete,
    required Function(String unverifiedMethod, String? email, String? phone)
    onAdditionalVerificationNeeded,
    bool isPasswordReset = false,
  }) async {
    if (code.length == 6) {
      if (isPasswordReset) {
        onSuccess();
        return;
      }

      setLoading(true);
      clearError();

      developer.log('Verifying OTP: $code for $identifier');
      final result = await _verifyOtpUseCase(identifier, code);

      setLoading(false);

      await result.fold<Future<void>>(
        onSuccess: (isValid) async {
          if (isValid) {
            // After successful verification, check status to see if additional verification needed
            final statusResult = await _getVerificationStatusUseCase();
            statusResult.fold<void>(
              onSuccess: (status) {
                if (!status.onboardingCompleted) {
                  onOnboardingIncomplete();
                } else if (!status.isFullyVerified &&
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
            setErrorMessage('authInvalidVerificationCode');
          }
        },
        onFailure: (failure) {
          setErrorMessage(failure.message);
          return Future.value();
        },
      );
    }
  }

  /// Resends the OTP code to the given identifier.
  Future<void> resend(String identifier) async {
    setLoading(true);
    clearError();

    final result = await _sendOtpUseCase(identifier);

    setLoading(false);

    result.fold(
      onSuccess: (_) {
        // Handle resend success (e.g., show a toast/snackbar if needed)
      },
      onFailure: (failure) {
        setErrorMessage(failure.message);
      },
    );
  }

  /// Requests an OTP for enabling family account mode.
  /// Checks verification status first to ensure the method is not already verified.
  Future<void> requestFamilyOtp({
    required bool isEmail,
    required VoidCallback onSuccess,
    required Function(String) onError,
  }) async {
    setLoading(true);
    clearError();

    // 1. Check Verification Status
    final statusResult = await _getVerificationStatusUseCase();

    await statusResult.fold<Future<void>>(
      onSuccess: (status) async {
        // 2. Conditional UI Logic
        if (isEmail && status.emailVerified) {
          onError('This email address is already verified.');
          setLoading(false);
          return;
        } else if (!isEmail && status.phoneVerified) {
          onError('This phone number is already verified.');
          setLoading(false);
          return;
        }

        // 3. API Call
        final result = await _sendOtpUseCase(
          isEmail ? status.email! : status.phone!,
        );

        setLoading(false);
        result.when(
          success: (_) => onSuccess(),
          failure: (failure) {
            setErrorMessage(failure.message);
            onError(failure.message);
          },
        );
        return Future.value();
      },
      onFailure: (failure) {
        setLoading(false);
        setErrorMessage(failure.message);
        onError(failure.message);
        return Future.value();
      },
    );
  }
}
