import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:fast_gbk/fast_gbk.dart';
import 'package:gzu_zf_core/gzu_zf_core.dart';
import 'package:gzu_zf_core/src/entity/select_course.dart';
import 'package:gzu_zf_core/src/tools/string_tool.dart';
import 'package:html/parser.dart';

///对应页面“信息查询”->“选课查询”
class CourseImpl {
  final Dio client;

  CourseImpl({required this.client});

  Future<List<SelectCourse>> getAllSelectCourse(
      String url, String referer, String username) async {
    var viewState = await firstQuest(url, referer);
    var years = genYears(username);
    List<Future<String>> futures = [];
    for (var i = 0; i < years.length; i++) {
      var year = years[i];
      futures.add(pageQuest(year, '1', viewState, url, referer));
      futures.add(pageQuest(year, '2', viewState, url, referer));
    }
    var result = await Future.wait(futures);
    List<SelectCourse> courses = [];
    for (var i = 0; i < result.length; i++) {
      courses.addAll(rawparse(result[i]));
    }
    return courses;
  }

  Future<String> firstQuest(String url, String referer) async {
    final response = await client.get("https://jw.gzu.edu.cn/$url",
        options: Options(
            responseType: ResponseType.bytes,
            headers: {
              "sec-fetch-dest": "iframe",
              "referer": "https://jw.gzu.edu.cn/$referer"
            },
            validateStatus: (code) {
              return code == 200 || code == 429;
            }));
    if (response.statusCode == 429) {
      throw NetNarrow();
    }
    final document = parse(gbk.decode(response.data));
    try {
      final element = document.querySelectorAll("#Form1 > input")[2];
      var raw = element.attributes["value"];
      if (raw == null) throw CannotParse();
      return raw;
    } catch (e) {
      throw CannotParse();
    }
  }

  Future<String> pageQuest(String? year, String? term, String? viewState,
      String url, String referer) async {
    var formData = {
      '__EVENTTARGET': term == '1' ? 'ddlXN' : "ddlXQ",
      '__EVENTARGUMENT': '',
      '__VIEWSTATE': viewState,
      'ddlXN': year,
      'ddlXQ': term
    };

    final response = await client.post("https://jw.gzu.edu.cn/$url",
        options: Options(
            responseType: ResponseType.bytes,
            headers: {
              "sec-fetch-dest": "iframe",
              "referer": "https://jw.gzu.edu.cn/${encodeFullGbk(url)}"
            },
            validateStatus: (code) {
              return code == 200 || code == 429;
            }),
        data: FormData.fromMap(formData));
    if (response.statusCode == 429) {
      throw NetNarrow();
    }
    final document = parse(gbk.decode(response.data));
    try {
      final element = document.querySelectorAll("#Form1 > input")[2];
      var raw = element.attributes["value"];
      if (raw == null) throw CannotParse();
      return raw;
    } catch (e) {
      return "";
    }
  }

  List<SelectCourse> rawparse(String raw) {
    var textDecode = utf8.decode(base64Decode(raw), allowMalformed: true);
    var textSplited = textDecode.split('<Text;>;l');
    var textlist = [];
    for (var i = 0; i < textSplited.length; i++) {
      var text = textSplited[i];
      int startIndex = text.indexOf('<');
      int endIndex = text.indexOf(';', startIndex);
      if (startIndex != -1 && endIndex != -1) {
        // 提取尖括号之间的内容
        var result = text.substring(startIndex + 1, endIndex).trim();
        if (i % 24 == 3 || i % 24 == 6) {
          result = (parse(result).body?.text ?? result);
        }
        var textResult = result.trim().replaceAll("\\", "");
        if (textResult == '&nbsp') {
          textResult = "";
        }
        textlist.add(textResult);
        if (i % 24 == 9) {
          var tr = extractWeekHour(text).trim().replaceAll("\\", "");
          if (tr == "e") {
            textlist.add("");
          } else {
            textlist.add(tr);
          }
        }
      }
    }
    var textListSplited = splitList(textlist, 25, 1);
    var result = textListSplited.map((element) {
      return SelectCourse(
          courseSelectionNumber: element[0],
          courseCode: element[1],
          courseName: element[2],
          courseNature: element[3],
          isSelect: element[4],
          teacherName: element[5],
          credit: element[7],
          weeklyHours: element[8],
          classTime: element[9],
          classLocation: element[10],
          textBook: element[11]);
    });
    return result.toList();
  }

  String encodeFullGbk(String text) {
    final Set<int> dontEscape = {
      0x2D, 0x2E, 0x5F, 0x7E, // -._~
      0x21, 0x28, 0x29, 0x2A, // !()*
      0x27, // '
      0x3A, 0x2F, 0x3F, // :/?
      0x26, 0x3D, // &=
    };

    List<int> gbkBytes = gbk.encode(text);

    return gbkBytes.map((byte) {
      if ((byte >= 0x30 && byte <= 0x39) || // 0-9
          (byte >= 0x41 && byte <= 0x5A) || // A-Z
          (byte >= 0x61 && byte <= 0x7A) || // a-z
          dontEscape.contains(byte)) {
        return String.fromCharCode(byte);
      } else {
        return '%' + byte.toRadixString(16).toUpperCase().padLeft(2, '0');
      }
    }).join();
  }
}
