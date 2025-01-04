import 'package:gzu_zf_core/src/index.dart';

void main(List<String> args) {
  var impl = ZfImpl.getImpl("2100170007", "wang.147");
  impl.login().then((onValue) {
    print(onValue);
  });
}
