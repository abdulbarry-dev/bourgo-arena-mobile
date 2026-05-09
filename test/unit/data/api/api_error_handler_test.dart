import 'package:bourgo_arena_mobile/data/api/api_error_handler.dart';
import 'package:bourgo_arena_mobile/data/api/api_exceptions.dart';
import 'package:bourgo_arena_mobile/domain/core/failure.dart';
import 'package:test/test.dart';

void main() {
  test('maps AuthException to AuthFailure', () async {
    final res = await executeApiCall<int>(
      () async => throw AuthException('no'),
    );
    expect(res.isFailure, isTrue);
    res.fold(
      onFailure: (f) => expect(f, isA<AuthFailure>()),
      onSuccess: (_) => fail('expected failure'),
    );
  });

  test('maps NetworkException to NetworkFailure', () async {
    final res = await executeApiCall<int>(
      () async => throw NetworkException('net'),
    );
    expect(res.isFailure, isTrue);
    res.fold(
      onFailure: (f) => expect(f, isA<NetworkFailure>()),
      onSuccess: (_) => fail('expected failure'),
    );
  });

  test('maps ValidationException to ValidationFailure', () async {
    final res = await executeApiCall<int>(
      () async => throw ValidationException('v'),
    );
    expect(res.isFailure, isTrue);
    res.fold(
      onFailure: (f) => expect(f, isA<ValidationFailure>()),
      onSuccess: (_) => fail('expected failure'),
    );
  });

  test('maps NotFoundException to NotFoundFailure', () async {
    final res = await executeApiCall<int>(
      () async => throw NotFoundException('n'),
    );
    expect(res.isFailure, isTrue);
    res.fold(
      onFailure: (f) => expect(f, isA<NotFoundFailure>()),
      onSuccess: (_) => fail('expected failure'),
    );
  });

  test('maps ServerException to ServerFailure', () async {
    final res = await executeApiCall<int>(
      () async => throw ServerException('s'),
    );
    expect(res.isFailure, isTrue);
    res.fold(
      onFailure: (f) => expect(f, isA<ServerFailure>()),
      onSuccess: (_) => fail('expected failure'),
    );
  });

  test('maps unknown exception to ServerFailure', () async {
    final res = await executeApiCall<int>(() async => throw Exception('x'));
    expect(res.isFailure, isTrue);
    res.fold(
      onFailure: (f) => expect(f, isA<ServerFailure>()),
      onSuccess: (_) => fail('expected failure'),
    );
  });
}
