abstract class AppException implements Exception {
  final String message;
  final String? prefix;
  AppException(this.message, [this.prefix]);
  @override
  String toString() {
    return "${prefix ?? ''} $message";
  }
}

/// Lỗi chung chung (không xác định)
class UnknownException extends AppException {
  UnknownException([String message = "Unknown error"])
    : super(message, "Unknown: ");
}

/// Lỗi kết nối mạng
class NetworkException extends AppException {
  NetworkException([String message = "No Internet connection"])
    : super(message, "Network: ");
}

/// Lỗi request bị hủy
class RequestCancelledException extends AppException {
  RequestCancelledException([String message = "Request cancelled"])
    : super(message, "Cancelled: ");
}

/// Lỗi timeout khi kết nối hoặc nhận data
class TimeoutException extends AppException {
  TimeoutException([String message = "Connection timeout"])
    : super(message, "Timeout: ");
}

/// Lỗi từ server trả về
class ServerException extends AppException {
  ServerException([String message = "Server error"])
    : super(message, "Server: ");
}

/// Lỗi dữ liệu không hợp lệ
class BadRequestException extends AppException {
  BadRequestException([String message = "Invalid request"])
    : super(message, "Bad Request: ");
}

/// Lỗi không có quyền (401)
class UnauthorizedException extends AppException {
  UnauthorizedException([String message = "Unauthorized"])
    : super(message, "Unauthorized: ");
}

/// Lỗi không tìm thấy resource (404)
class NotFoundException extends AppException {
  NotFoundException([String message = "Resource not found"])
    : super(message, "Not Found: ");
}
// Loi sign in
class AuthAppException extends AppException {
  AuthAppException(String message) : super(message, "Auth Error: ");
}
