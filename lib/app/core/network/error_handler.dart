import 'package:dio/dio.dart';
import 'app_exception.dart';

class ErrorHandler {
  static AppException map(DioException error) {
    switch (error.type) {
      case DioExceptionType.cancel:
        return RequestCancelledException();

      case DioExceptionType.connectionTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.sendTimeout:
        return TimeoutException();

      case DioExceptionType.badCertificate:
        return ServerException("Invalid SSL certificate");

      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode ?? 0;
        switch (statusCode) {
          case 400:
            return BadRequestException();
          case 401:
            return UnauthorizedException();
          case 404:
            return NotFoundException();
          case 500:
          case 502:
          case 503:
            return ServerException("Server error ($statusCode)");
          default:
            return ServerException("Unexpected server error ($statusCode)");
        }

      case DioExceptionType.connectionError:
        return NetworkException("Connection error");

      case DioExceptionType.unknown:
        return UnknownException(error.message ?? "Unexpected error");
    }
  }
}
