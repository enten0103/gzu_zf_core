import 'dart:convert';

class ScoreRow {
  ///学年
  final String schoolYear;

  ///学期
  final String semester;

  ///课程代码
  final String courseCode;

  ///课程名称
  final String courseName;

  ///课程性质
  final String courseNature;

  ///课程归属
  final String courseOwnership;

  ///学分
  final String credit;

  ///绩点
  final String gradePoint;

  ///成绩
  final String score;

  ///辅修标记
  final String minorMark;

  ///补考成绩
  final String makeUpScore;

  ///重修成绩
  final String retakeScore;

  ///学院名称
  final String collegeName;

  ///备注
  final String remake;

  ///重修标记
  final String retakeMark;

  ///课程英文名
  final String courseNameEnglish;
  ScoreRow(
      {required this.schoolYear,
      required this.semester,
      required this.courseCode,
      required this.courseName,
      required this.courseNature,
      required this.courseOwnership,
      required this.credit,
      required this.gradePoint,
      required this.score,
      required this.minorMark,
      required this.makeUpScore,
      required this.retakeScore,
      required this.collegeName,
      required this.remake,
      required this.retakeMark,
      required this.courseNameEnglish});
  Map<String, dynamic> toMap() {
    return {
      'schoolYear': schoolYear,
      'semester': semester,
      'courseCode': courseCode,
      'courseName': courseName,
      'courseNature': courseNature,
      'courseOwnership': courseOwnership,
      'credit': credit,
      'gradePoint': gradePoint,
      'score': score,
      'minorMark': minorMark,
      'makeUpScore': makeUpScore,
      'retakeScore': retakeScore,
      'collegeName': collegeName,
      'remake': remake,
      'retakeMark': retakeMark,
      'courseNameEnglish': courseNameEnglish,
    };
  }

  String toJsonStr() => JsonEncoder().convert(toMap());

  static ScoreRow fromMap(Map<String, dynamic> map) {
    return ScoreRow(
      schoolYear: map['schoolYear'],
      semester: map['semester'],
      courseCode: map['courseCode'],
      courseName: map['courseName'],
      courseNature: map['courseNature'],
      courseOwnership: map['courseOwnership'],
      credit: map['credit'],
      gradePoint: map['gradePoint'],
      score: map['score'],
      minorMark: map['minorMark'],
      makeUpScore: map['makeUpScore'],
      retakeScore: map['retakeScore'],
      collegeName: map['collegeName'],
      remake: map['remake'],
      retakeMark: map['retakeMark'],
      courseNameEnglish: map['courseNameEnglish'],
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ScoreRow &&
          runtimeType == other.runtimeType &&
          schoolYear == other.schoolYear &&
          semester == other.semester &&
          courseCode == other.courseCode &&
          courseName == other.courseName &&
          courseNature == other.courseNature &&
          courseOwnership == other.courseOwnership &&
          credit == other.credit &&
          gradePoint == other.gradePoint &&
          score == other.score &&
          minorMark == other.minorMark &&
          makeUpScore == other.makeUpScore &&
          retakeScore == other.retakeScore &&
          collegeName == other.collegeName &&
          remake == other.remake &&
          retakeMark == other.retakeMark &&
          courseNameEnglish == other.courseNameEnglish;

  @override
  int get hashCode => Object.hashAll([
        schoolYear,
        semester,
        courseCode,
        courseName,
        courseNature,
        courseOwnership,
        credit,
        gradePoint,
        score,
        minorMark,
        makeUpScore,
        retakeScore,
        collegeName,
        remake,
        retakeMark,
        courseNameEnglish,
      ]);

  @override
  String toString() {
    return toJsonStr();
  }
}
