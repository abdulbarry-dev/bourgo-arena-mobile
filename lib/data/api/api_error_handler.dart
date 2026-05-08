import 'package:bourgo_arena_mobile/core/utils/result.dart';
import 'package:bourgo_arena_mobile/domain/core/failure.dart';
import 'package:bourgo_arena_mobile/data/api/api_exceptions.dart';
import 'dart:developer' as developer;

/// Executes an API call and automatically maps exceptions to the correct [Failure] subclass.
Future<Result<T, Failure>> executeApiCall<T>(Future<Result<T, Failure>> Function() call) async {
  try {
    return await call();
  } on AuthException catch (e) {
    return FailureResult(AuthFailure(e.message));
  } on NetworkException catch (e) {
    return FailureResult(NetworkFailure(e.message));
  } on ValidationException catch (e) {
    return FailureResult(ValidationFailure(e.message));
  } on NotFoundException catch (e) {
    return FailureResult(NotFoundFailure(e.message));
  } on ServerException catch (e) {
    return FailureResult(ServerFailure(e.message));
  } catch (e, stack) {
    developer.log('Unexpected API error', error: e, stackTrace: stack);
    return FailureResult(ServerFailure(e.toString()));
  }
}
