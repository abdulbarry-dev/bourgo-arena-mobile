import '../../domain/entities/digital_nfc_setup_response.dart';
import '../../domain/entities/digital_nfc_status.dart';
import '../../domain/entities/physical_nfc_status.dart';
import '../models/digital_nfc_setup_response_model.dart';
import '../models/digital_nfc_status_model.dart';
import '../models/physical_nfc_status_model.dart';

extension PhysicalNfcStatusModelMapper on PhysicalNfcStatusModel {
  PhysicalNfcStatus toEntity() {
    return PhysicalNfcStatus(
      hasCard: hasCard,
      cardUid: cardUid,
      cardStatus: cardStatus,
      isReady: isReady,
      fallbackMethods: fallbackMethods,
    );
  }
}

extension DigitalNfcStatusModelMapper on DigitalNfcStatusModel {
  DigitalNfcStatus toEntity() {
    return DigitalNfcStatus(
      supported: supported,
      configured: configured,
      eligible: eligible,
      isReady: isReady,
      setupStatus: setupStatus,
      reasons: reasons,
      fallbackMethods: fallbackMethods,
    );
  }
}

extension DigitalNfcSetupResponseModelMapper on DigitalNfcSetupResponseModel {
  DigitalNfcSetupResponse toEntity() {
    return DigitalNfcSetupResponse(
      setupStatus: setupStatus,
      supported: supported,
      eligible: eligible,
    );
  }
}
