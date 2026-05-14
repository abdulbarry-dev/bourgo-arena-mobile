/// DTO for a check-in / access history entry.
class AccessHistoryModel {
  final String id;
  final DateTime checkedInAt;
  final String location;

  const AccessHistoryModel({
    required this.id,
    required this.checkedInAt,
    required this.location,
  });

  factory AccessHistoryModel.fromJson(Map<String, dynamic> json) {
    return AccessHistoryModel(
      id: json['id'].toString(),
      checkedInAt: DateTime.parse(json['checked_in_at'] as String),
      location: (json['location'] as String?) ?? 'Main Entrance',
    );
  }
}
