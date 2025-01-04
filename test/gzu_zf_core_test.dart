import 'package:gzu_zf_core/gzu_zf_core.dart';
import 'package:test/test.dart';

void main() {
  group('简单测试', () {
    test('impl Test', () async {
      var impl = ZfImpl.getImpl("2100170007", "wang.147");
      await impl.login();
      var result = await impl.queryScore();
      expect(result["accountInfo"], isA<AccountInfo>());
      expect(result["scoreRows"], isA<List<ScoreRow>>());
      expect((result["scoreRows"] as List).length, isNonZero);
    });
  });

  group("多例登录测试", () {
    test("登陆1", () async {
      var impl = ZfImpl.getImpl("2100170007", "wang.147");
      var r = await impl.login();
      expect(r, isNotNull);
    });
    test("登陆2", () async {
      var impl = ZfImpl.getImpl("2100170007", "wang.147");
      var r = await impl.login();
      expect(r, isNotNull);
    });
    test("登陆3", () async {
      var impl = ZfImpl.getImpl("2100170007", "wang.147");
      var r = await impl.login();
      expect(r, isNotNull);
    });
  });

  group("多例登录请求测试", () {
    test("请求1", () async {
      var impl = ZfImpl.getImpl("2100170007", "wang.147");
      var r = await impl.login();
      expect(r, isNotNull);
      var result = await impl.queryScore();
      expect(result["accountInfo"], isA<AccountInfo>());
      expect(result["scoreRows"], isA<List<ScoreRow>>());
      expect((result["scoreRows"] as List).length, isNonZero);
    });
    test("请求2", () async {
      var impl = ZfImpl.getImpl("2100170007", "wang.147");
      var r = await impl.login();
      expect(r, isNotNull);
      var result = await impl.queryScore();
      expect(result["accountInfo"], isA<AccountInfo>());
      expect(result["scoreRows"], isA<List<ScoreRow>>());
      expect((result["scoreRows"] as List).length, isNonZero);
    });
    test("请求3", () async {
      var impl = ZfImpl.getImpl("2100170007", "wang.147");
      var r = await impl.login();
      expect(r, isNotNull);
      var result = await impl.queryScore();
      expect(result["accountInfo"], isA<AccountInfo>());
      expect(result["scoreRows"], isA<List<ScoreRow>>());
      expect((result["scoreRows"] as List).length, isNonZero);
    });
  });
  group('单例登陆多请求测试', () {
    test('impl Test', () async {
      var impl = ZfImpl.getImpl("2100170007", "wang.147");
      await impl.login();
      //await impl.login();
      //await impl.login();
      impl.queryScore();
      impl.queryScore();
      impl.queryScore();
      var result = await impl.queryScore();
      expect(result["accountInfo"], isA<AccountInfo>());
      expect(result["scoreRows"], isA<List<ScoreRow>>());
      expect((result["scoreRows"] as List).length, isNonZero);
    });
  });
}
