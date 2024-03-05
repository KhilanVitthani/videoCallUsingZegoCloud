import 'package:get/get.dart';
import 'package:video_call/constants/api_constants.dart';
import 'package:video_call/constants/sizeConstant.dart';
import 'package:video_call/model/userModel.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';

import '../../../../main.dart';

class HomeController extends GetxController {
  UserModel? userModel;
  @override
  void onInit() {
    if (!isNullEmptyOrFalse(box.read(PrefStrings.userData))) {
      userModel = UserModel.fromJson(box.read(PrefStrings.userData));
      print(userModel!.toJson());
    }
    super.onInit();
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
