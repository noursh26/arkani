class AppException implements Exception {
  final String message;
  final String? code;

  const AppException(this.message, {this.code});

  @override
  String toString() => message;
}

class NetworkException extends AppException {
  const NetworkException(super.message);
}

class ApiException extends AppException {
  final int? statusCode;

  const ApiException(super.message, {this.statusCode});

  @override
  String toString() => 'ApiException: $message (Status: $statusCode)';
}

class CacheException extends AppException {
  const CacheException(super.message);
}

class NotFoundException extends AppException {
  const NotFoundException(super.message);
}

class ValidationException extends AppException {
  final Map<String, dynamic>? errors;

  const ValidationException(super.message, {this.errors});
}

class UnauthorizedException extends AppException {
  const UnauthorizedException(super.message);
}

class ServerException extends AppException {
  const ServerException(super.message);
}

class UnknownException extends AppException {
  const UnknownException(super.message);
}

class RequestCancelledException extends AppException {
  const RequestCancelledException(super.message);
}
