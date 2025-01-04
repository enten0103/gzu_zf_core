import 'package:html/parser.dart';

Map<String, Map<String, String>> navFlatten(String rawHtml) {
  Map<String, Map<String, String>> result = {};
  var document = parse(rawHtml);
  var nav = document.getElementsByClassName("nav")[0];
  var lis = nav.children;
  for (var i = 0; i < lis.length; i++) {
    var li = lis[i];
    var titleLv1 = li.getElementsByTagName("span")[0];
    var as = li.getElementsByTagName("a");
    Map<String, String> titleLv2 = {};
    for (var j = 0; j < as.length; j++) {
      var a = as[j];
      titleLv2[a.text.trim()] = a.attributes['href']!;
    }

    result[titleLv1.text.trim()] = titleLv2;
  }

  return result;
}
