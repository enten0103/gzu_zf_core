import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:gzu_zf_core/gzu_zf_core.dart';
import 'package:gzu_zf_core/src/tools/parser.dart';

///对应页面“信息查询”->“成绩查询”
class ScoreImpl {
  final ZfImpl zfImpl;

  ScoreImpl({required this.zfImpl});

  Future<Map<String, Object>> quryScorePage(String url, String referer) async {
    var viewState = await getViewState(url, referer);
    var rawData = await getRawData(url, referer, viewState);
    return rawParse(rawData);
  }

  Future<String> getViewState(String url, String referer) async {
    final response = await zfImpl.client.get("https://jw.gzu.edu.cn/$url",
        options: Options(responseType: ResponseType.bytes, headers: {
          "sec-fetch-dest": "iframe",
          "referer": "https://jw.gzu.edu.cn/$referer"
        }));
    return Parser.viewStateParse(response.data, "#Form1 > input[type=hidden]");
  }

  Future<String> getRawData(
      String url, String referer, String viewState) async {
    final response = await zfImpl.client.post("https://jw.gzu.edu.cn/$url",
        data: FormData.fromMap({
          '__VIEWSTATE': viewState,
          'Button2': '%D4%DA%D0%A3%D1%A7%CF%B0%B3%C9%BC%A8%B2%E9%D1%AF'
        }),
        options: Options(responseType: ResponseType.bytes, headers: {
          "sec-fetch-dest": "iframe",
          "referer": "https://jw.gzu.edu.cn/$referer"
        }));

    var raw =
        Parser.viewStateParse(response.data, "#Form1 > input[type=hidden]");
    return utf8.decode(base64Decode(raw), allowMalformed: true);
  }

  Map<String, Object> rawParse(String rawData) {
    try {
      var texts = rawData.split('<Text;>;l');
      List<String> baseInfo = [];
      List<String> courseInfo = [];
      var index = 0;
      for (var i = 0; i < texts.length; i++) {
        var text = texts[i];
        int startIndex = text.indexOf('<');
        int endIndex = text.indexOf(';', startIndex);

        if (startIndex != -1 && endIndex != -1) {
          // 提取尖括号之间的内容
          var result = text.substring(startIndex + 1, endIndex).trim();
          if (result == '&nbsp\\') {
            result = " ";
          }
          if (index == 0) {
            baseInfo.add(result.trim());
          } else {
            courseInfo.add(result.trim());
          }
          if (text.contains("PageCount")) {
            if (index == 1) {
              break;
            }
            index++;
          }
        }
      }

      var courseInfos = splitList(courseInfo, 22);
      var scoreRows = courseInfos.map((rawCourse) {
        return Score(
            schoolYear: rawCourse[0],
            semester: rawCourse[1],
            courseCode: rawCourse[2],
            courseName: rawCourse[3],
            courseNature: rawCourse[4],
            courseOwnership: rawCourse[5],
            credit: rawCourse[6],
            gradePoint: rawCourse[8],
            score: rawCourse[13],
            minorMark: rawCourse[14],
            makeUpScore: rawCourse[15],
            retakeScore: rawCourse[17],
            collegeName: rawCourse[18],
            remake: rawCourse[19],
            retakeMark: rawCourse[20],
            courseNameEnglish: rawCourse[21]);
      });
      var accountInfo = Account(
          studentNumber: baseInfo[1].split('：')[1],
          name: baseInfo[2].split('：')[1],
          college: baseInfo[3].split('：')[1],
          major: baseInfo[5],
          administrativeClass: baseInfo[6].split('：')[1]);
      return {'accountInfo': accountInfo, 'scoreRows': scoreRows.toList()};
    } catch (e) {
      throw CannotParse();
    }
  }

  List<List<T>> splitList<T>(List<T> list, int chunkSize) {
    List<List<T>> chunks = [];
    for (int i = 0; i < list.length; i += chunkSize) {
      int end = (i + chunkSize < list.length) ? i + chunkSize : list.length;
      chunks.add(list.sublist(i, end));
    }

    return chunks;
  }
}
