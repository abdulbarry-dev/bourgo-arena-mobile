import 'package:bourgo_arena_mobile/data/models/search_result_model.dart';
import 'package:bourgo_arena_mobile/domain/entities/search_result.dart';

/// Mapper to convert between [SearchResultModel] and [SearchResult].
class SearchMapper {
  /// Converts [SearchResultModel] to [SearchResult].
  static SearchResult toEntity(SearchResultModel model) {
    return SearchResult(
      title: model.title,
      subtitle: model.subtitle,
      type: _mapType(model.type),
      iconKey: model.icon,
      route: _mapRoute(model.type, model.id),
    );
  }

  static SearchResultType _mapType(String type) {
    switch (type.toLowerCase()) {
      case 'activity':
        return SearchResultType.activity;
      case 'course':
        return SearchResultType.course;
      case 'setting':
        return SearchResultType.setting;
      default:
        return SearchResultType.navigation;
    }
  }

  static String _mapRoute(String type, String id) {
    switch (type.toLowerCase()) {
      case 'activity':
        return '/booking'; // Placeholder until detailed routes are available
      case 'course':
        return '/home'; // Placeholder
      case 'setting':
        return '/settings';
      default:
        return '/home';
    }
  }
}

/// Extension for convenient mapping of [SearchResultModel] list.
extension SearchResultModelListX on List<SearchResultModel> {
  /// Converts a list of [SearchResultModel] to a list of [SearchResult].
  List<SearchResult> toEntityList() => map(SearchMapper.toEntity).toList();
}
