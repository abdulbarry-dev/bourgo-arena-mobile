/// Entity representing a user notification.
class Notification {
  /// Unique identifier.
  final String id;

  /// Title of the notification.
  final String title;

  /// Body message.
  final String message;

  /// When the notification was received.
  final DateTime timestamp;

  /// Type of notification (booking, promotion, system).
  final String type;

  /// Whether the notification has been read.
  final bool isRead;

  /// Creates a new [Notification] instance.
  const Notification({
    required this.id,
    required this.title,
    required this.message,
    required this.timestamp,
    required this.type,
    required this.isRead,
  });

  /// Creates a copy of this [Notification] with the given fields updated.
  Notification copyWith({
    String? id,
    String? title,
    String? message,
    DateTime? timestamp,
    String? type,
    bool? isRead,
  }) {
    return Notification(
      id: id ?? this.id,
      title: title ?? this.title,
      message: message ?? this.message,
      timestamp: timestamp ?? this.timestamp,
      type: type ?? this.type,
      isRead: isRead ?? this.isRead,
    );
  }
}
