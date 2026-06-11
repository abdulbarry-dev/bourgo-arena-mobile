enum CompletedItemType { course, activity }

class CompletedItem {
  final CompletedItemType type;
  final String typeLabel;
  final String id;
  final String date;
  final String name;
  final String completedAt;

  const CompletedItem({
    required this.type,
    required this.typeLabel,
    required this.id,
    required this.date,
    required this.name,
    required this.completedAt,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CompletedItem &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          date == other.date &&
          type == other.type;

  @override
  int get hashCode => id.hashCode ^ date.hashCode ^ type.hashCode;
}
