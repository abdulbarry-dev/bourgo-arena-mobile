import 'package:bourgo_arena_mobile/core/utils/result.dart';
import 'package:bourgo_arena_mobile/domain/core/failure.dart';
import 'package:test/test.dart';
import 'package:bourgo_arena_mobile/domain/core/app_error_code.dart';

void main() {
  test('Success holds value and fold/when call success branch', () {
    final r = Result<int, Failure>.success(42);
    expect(r.isSuccess, isTrue);
    expect(r.isFailure, isFalse);

    final folded = r.fold(onFailure: (f) => -1, onSuccess: (v) => v + 1);
    expect(folded, 43);

    final whened = r.when(success: (v) => 'ok$v', failure: (f) => 'bad');
    expect(whened, startsWith('ok'));
  });

  test('FailureResult holds failure and fold/when call failure branch', () {
    final ex = ServerFailure(AppErrorCode.serverError, 'err');
    final r = Result<int, Failure>.failure(ex);
    expect(r.isSuccess, isFalse);
    expect(r.isFailure, isTrue);

    final folded = r.fold(
      onFailure: (f) => 'f:${f.message}',
      onSuccess: (_) => 'ok',
    );
    expect(folded, contains('err'));

    final whened = r.when(success: (_) => 1, failure: (f) => 2);
    expect(whened, 2);
  });

  test('chaining via fold works correctly', () {
    final r = Result<String, Failure>.success('a');
    final next = r.fold(
      onFailure: (f) => Result<String, Failure>.success('fail'),
      onSuccess: (v) => Result<String, Failure>.success('${v}b'),
    );
    expect(next.isSuccess, isTrue);
    expect((next as Success).data, 'ab');
  });
}
