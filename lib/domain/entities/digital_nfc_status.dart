/// Domain entity representing the digital NFC configuration status.
class DigitalNfcStatus {
  final bool supported;
  final bool configured;
  final bool eligible;
  final bool isReady;
  final String setupStatus;
  final List<String> reasons;
  final List<String> fallbackMethods;

  const DigitalNfcStatus({
    required this.supported,
    required this.configured,
    required this.eligible,
    required this.isReady,
    required this.setupStatus,
    this.reasons = const [],
    this.fallbackMethods = const [],
  });
}
