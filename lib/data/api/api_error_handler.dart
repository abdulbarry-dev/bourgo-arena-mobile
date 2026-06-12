import 'package:bourgo_arena_mobile/core/utils/result.dart';
import 'package:bourgo_arena_mobile/domain/core/failure.dart';
import 'package:bourgo_arena_mobile/domain/core/app_error_code.dart';
import 'package:bourgo_arena_mobile/data/api/api_exceptions.dart';
import 'dart:developer' as developer;

/// Executes an API call and automatically maps exceptions to the correct [Failure] subclass.
Future<Result<T, Failure>> executeApiCall<T>(
  Future<Result<T, Failure>> Function() call,
) async {
  try {
    return await call();
  } on AuthException catch (e) {
    developer.log('API AuthException: ${e.message}');
    return FailureResult(
      AuthFailure(AppErrorCode.invalidCredentials, e.message, e.state, e.token),
    );
  } on NetworkException catch (e) {
    developer.log('API NetworkException: ${e.message}');
    return FailureResult(
      NetworkFailure(AppErrorCode.networkUnavailable, e.message),
    );
  } on ValidationException catch (e) {
    developer.log('API ValidationException: ${e.message}');
    return FailureResult(
      ValidationFailure(
        AppErrorCode.validationFailed,
        e.message,
        e.state,
        e.token,
        e.errors,
      ),
    );
  } on NotFoundException catch (e) {
    developer.log('API NotFoundException: ${e.message}');
    return FailureResult(
      NotFoundFailure(AppErrorCode.notFound, e.message, e.state, e.token),
    );
  } on ForbiddenException catch (e) {
    developer.log('API ForbiddenException: ${e.message}');
    return FailureResult(
      ServerFailure(AppErrorCode.serverError, e.message, e.state, e.token),
    );
  } on ServerException catch (e) {
    developer.log('API ServerException: ${e.message}');
    return FailureResult(
      ServerFailure(AppErrorCode.serverError, e.message, e.state, e.token),
    );
  } catch (e, stack) {
    developer.log('Unexpected API error', error: e, stackTrace: stack);
    return FailureResult(ServerFailure(AppErrorCode.serverError, e.toString()));
  }
}
