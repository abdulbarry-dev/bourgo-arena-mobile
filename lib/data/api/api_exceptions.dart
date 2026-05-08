/// Base class for all API exceptions.
abstract class ApiException implements Exception {
  final String message;
  const ApiException(this.message);

  @override
  String toString() => message;
}

class ServerException extends ApiException {
  const ServerException([super.message = 'Server Error']);
}

class AuthException extends ApiException {
  const AuthException([super.message = 'Authentication Error']);
}

class NotFoundException extends ApiException {
  const NotFoundException([super.message = 'Resource Not Found']);
}

class NetworkException extends ApiException {
  const NetworkException([super.message = 'Network Error']);
}

class ValidationException extends ApiException {
  const ValidationException([super.message = 'Validation Error']);
}
