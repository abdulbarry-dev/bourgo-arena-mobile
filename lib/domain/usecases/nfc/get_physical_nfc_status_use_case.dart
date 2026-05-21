import '../../entities/physical_nfc_status.dart';
import '../../repositories/nfc_repository.dart';

/// Use case for retrieving the physical NFC status.
class GetPhysicalNfcStatusUseCase {
  final NfcRepository _repository;

  const GetPhysicalNfcStatusUseCase(this._repository);

  Future<PhysicalNfcStatus> call() {
    return _repository.getPhysicalStatus();
  }
}
