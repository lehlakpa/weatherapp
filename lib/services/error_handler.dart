import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/network_error.dart';
import '../widgets/custom_notification.dart';

class ErrorHandler {
  /// Maps any exception or error object to a structured NetworkException
  static NetworkException handle(Object error) {
    if (error is NetworkException) {
      return error;
    }

    if (error is http.Response) {
      return _handleHttpResponse(error);
    }

    if (error is SocketException) {
      return ConnectionException();
    }

    if (error is TimeoutException) {
      return TimeoutException();
    }

    if (error is FormatException) {
      return ParsingException();
    }

    // Match string patterns for other network error cases
    final errorStr = error.toString().toLowerCase();
    if (errorStr.contains('socketexception') || errorStr.contains('failed host lookup')) {
      return ConnectionException();
    }
    if (errorStr.contains('timeout')) {
      return TimeoutException();
    }
    if (errorStr.contains('formatexception') || errorStr.contains('unexpected character')) {
      return ParsingException();
    }

    return UnknownException(message: error.toString());
  }

  static NetworkException _handleHttpResponse(http.Response response) {
    final statusCode = response.statusCode;
    switch (statusCode) {
      case 401:
      case 403:
        return UnauthorizedException(statusCode: statusCode);
      case 404:
        return NotFoundException(
          message: 'The requested city or weather resource could not be found.',
          statusCode: statusCode,
        );
      case 500:
      case 502:
      case 503:
      case 504:
        return ServerException(statusCode: statusCode);
      default:
        return UnknownException(
          message: 'Request failed with status code: $statusCode',
          statusCode: statusCode,
        );
    }
  }

  /// Displays the custom notification overlay for any occurred error
  static void showErrorNotification(BuildContext context, Object error) {
    final exception = handle(error);
    CustomNotification.showError(
      context,
      exception.message,
      title: _getErrorTitle(exception.type),
    );
  }

  static String _getErrorTitle(NetworkErrorType type) {
    switch (type) {
      case NetworkErrorType.connection:
        return 'No Connection';
      case NetworkErrorType.timeout:
        return 'Connection Timeout';
      case NetworkErrorType.unauthorized:
        return 'Authentication Failed';
      case NetworkErrorType.notFound:
        return 'Location Not Found';
      case NetworkErrorType.server:
        return 'Service Error';
      case NetworkErrorType.parsing:
        return 'Response Error';
      case NetworkErrorType.unknown:
        return 'An Error Occurred';
    }
  }
}
