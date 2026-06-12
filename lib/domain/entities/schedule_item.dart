enum ScheduleItemType { booking, reservation }

class ScheduleItem {
  final ScheduleItemType type;
  final String typeLabel;
  final String id;
  final String date;
  final String name;
  final String startTime;
  final String? endTime;
  final int durationMinutes;
  final String status;
  final String statusLabel;
  final bool isCompleted;

  const ScheduleItem({
    required this.type,
    required this.typeLabel,
    required this.id,
    required this.date,
    required this.name,
    required this.startTime,
    this.endTime,
    required this.durationMinutes,
    required this.status,
    required this.statusLabel,
    this.isCompleted = false,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ScheduleItem &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          date == other.date &&
          type == other.type;

  @override
  int get hashCode => id.hashCode ^ date.hashCode ^ type.hashCode;
}
