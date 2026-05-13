import 'package:bourgo_arena_mobile/data/mappers/search_mapper.dart';
import 'package:bourgo_arena_mobile/data/models/search_result_model.dart';
import 'package:bourgo_arena_mobile/domain/entities/search_result.dart';
import 'package:checks/checks.dart';
import 'package:test/test.dart';

void main() {
  group('SearchMapper', () {
    test('toEntity maps correctly', () {
      const model = SearchResultModel(
        id: '1',
        type: 'activity',
        title: 'Football',
        subtitle: 'Sport',
        icon: 'icon',
      );

      final entity = SearchMapper.toEntity(model);

      check(entity.title).equals(model.title);
      check(entity.subtitle).equals(model.subtitle);
      check(entity.type).equals(SearchResultType.activity);
      check(entity.iconKey).equals(model.icon);
    });
  });
}
