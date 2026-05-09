import 'package:bourgo_arena_mobile/core/utils/result.dart';
import 'package:bourgo_arena_mobile/domain/core/failure.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:checks/checks.dart';

void main() {
  group('Result', () {
    const successData = 'success_data';
    const failure = ServerFailure('error_message');

    test('Success state holds data and identifies correctly', () {
      final result = Result<String, Failure>.success(successData);

      check(result.isSuccess).isTrue();
      check(result.isFailure).isFalse();
      
      result.when(
        success: (data) => check(data).equals(successData),
        failure: (f) => fail('Should not be failure'),
      );
    });

    test('Failure state holds failure and identifies correctly', () {
      final result = Result<String, Failure>.failure(failure);

      check(result.isSuccess).isFalse();
      check(result.isFailure).isTrue();

      result.when(
        success: (data) => fail('Should not be success'),
        failure: (f) => check(f).equals(failure),
      );
    });

    test('fold handles success path', () {
      final result = Result<String, Failure>.success(successData);

      final output = result.fold(
        onSuccess: (data) => data.toUpperCase(),
        onFailure: (f) => 'failed',
      );

      check(output).equals(successData.toUpperCase());
    });

    test('fold handles failure path', () {
      final result = Result<String, Failure>.failure(failure);

      final output = result.fold(
        onSuccess: (data) => data,
        onFailure: (f) => f.message,
      );

      check(output).equals(failure.message);
    });
    
    test('when handles success path', () {
      final result = Result<String, Failure>.success(successData);

      final output = result.when(
        success: (data) => 'success',
        failure: (f) => 'failure',
      );

      check(output).equals('success');
    });

    test('when handles failure path', () {
      final result = Result<String, Failure>.failure(failure);

      final output = result.when(
        success: (data) => 'success',
        failure: (f) => 'failure',
      );

      check(output).equals('failure');
    });
  });
}
