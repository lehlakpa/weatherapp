enum NetworkErrorType {
  connection,
  timeout,
  unauthorized,
  notFound,
  server,
  parsing,
  unknown,
}

abstract class NetworkException implements Exception {
  final String message;
  final NetworkErrorType type;
  final int? statusCode;

  NetworkException({
    required this.message,
    required this.type,
    this.statusCode,
  });

  @override
  String toString() => 'NetworkException(type: $type, message: $message, statusCode: $statusCode)';
}

class ConnectionException extends NetworkException {
  ConnectionException({String message = 'No internet connection. Please check your network.'})
      : super(message: message, type: NetworkErrorType.connection);
}

class TimeoutException extends NetworkException {
  TimeoutException({String message = 'Connection timed out. Please try again.'})
      : super(message: message, type: NetworkErrorType.timeout);
}

class UnauthorizedException extends NetworkException {
  UnauthorizedException({String message = 'Invalid API key or unauthorized request. Please check your credentials.', int? statusCode})
      : super(message: message, type: NetworkErrorType.unauthorized, statusCode: statusCode);
}

class NotFoundException extends NetworkException {
  NotFoundException({String message = 'Requested resource or city could not be found.', int? statusCode})
      : super(message: message, type: NetworkErrorType.notFound, statusCode: statusCode);
}

class ServerException extends NetworkException {
  ServerException({String message = 'Internal server error. Please try again later.', int? statusCode})
      : super(message: message, type: NetworkErrorType.server, statusCode: statusCode);
}

class ParsingException extends NetworkException {
  ParsingException({String message = 'Failed to process data format from the server.'})
      : super(message: message, type: NetworkErrorType.parsing);
}

class UnknownException extends NetworkException {
  UnknownException({String message = 'An unexpected error occurred. Please try again.', int? statusCode})
      : super(message: message, type: NetworkErrorType.unknown, statusCode: statusCode);
}
