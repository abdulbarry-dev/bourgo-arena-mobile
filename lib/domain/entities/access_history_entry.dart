/// Pure domain entity representing a user's access/check-in history entry.
class AccessHistoryEntry {
  /// Unique identifier for the access record.
  final String id;

  /// Timestamp of the access event.
  final DateTime checkedInAt;

  /// Name of the access point or location.
  final String location;

  /// Creates a new [AccessHistoryEntry] instance.
  const AccessHistoryEntry({
    required this.id,
    required this.checkedInAt,
    required this.location,
  });
}
