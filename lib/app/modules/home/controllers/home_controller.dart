import 'package:get/get.dart';
import 'package:video_call/constants/api_constants.dart';
import 'package:video_call/constants/sizeConstant.dart';
import 'package:video_call/model/userModel.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
import 'package:zego_uikit_signaling_plugin/zego_uikit_signaling_plugin.dart';
import 'package:zego_zimkit/zego_zimkit.dart';

import '../../../../constants/stringConstant.dart';
import '../../../../main.dart';

class HomeController extends GetxController {
  UserModel? userModel;
  @override
  void onInit() {
    if (!isNullEmptyOrFalse(box.read(PrefStrings.userData))) {
      userModel = UserModel.fromJson(box.read(PrefStrings.userData));
      print(userModel!.toJson());
      initZego();
    }
    super.onInit();
  }

  initZego() {
    if (isNullEmptyOrFalse(ZIMKit().currentUser())) {
      ZIMKit().connectUser(id: userModel!.id!, name: userModel!.name!);
    }
    if (ZegoUIKitPrebuiltCallInvitationService().isInit == false) {
      ZegoUIKitPrebuiltCallInvitationService().init(
        appID: StringConstant.appId,
        appSign: StringConstant.appSign,
        userID: userModel!.id!,
        userName: userModel!.name!,
        plugins: [ZegoUIKitSignalingPlugin()],
      );
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
