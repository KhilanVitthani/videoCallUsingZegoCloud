import 'package:flutter/services.dart';
import 'package:video_call/constants/stringConstant.dart';

class TokenPlugin {
  static const MethodChannel _channel = MethodChannel('token_plugin');

  static Future<String> makeToken(String userID) async {
    Map resultMap = await _channel.invokeMethod('makeToken', {
      "appID": StringConstant.appId,
      "userID": userID,
      "secret": '',
    });
    return resultMap['token'];
  }
}
