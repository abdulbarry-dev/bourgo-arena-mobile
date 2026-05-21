import 'dart:developer' as developer;
import 'package:flutter/foundation.dart';
import '../../domain/entities/digital_nfc_status.dart';
import '../../domain/entities/physical_nfc_status.dart';
import '../../domain/usecases/nfc/get_physical_nfc_status_use_case.dart';
import '../../domain/usecases/nfc/get_digital_nfc_status_use_case.dart';
import '../../domain/usecases/nfc/setup_digital_nfc_use_case.dart';

/// ViewModel managing the state for the NFC integration flow.
class NfcViewModel extends ChangeNotifier {
  final GetPhysicalNfcStatusUseCase _getPhysicalStatus;
  final GetDigitalNfcStatusUseCase _getDigitalStatus;
  final SetupDigitalNfcUseCase _setupDigitalNfc;

  PhysicalNfcStatus? physicalStatus;
  DigitalNfcStatus? digitalStatus;
  bool isLoading = false;
  String? errorMessage;

  NfcViewModel(
    this._getPhysicalStatus,
    this._getDigitalStatus,
    this._setupDigitalNfc,
  );

  /// Fetches both physical and digital NFC statuses from the backend.
  Future<void> fetchNfcStatus() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final futures = await Future.wait([
        _getPhysicalStatus(),
        _getDigitalStatus(),
      ]);

      physicalStatus = futures[0] as PhysicalNfcStatus;
      digitalStatus = futures[1] as DigitalNfcStatus;
    } catch (e) {
      developer.log('Error fetching NFC status: $e');
      errorMessage = 'Failed to load NFC status. Please try again.';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  /// Initiates the digital NFC setup process using the current device info.
  Future<void> setupDigitalNfc() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final response = await _setupDigitalNfc();

      if (response.setupStatus == 'completed') {
        developer.log('Digital NFC setup completed successfully.');
        // Refresh status after successful setup
        await fetchNfcStatus();
      }
    } catch (e) {
      developer.log('Error setting up digital NFC: $e');
      errorMessage = 'Failed to set up Digital NFC. Please try again.';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
