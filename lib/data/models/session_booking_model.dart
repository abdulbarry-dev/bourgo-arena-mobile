import 'package:bourgo_arena_mobile/domain/entities/session_booking.dart';

class SessionBookingModel {
  final String id;
  final String sessionId;
  final String status;
  final DateTime bookedAt;

  const SessionBookingModel({
    required this.id,
    required this.sessionId,
    required this.status,
    required this.bookedAt,
  });

  factory SessionBookingModel.fromJson(Map<String, dynamic> json) {
    return SessionBookingModel(
      id: json['id'].toString(),
      sessionId: json['session_id'].toString(),
      status: json['status'] as String? ?? '',
      bookedAt: DateTime.parse(json['booked_at'] as String),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'session_id': sessionId,
    'status': status,
    'booked_at': bookedAt.toIso8601String(),
  };

  SessionBooking toEntity() => SessionBooking(
    id: id,
    sessionId: sessionId,
    status: status,
    bookedAt: bookedAt,
  );
}
