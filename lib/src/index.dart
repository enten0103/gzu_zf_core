import 'package:dio/dio.dart';
import 'package:gzu_zf_core/gzu_zf_core.dart';
import 'package:gzu_zf_core/src/impl/course_impl.dart';
import 'package:gzu_zf_core/src/impl/login_impl.dart';
import 'package:gzu_zf_core/src/impl/score_impl.dart';
import 'package:gzu_zf_core/src/interceptors/cookie_interceptor.dart';
import 'package:gzu_zf_core/src/interceptors/error_interceptor.dart';

class ZfImpl {
  final Map<String, dynamic> _sourceMap = {};
  final String _username;
  final String _password;
  final Dio client;

  Map<String, Map<String, String>> _navList = {};

  ZfImpl(this._username, this._password, this.client);

  Future<Map<String, Map<String, String>>> login() async {
    LoginImpl loginImpl = LoginImpl(zfImpl: this);
    _navList = await loginImpl.login(_username, _password);
    return _navList;
  }

  Future<Account> queryAccountInfo() async {
    if (_sourceMap["accountInfo"] != null) {
      return _sourceMap["accountInfo"] as Account;
    }
    ScoreImpl scoreImpl = ScoreImpl(zfImpl: this);
    var url = _navList['信息查询']?['成绩查询'];
    var referer = _navList['返回首页']?['返回首页'];
    if (url == null || referer == null) {
      throw NoSuchNav();
    }

    var result = await scoreImpl.quryScorePage(url, referer);
    var accountInfo = result["accountInfo"] as Account;
    _sourceMap["scores"] = result["scoreRows"] as List<Score>;
    _sourceMap["accountInfo"] = accountInfo;
    return accountInfo;
  }

  Future<List<Score>> queryScores() async {
    if (_sourceMap["scores"] != null) {
      return _sourceMap["scores"] as List<Score>;
    }
    var url = _navList['信息查询']?['成绩查询'];
    var referer = _navList['返回首页']?['返回首页'];
    if (url == null || referer == null) {
      throw NoSuchNav();
    }
    ScoreImpl scoreImpl = ScoreImpl(zfImpl: this);
    var result = await scoreImpl.quryScorePage(url, referer);
    List<Score> scores = result["scoreRows"] as List<Score>;
    _sourceMap["scores"] = scores;
    _sourceMap["accountInfo"] = result["accountInfo"] as Account;
    return scores;
  }

  Future<List<Course>> querySelectCourses() async {
    if (_sourceMap["all_select_courese"] != null) {
      return _sourceMap["all_select_courese"] as List<Course>;
    }
    var url = _navList['信息查询']?['学生选课情况查询'];
    var referer = _navList['返回首页']?['返回首页'];
    if (url == null || referer == null) {
      throw NoSuchNav();
    }
    CourseImpl courseImpl = CourseImpl(zfImpl: this);
    var result = await courseImpl.getAllSelectCourse(url, referer, _username);
    _sourceMap["all_select_courese"] == result;
    return result;
  }

  static ZfImpl getImpl(String username, String password) {
    var client = Dio();
    client.interceptors.add(CookieInterceptor());
    client.interceptors.add(ErrorInterceptor());
    client.options.connectTimeout = Duration(seconds: 10);
    client.options.headers['User-Agent'] =
        "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36";
    return ZfImpl(username, password, client);
  }
}
