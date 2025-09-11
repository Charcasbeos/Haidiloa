import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:haidiloa/app/core/network/error_handler.dart';

class AppInterceptors extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // xử lý trước khi gửi request.
    debugPrint("➡️ REQUEST[${options.method}] => PATH: ${options.uri}");
    debugPrint("Headers: ${options.headers}");
    debugPrint("Data: ${options.data}");
    handler.next(options); // tiếp tục
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    // TODO: xử lý sau khi nhận response từ server.
    debugPrint(
      "✅ RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.uri}",
    );
    debugPrint("Data: ${response.data}");
    handler.next(response); // tiếp tục
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // TODO: xử lý khi request gặp lỗi.
    // Map DioException → AppException
    final appException = ErrorHandler.map(err);

    // Log lỗi
    debugPrint(
      "❌ ERROR[${err.response?.statusCode}] => PATH: ${err.requestOptions.uri}",
    );
    debugPrint(
      "Mapped Exception: ${appException.runtimeType} - ${appException.message}",
    );

    // Bạn có thể trả về lại DioError mới hoặc throw AppException
    handler.reject(
      err.copyWith(error: appException), // gắn AppException vào error
    );
  }
}
