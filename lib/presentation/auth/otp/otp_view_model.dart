import 'package:flutter/material.dart';

/// ViewModel for the OTP Verification screen.
class OtpViewModel extends ChangeNotifier {
  final TextEditingController otpController = TextEditingController();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void verify(BuildContext context) {
    if (otpController.text.length == 4) {
      setLoading(true);
      // Simulate API call
      Future.delayed(const Duration(seconds: 2), () {
        setLoading(false);
        // Navigate to Home
      });
    }
  }

  @override
  void dispose() {
    otpController.dispose();
    super.dispose();
  }
}
