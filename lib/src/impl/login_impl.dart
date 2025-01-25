import 'dart:async';
import 'dart:typed_data';
import 'package:gzu_zf_core/src/exception/error.dart';
import 'package:gzu_zf_core/src/exception/exception.dart';
import 'package:gzu_zf_core/src/index.dart';
import 'package:gzu_zf_core/src/tools/html_tool.dart';
import 'package:gzu_zf_core/src/tools/parser.dart';
import 'package:gzu_zf_core/src/tools/train_img.dart';
import 'package:dio/dio.dart';
import 'package:image/image.dart' as img;
import 'package:fast_gbk/fast_gbk.dart';

///登录实现
class LoginImpl {
  final ZfImpl zfImpl;
  LoginImpl({required this.zfImpl});

  ///throws [SchoolNetCannotAccess]
  ///throws [PasswordOrUsernameWrong]
  ///throws [NetNarrow]
  ///throws [CannotParse]
  Future<Map<String, Map<String, String>>> login(
      String username, String password) async {
    try {
      var viewState = await questMain();
      var checkcode = await questCheckCode();
      return await doLogin(username, password, checkcode, viewState);
    } on CheckCodeRecoginedError {
      Future.delayed(Duration(seconds: 4));
      return await login(username, password);
    }
  }

  //step1
  //请求主页
  Future<String> questMain() async {
    var response = await zfImpl.client.get('https://jw.gzu.edu.cn/',
        options: Options(
          responseType: ResponseType.bytes,
        ));
    var viewState =
        Parser.viewStateParse(response.data, "#form1 > input[type=hidden]");
    return viewState;
  }

  //step2
  //请求验证码
  Future<String> questCheckCode() async {
    var trainImg = img.decodeImage(getImageUnit8());
    if (trainImg == null) throw CannotParse();
    var checkcodeImage =
        await downloadImage("https://jw.gzu.edu.cn/CheckCode.aspx");
    var image = await denose(checkcodeImage);
    var images = splitImage(image);
    return images.map((i) => recognize(i, trainImg)).join("");
  }

  //step2.1
  //下载验证码图片
  Future<Uint8List> downloadImage(String url) async {
    var response = await zfImpl.client.get(url,
        options: Options(
            responseType: ResponseType.bytes,
            validateStatus: (code) => code == 200));
    return Uint8List.fromList(response.data);
  }

  //step2.2
  //验证码去噪
  Future<img.Image> denose(Uint8List imageData) async {
    img.Image? image = img.decodeImage(imageData);
    if (image == null) throw CannotParse();
    img.Image processedImage =
        img.Image(width: image.width, height: image.height);
    final targetColor = img.ColorRgba8(0, 0, 153, 255); // 0xff000099
    final blackColor = img.ColorRgba8(0, 0, 0, 255); // 0xff000000
    final whiteColor = img.ColorRgba8(255, 255, 255, 255); // 0xffffffff
    for (int y = 0; y < image.height; y++) {
      for (int x = 0; x < image.width; x++) {
        var pixelColor = image.getPixel(x, y);
        if (pixelColor.r == targetColor.r &&
            pixelColor.g == targetColor.g &&
            pixelColor.b == targetColor.b) {
          processedImage.setPixel(x, y, blackColor);
        } else {
          processedImage.setPixel(x, y, whiteColor);
        }
      }
    }
    return processedImage;
  }

  //step2.3
  //切割图片
  List<img.Image> splitImage(img.Image sourceImage) {
    List<img.Image> splitedImages = [];
    splitedImages
        .add(img.copyCrop(sourceImage, x: 4, y: 0, width: 13, height: 22));
    splitedImages
        .add(img.copyCrop(sourceImage, x: 16, y: 0, width: 13, height: 22));
    splitedImages
        .add(img.copyCrop(sourceImage, x: 28, y: 0, width: 13, height: 22));
    splitedImages
        .add(img.copyCrop(sourceImage, x: 40, y: 0, width: 13, height: 22));
    return splitedImages;
  }

  //step2.4
  //识别单个字符
  String recognize(img.Image image, img.Image trainImg) {
    var targetChar = [
      '0',
      '1',
      '2',
      '3',
      '4',
      '5',
      '6',
      '7',
      '8',
      /* '9',*/
      'a',
      'b',
      'c',
      'd',
      'e',
      'f',
      'g',
      'h',
      'i',
      'j',
      'k',
      'l',
      'm',
      'n',
      /*'o', */ 'p',
      'q',
      'r',
      's',
      't',
      'u',
      'v',
      'w',
      'x',
      'y' /*, 'z'*/
    ];
    String result = ' ';
    int width = image.width;
    int height = image.height;
    int min = width * height;
    for (int i = 0; i < 32; ++i) {
      for (int j = 0; j < targetChar.length; ++j) {
        int startX = 13 * i;
        int startY = (22 + 1) * j;
        if (trainImg.getPixel(startX, startY + 22).r != 0) {
          continue;
        }
        int count = 0;
        for (int x = 0; x < 13; ++x) {
          for (int y = 0; y < 22; ++y) {
            count += (image.getPixel(x, y).r !=
                    trainImg.getPixel(startX + x, startY + y).r
                ? 1
                : 0);
            if (count >= min) {
              break;
            }
          }
        }
        if (count < min) {
          min = count;
          result = targetChar[j];
        }
      }
    }
    return result;
  }

  //step3
  //登录动作

  Future<Map<String, Map<String, String>>> doLogin(String username,
      String password, String checkcode, String viewState) async {
    var formData = {
      '__VIEWSTATE': viewState,
      'txtUserName': username,
      'TextBox2': password,
      'txtSecretCode': checkcode,
      'RadioButtonList1': '%D1%A7%C9%FA',
      'Button1': '',
      'lbLanguage': '',
      'hidPdrs': '',
      'hidsc': '',
    };

    var response =
        await zfImpl.client.post('https://jw.gzu.edu.cn/default2.aspx',
            data: FormData.fromMap(formData),
            options: Options(
                responseType: ResponseType.bytes,
                followRedirects: false,
                validateStatus: (code) {
                  if (code == null) return false;
                  return code < 500;
                }));
    if (response.statusCode != 302) {
      if (response.statusCode == 200) {
        var resultText = Parser.resultParse(response.data, "#form1 > script");
        if (resultText == null) {
          throw LoginFailed();
        }
        if (resultText.contains("验证码")) {
          //验证码识别错误
          throw CheckCodeRecoginedError();
        }
        throw PasswordOrUsernameWrong();
      }
    }

    ///主页
    var loginResponse = await zfImpl.client.get(
        "https://jw.gzu.edu.cn/xs_main.aspx?xh=$username",
        options: Options(responseType: ResponseType.bytes));

    var document = gbk.decode(loginResponse.data);
    try {
      return navFlatten(document);
    } catch (e) {
      throw LoginFailed();
    }
  }
}
