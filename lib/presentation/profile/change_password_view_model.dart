import 'package:bourgo_arena_mobile/data/services/data_service.dart';
import 'package:flutter/material.dart';

/// ViewModel for the Change Password screen.
class ChangePasswordViewModel extends ChangeNotifier {
  final DataService _dataService;

  bool _isSaving = false;

  ChangePasswordViewModel({required DataService dataService})
    : _dataService = dataService;

  bool get isSaving => _isSaving;

  /// Updates the user's password.
  Future<bool> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    _isSaving = true;
    notifyListeners();

    try {
      await _dataService.updatePassword(currentPassword, newPassword);
      return true;
    } catch (e) {
      return false;
    } finally {
      _isSaving = false;
      notifyListeners();
    }
  }
}
