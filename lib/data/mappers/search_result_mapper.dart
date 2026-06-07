import 'package:bourgo_arena_mobile/data/models/search_result_model.dart';
import 'package:bourgo_arena_mobile/domain/entities/search_result.dart';

/// Mapper for search results.
class SearchResultMapper {
  static SearchResult toEntity(SearchResultModel model) {
    return SearchResult(
      title: model.title,
      subtitle: model.subtitle,
      type: _mapType(model.type),
      iconKey: model.icon,
      route: _mapRoute(model.type, model.id),
      extra: model.id,
    );
  }

  static SearchResultType _mapType(String type) {
    switch (type.toLowerCase()) {
      case 'activity':
        return SearchResultType.activity;
      case 'course':
        return SearchResultType.course;
      default:
        return SearchResultType.navigation;
    }
  }

  static String _mapRoute(String type, String id) {
    switch (type.toLowerCase()) {
      case 'activity':
        return '/activities/$id/slots';
      case 'course':
        return '/courses/$id';
      case 'event':
        return '/events/$id/participants';
      default:
        return '/home';
    }
  }
}
