/// Base class for all API exceptions.
abstract class ApiException implements Exception {
  final String message;
  final String? state;
  final String? token;
  const ApiException(this.message, {this.state, this.token});

  @override
  String toString() => message;
}

class ServerException extends ApiException {
  const ServerException([
    super.message = 'Server Error',
    String? state,
    String? token,
  ]) : super(state: state, token: token);
}

class AuthException extends ApiException {
  const AuthException([
    super.message = 'Authentication Error',
    String? state,
    String? token,
  ]) : super(state: state, token: token);
}

class NotFoundException extends ApiException {
  const NotFoundException([
    super.message = 'Resource Not Found',
    String? state,
    String? token,
  ]) : super(state: state, token: token);
}

class NetworkException extends ApiException {
  const NetworkException([
    super.message = 'Network Error',
    String? state,
    String? token,
  ]) : super(state: state, token: token);
}

class ValidationException extends ApiException {
  final Map<String, List<String>>? errors;

  const ValidationException([
    super.message = 'Validation Error',
    String? state,
    String? token,
    this.errors,
  ]) : super(state: state, token: token);
}
