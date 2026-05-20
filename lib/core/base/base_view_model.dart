import 'package:flutter/material.dart';

/// Base class for all ViewModels to standardize state and error handling.
abstract class BaseViewModel extends ChangeNotifier {
  String? _errorMessage;

  /// The current error message, if any.
  String? get errorMessage => _errorMessage;

  /// Sets an error message and notifies listeners.
  void setErrorMessage(String? message) {
    _errorMessage = message;
    notifyListeners();
  }

  /// Clears the current error message.
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
