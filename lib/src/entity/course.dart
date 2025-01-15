import 'dart:convert';

class Course {
  ///选课课号
  final String courseSelectionNumber;

  ///课程代码
  final String courseCode;

  ///课程名称
  final String courseName;

  ///课程性质
  final String courseNature;

  ///是否选课
  final String isSelect;

  ///教师姓名
  final String teacherName;

  ///学分
  final String credit;

  ///周学时
  final String weeklyHours;

  ///上课时间
  final String classTime;

  ///上课地点
  final String classLocation;

  ///教材
  final String textBook;

  Course({
    required this.courseSelectionNumber,
    required this.courseCode,
    required this.courseName,
    required this.courseNature,
    required this.isSelect,
    required this.teacherName,
    required this.credit,
    required this.weeklyHours,
    required this.classTime,
    required this.classLocation,
    required this.textBook,
  });

  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      courseSelectionNumber: json['courseSelectionNumber'] as String,
      courseCode: json['courseCode'] as String,
      courseName: json['courseName'] as String,
      courseNature: json['courseNature'] as String,
      isSelect: json['isSelect'] as String,
      teacherName: json['teacherName'] as String,
      credit: json['credit'] as String,
      weeklyHours: json['weeklyHours'] as String,
      classTime: json['classTime'] as String,
      classLocation: json['classLocation'] as String,
      textBook: json['textBook'] as String,
    );
  }

  String toJsonStr() {
    return jsonEncode(toJson());
  }

  Map<String, dynamic> toJson() {
    return {
      'courseSelectionNumber': courseSelectionNumber,
      'courseCode': courseCode,
      'courseName': courseName,
      'courseNature': courseNature,
      'isSelect': isSelect,
      'teacherName': teacherName,
      'credit': credit,
      'weeklyHours': weeklyHours,
      'classTime': classTime,
      'classLocation': classLocation,
      'textBook': textBook,
    };
  }

  @override
  String toString() {
    return toJson().toString();
  }
}
