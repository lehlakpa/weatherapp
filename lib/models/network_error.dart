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
  ConnectionException({super.message = 'No internet connection. Please check your network.'})
      : super(type: NetworkErrorType.connection);
}

class TimeoutException extends NetworkException {
  TimeoutException({super.message = 'Connection timed out. Please try again.'})
      : super(type: NetworkErrorType.timeout);
}

class UnauthorizedException extends NetworkException {
  UnauthorizedException({super.message = 'Invalid API key or unauthorized request. Please check your credentials.', super.statusCode})
      : super(type: NetworkErrorType.unauthorized);
}

class NotFoundException extends NetworkException {
  NotFoundException({super.message = 'Requested resource or city could not be found.', super.statusCode})
      : super(type: NetworkErrorType.notFound);
}

class ServerException extends NetworkException {
  ServerException({super.message = 'Internal server error. Please try again later.', super.statusCode})
      : super(type: NetworkErrorType.server);
}

class ParsingException extends NetworkException {
  ParsingException({super.message = 'Failed to process data format from the server.'})
      : super(type: NetworkErrorType.parsing);
}

class UnknownException extends NetworkException {
  UnknownException({super.message = 'An unexpected error occurred. Please try again.', super.statusCode})
      : super(type: NetworkErrorType.unknown);
}
