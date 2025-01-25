import 'package:dio/dio.dart';
import 'package:gzu_zf_core/gzu_zf_core.dart';

class ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (err.type == DioExceptionType.connectionTimeout) {
      print("to");
      handler.reject(
        DioException(
          requestOptions: err.requestOptions,
          error: SchoolNetCannotAccess(),
        ),
      );
    } else if (err.response?.statusCode == 429) {
      handler.reject(
        DioException(
          requestOptions: err.requestOptions,
          error: NetNarrow(),
        ),
      );
    } else {
      // 其他错误继续传递
      handler.next(err);
    }
  }
}
