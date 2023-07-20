import 'dart:io';

import 'package:dio/dio.dart' hide Headers;

class ServerError implements Exception {
  ServerError.withError({required DioException error}) {
    _handleError(error);
  }

  int? _errorCode;

  String _errorMessage = '';

  int? getErrorCode() => _errorCode;

  String getErrorMessage() => _errorMessage;

  String _handleError(DioException error) {
    switch (error.type) {
      case DioExceptionType.cancel:
        _errorMessage = 'Request was cancelled';
      case DioExceptionType.connectionTimeout:
        _errorMessage = 'Connection timeout';
      case DioExceptionType.connectionError:
        _errorMessage = 'Connection error';
      case DioExceptionType.unknown:
        if (error.error is SocketException) {
          _errorMessage = 'Connection failed due to internet connection';
        } else {
          _errorMessage = error.error.toString();
        }
      case DioExceptionType.receiveTimeout:
        _errorMessage = 'Receive timeout in connection';
      case DioExceptionType.badResponse:
        _errorMessage = 'BadResponse: Received invalid status code:'
            ' ${error.response!.statusCode}';
      case DioExceptionType.badCertificate:
        _errorMessage = 'BadCertificate: Received invalid status code:'
            ' ${error.response!.statusCode}';
      case DioExceptionType.sendTimeout:
        _errorMessage = 'Receive timeout in send request';
    }
    return _errorMessage;
  }
}
