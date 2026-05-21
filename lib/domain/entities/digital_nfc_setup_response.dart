/// Domain entity representing the response from digital NFC setup.
class DigitalNfcSetupResponse {
  final String setupStatus;
  final bool supported;
  final bool eligible;

  const DigitalNfcSetupResponse({
    required this.setupStatus,
    required this.supported,
    required this.eligible,
  });
}
