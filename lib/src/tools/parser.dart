import 'package:fast_gbk/fast_gbk.dart';
import 'package:gzu_zf_core/src/exception/error.dart';
import 'package:html/parser.dart';

class Parser {
  ///从请求中解析viewstate
  ///[data] 原始数据
  ///[selector] 选择器，用于定位
  ///[index] parser中子代定位存在问题，暂用index代替
  static String viewStateParse(List<int> data, String selector, [int? index]) {
    var document = parse(gbk.decode(data));
    try {
      final element = index != null
          ? document.querySelectorAll(selector)[index]
          : document.querySelector(selector);
      var raw = element?.attributes["value"];
      if (raw == null) throw CannotParse();
      return raw;
    } catch (e) {
      throw CannotParse();
    }
  }

  static String? resultParse(List<int> data, String selector) {
    return parse(gbk.decode(data)).querySelector(selector)?.innerHtml;
  }
}
