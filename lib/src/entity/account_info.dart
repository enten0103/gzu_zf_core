import 'dart:convert';

class AccountInfo {
  ///学号
  final String studentNumber;

  ///姓名
  final String name;

  ///学院
  final String college;

  ///专业
  final String major;

  ///行政班
  final String administrativeClass;

  AccountInfo(
      {required this.studentNumber,
      required this.name,
      required this.college,
      required this.major,
      required this.administrativeClass});

  String toJsonString() {
    return jsonEncode({
      'studentNumber': studentNumber,
      'name': name,
      'college': college,
      'major': major,
      'administrativeClass': administrativeClass,
    });
  }

  factory AccountInfo.fromJson(String jsonString) {
    Map<String, dynamic> json = jsonDecode(jsonString);
    return AccountInfo(
      studentNumber: json['studentNumber'],
      name: json['name'],
      college: json['college'],
      major: json['major'],
      administrativeClass: json['administrativeClass'],
    );
  }

  factory AccountInfo.fromMap(Map<String, dynamic> map) {
    return AccountInfo(
      studentNumber: map['studentNumber'],
      name: map['name'],
      college: map['college'],
      major: map['major'],
      administrativeClass: map['administrativeClass'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'studentNumber': studentNumber,
      'name': name,
      'college': college,
      'major': major,
      'administrativeClass': administrativeClass,
    };
  }

  @override
  String toString() {
    return toJsonString();
  }
}
