import 'package:fast_gbk/fast_gbk.dart';
import 'package:gzu_zf_core/src/exception/error.dart';
import 'package:html/parser.dart';

class Parser {
  static String viewStateParse(List<int> data) {
    try {
      var result = gbk.decode(data);
      var pattern = "name=\"__VIEWSTATE\" value=\"";
      var start = result.indexOf(pattern);
      var end = result.indexOf("\"", start + pattern.length);
      var raw = result.substring(start + pattern.length, end);
      return raw;
    } catch (e) {
      throw CannotParse();
    }
  }

  static String? resultParse(List<int> data, String selector) {
    return parse(gbk.decode(data)).querySelector(selector)?.innerHtml;
  }
}
