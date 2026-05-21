/// Domain entity representing the status of the physical NFC card.
class PhysicalNfcStatus {
  final bool hasCard;
  final String? cardUid;
  final String? cardStatus;
  final bool isReady;
  final List<String> fallbackMethods;

  const PhysicalNfcStatus({
    required this.hasCard,
    this.cardUid,
    this.cardStatus,
    required this.isReady,
    this.fallbackMethods = const [],
  });
}
