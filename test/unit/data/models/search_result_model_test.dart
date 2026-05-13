import 'package:bourgo_arena_mobile/data/models/search_result_model.dart';
import 'package:checks/checks.dart';
import 'package:test/test.dart';

void main() {
  group('SearchResultModel', () {
    test('toJson and fromJson should be consistent', () {
      const model = SearchResultModel(
        id: '1',
        type: 'activity',
        title: 'Football 5x5',
        subtitle: 'Sport',
        icon: 'sports_soccer',
      );

      final json = model.toJson();
      final fromJson = SearchResultModel.fromJson(json);

      check(fromJson.id).equals(model.id);
      check(fromJson.type).equals(model.type);
      check(fromJson.title).equals(model.title);
      check(fromJson.subtitle).equals(model.subtitle);
      check(fromJson.icon).equals(model.icon);
    });
  });
}
