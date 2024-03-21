import 'dart:async';
import 'dart:developer';

import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:video_call/app/routes/app_pages.dart';
import 'package:video_call/constants/api_constants.dart';
import 'package:video_call/constants/sizeConstant.dart';
import 'package:video_call/constants/stringConstant.dart';
import 'package:video_call/model/userModel.dart';
import 'package:zego_zim/zego_zim.dart';

import '../../../../key_center/04_token_plugin/04_token_plugin.dart';
import '../../../../main.dart';

class SplashController extends GetxController {
  Timer? _countTimer;
  int _countDown = 1;
  bool isResetZIM = false;
  @override
  void onInit() {
    _startCountDown();
    super.onInit();
  }

  void _startCountDown() async {
    ZIMAppConfig appConfig = ZIMAppConfig();
    appConfig.appID = StringConstant.appId;
    appConfig.appSign = StringConstant.appSign;
    ZIM zim = ZIM.create(appConfig)!;

    log('create');
    UserModel userModel = UserModel();
    if (!isNullEmptyOrFalse(box.read(PrefStrings.userData))) {
      userModel = UserModel.fromJson(box.read(PrefStrings.userData));
    }
    final String? userID = userModel.id;
    final String? userName = userModel.name;
    _countTimer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) async {
        if (_countDown < 1) {
          _countTimer?.cancel();
          _countTimer = null;

          if (userID != null && userID != '' && isResetZIM == false) {
            ZIM.getInstance()!.destroy();
            log('destory');
            ZIM.create(appConfig);
            log('create');
            isResetZIM = true;
          }
          Get.offAndToNamed(Routes.SING_IN);
        } else {
          _countDown -= 1;
        }
      },
    );
    if (userID != null && userID != '') {
      String token = await TokenPlugin.makeToken(userID);
      ZIMUserInfo userInfo = ZIMUserInfo();
      ZIMLoginConfig config = ZIMLoginConfig();
      userInfo.userID = userID;
      if (userName != null) {
        config.userName = userName;
        userInfo.userName = userName;
      }
      log('login');
      try {
        String token = await TokenPlugin.makeToken(userInfo.userID);
        config.token = token;

        await ZIM.getInstance()!.login(userID, config);
        log('success');
        _countTimer?.cancel();
        _countTimer = null;
        Get.offAndToNamed(Routes.HOME);
      } on PlatformException catch (onError) {
        _countTimer?.cancel();
        _countTimer = null;
        Get.offAndToNamed(Routes.SING_IN);
      }
    }
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }
}
