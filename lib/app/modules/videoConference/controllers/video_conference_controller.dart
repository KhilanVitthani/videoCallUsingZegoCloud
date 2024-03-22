import 'package:get/get.dart';
import 'package:video_call/model/userModel.dart';

import '../../../../constants/api_constants.dart';
import '../../../../constants/sizeConstant.dart';
import '../../../../main.dart';

class VideoConferenceController extends GetxController {
  String conversationID = '';
  UserModel userModel = UserModel();
  @override
  void onInit() {
    if (!isNullEmptyOrFalse(box.read(PrefStrings.userData))) {
      userModel = UserModel.fromJson(box.read(PrefStrings.userData));
      print(userModel.toJson());
    }
    if (Get.arguments != null) {
      conversationID = Get.arguments[ArgumentConstant.conversationID];
      print("conversationID ===================== $conversationID");
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
