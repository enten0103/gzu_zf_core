import 'package:gzu_zf_core/gzu_zf_core.dart';
import 'package:test/test.dart';

void main() async {
  var impl = ZfImpl.getImpl("2100170007", "wang.147");

  await impl.login();

  group('成绩查询测试', () {
    test('基础测试', () async {
      var result = await impl.queryScore();
      expect(result["accountInfo"], isA<Account>());
      expect(result["scoreRows"], isA<List<Score>>());
      expect((result["scoreRows"] as List).length, isNonZero);
    });
  });

  group("选课查询测试", () {
    test("基础测试", () async {
      await impl.queryAllCourse();
    });
  });
}
