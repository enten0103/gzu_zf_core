import 'package:dio/dio.dart';
import 'dart:io';

class CookieInterceptor extends Interceptor {
  final Map<String, String> cookies = {};

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // 将 Cookie 添加到请求头
    if (cookies.isNotEmpty) {
      options.headers['Cookie'] = cookies.entries
          .map((entry) => '${entry.key}=${entry.value}')
          .join('; ');
    }
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    // 从响应头中提取 Set-Cookie
    if (response.headers['set-cookie'] != null) {
      for (var header in response.headers['set-cookie']!) {
        var cookie = Cookie.fromSetCookieValue(header);
        cookies[cookie.name] = cookie.value;
      }
    }
    super.onResponse(response, handler);
  }
}
