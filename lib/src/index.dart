import 'package:dio/dio.dart';
import 'package:gzu_zf_core/src/exception/error.dart';
import 'package:gzu_zf_core/src/impl/course_impl.dart';
import 'package:gzu_zf_core/src/impl/login_impl.dart';
import 'package:gzu_zf_core/src/impl/score_impl.dart';
import 'package:gzu_zf_core/src/tools/cookie_interceptor.dart';

class ZfImpl {
  final String _username;
  final String _password;
  final Dio _client;

  Map<String, Map<String, String>> _navList = {};

  ZfImpl(this._username, this._password, this._client);

  Future<Map<String, Map<String, String>>> login() async {
    LoginImpl loginImpl = LoginImpl(client: _client);
    _navList = await loginImpl.login(_username, _password);
    return _navList;
  }

  Future<Map<String, Object>> queryScore() async {
    var url = _navList['信息查询']?['成绩查询'];
    var referer = _navList['返回首页']?['返回首页'];
    if (url == null || referer == null) {
      throw NoSuchNav();
    }
    ScoreImpl scoreImpl = ScoreImpl(client: _client);
    return scoreImpl.quryScorePage(url, referer);
  }

  Future queryAllCourse() async {
    var url = _navList['信息查询']?['学生选课情况查询'];
    var referer = _navList['返回首页']?['返回首页'];
    if (url == null || referer == null) {
      throw NoSuchNav();
    }
    CourseImpl courseImpl = CourseImpl(client: _client);
    return courseImpl.getAllSelectCourse(url, referer, _username);
  }

  static ZfImpl getImpl(String username, String password) {
    var client = Dio();
    client.interceptors.add(CookieInterceptor());
    client.options.connectTimeout = Duration(seconds: 10);
    client.options.headers['User-Agent'] =
        "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36";
    return ZfImpl(username, password, client);
  }
}
