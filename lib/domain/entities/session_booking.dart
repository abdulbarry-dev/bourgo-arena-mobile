class SessionBooking {
  final String id;
  final String sessionId;
  final String status;
  final DateTime bookedAt;

  const SessionBooking({
    required this.id,
    required this.sessionId,
    required this.status,
    required this.bookedAt,
  });
}
