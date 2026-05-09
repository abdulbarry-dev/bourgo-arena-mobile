/// Types of search results available in the application.
enum SearchResultType { activity, course, setting, navigation }

/// A unified entity representing a search result from any source.
///
/// Note: to preserve domain purity this entity avoids framework types
/// such as `IconData`. Presentation code should map `iconKey` to
/// platform-specific icons.
class SearchResult {
  final String title;
  final String subtitle;
  final SearchResultType type;
  final String iconKey; // UI-agnostic icon identifier
  final String route;
  final Object? extra;

  const SearchResult({
    required this.title,
    required this.subtitle,
    required this.type,
    required this.iconKey,
    required this.route,
    this.extra,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SearchResult &&
          runtimeType == other.runtimeType &&
          title == other.title &&
          subtitle == other.subtitle &&
          type == other.type &&
          iconKey == other.iconKey &&
          route == other.route &&
          extra == other.extra;

  @override
  int get hashCode =>
      title.hashCode ^
      subtitle.hashCode ^
      type.hashCode ^
      iconKey.hashCode ^
      route.hashCode ^
      extra.hashCode;
}
