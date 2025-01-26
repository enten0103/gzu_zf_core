import 'package:gzu_zf_core/src/exception/error.dart';

List<List<T>> splitList<T>(List<T> list, int chunkSize, startIndex) {
  List<List<T>> chunks = [];
  for (int i = startIndex; i < list.length; i += chunkSize) {
    // 使用 sublist 方法提取子数组
    int end = (i + chunkSize < list.length) ? i + chunkSize : list.length;
    chunks.add(list.sublist(i, end));
  }

  return chunks;
}

String extractATag(String htmlString) {
  // 查找最后一个 '>' 的位置
  int lastBracketIndex = htmlString.lastIndexOf('>');

  // 查找最后一个 '<' 的位置
  int lastClosingBracketIndex = htmlString.lastIndexOf('<');

  if (lastBracketIndex != -1 &&
      lastClosingBracketIndex != -1 &&
      lastBracketIndex < lastClosingBracketIndex) {
    return htmlString.substring(lastBracketIndex + 1, lastClosingBracketIndex);
  }

  return htmlString;
}

String extractWeekHour(String input) {
  RegExp regex = RegExp(r'@<(.*?)>');

  Match? match = regex.firstMatch(input);

  if (match != null && match.groupCount >= 1) {
    return match.group(1) ?? '';
  }

  return "";
}

List<String> genYears(String username) {
  return generateAcademicYears(2000 + extractYear(username));
}

int extractYear(String studentId) {
  if (studentId.length >= 2) {
    return int.parse(studentId.substring(0, 2));
  }
  throw CannotParse();
}

List<String> generateAcademicYears(int startYear) {
  int currentYear = DateTime.now().year; // 假设当前是2025年
  List<String> academicYears = [];

  for (int year = startYear; year <= currentYear + 1; year++) {
    String academicYear = '$year-${year + 1}';
    academicYears.add(academicYear);
  }

  return academicYears;
}
