import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:video_call/constants/api_constants.dart';
import 'package:video_call/constants/sizeConstant.dart';
import 'package:video_call/model/userModel.dart';
import 'package:zego_zim/zego_zim.dart';

// import 'package:zego_zimkit/zego_zimkit.dart';

import '../../../../constants/error_dia_log.dart';
import '../../../../main.dart';
import '../items/chatCell.dart';

class HomeController extends GetxController {
  UserModel? userModel;
  RxInt totalUnreadMsg = 0.obs;
  RxBool isConnecting = false.obs;
  RxBool isDisConnected = false.obs;
  RxList<ConverListCell> converWidgetList = <ConverListCell>[].obs;
  RxList<ZIMConversation> _converList = <ZIMConversation>[].obs;
  ScrollController scrollController = ScrollController();
  RxBool hasData = false.obs;
  @override
  void onInit() {
    if (!isNullEmptyOrFalse(box.read(PrefStrings.userData))) {
      userModel = UserModel.fromJson(box.read(PrefStrings.userData));
      print(userModel!.toJson());
    }
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await initZego(context: Get.context!);
    });
    super.onInit();
  }

  initZego({required BuildContext context}) async {
    // if (ZegoUIKitPrebuiltCallInvitationService().isInit == false) {
    //   ZegoUIKitPrebuiltCallInvitationService().init(
    //     appID: StringConstant.appId,
    //     appSign: StringConstant.appSign,
    //     userID: userModel!.id!,
    //     userName: userModel!.name!,
    //     plugins: [ZegoUIKitSignalingPlugin()],
    //   );
    // }

    try {
      showLoadingDialog(context: context);
      ZIMLoginConfig config = ZIMLoginConfig();
      config.token = "";
      config.userName = userModel!.name! ?? '';
      await ZIM.getInstance()!.login(userModel!.id!, config);
      // Navigator.of(context).pop;
      Get.back();
      log('LogInsuccess');
    } on PlatformException catch (onError) {
      // Navigator.of(context).pop();
      Get.back();
      bool? delete = await ErrorDiaLog.showFailedDialog(
          context, onError.code, onError.message!);
    }
    registerZIMEvent();
    if (converWidgetList.isEmpty) getMoreConverWidgetList();
    registerConverUpdate();
  }

  getMoreConverWidgetList() async {
    ZIMConversationQueryConfig queryConfig = ZIMConversationQueryConfig();
    queryConfig.count = 20;
    try {
      queryConfig.nextConversation = _converList.last;
    } on StateError {
      queryConfig.nextConversation = null;
    }
    try {
      ZIMConversationListQueriedResult result =
          await ZIM.getInstance()!.queryConversationList(queryConfig);
      _converList.addAll(result.conversationList);
      List<ConverListCell> newConverWidgetList = [];
      for (ZIMConversation newConversation in result.conversationList) {
        ConverListCell newConverListCell = ConverListCell(newConversation);
        newConverWidgetList.add(newConverListCell);
      }
      converWidgetList.addAll(newConverWidgetList);
      update();
    } on PlatformException catch (onError) {
      return null;
    }
  }

  registerConverUpdate() {
    ZIMEventHandler.onConversationChanged = (zim, conversationChangeInfoList) {
      for (ZIMConversationChangeInfo changeInfo in conversationChangeInfoList) {
        switch (changeInfo.event) {
          case ZIMConversationEvent.added:
            _converList.insert(0, changeInfo.conversation!);
            ConverListCell newConverListCell =
                ConverListCell(changeInfo.conversation!);
            converWidgetList.insert(0, newConverListCell);
            update();
            break;
          case ZIMConversationEvent.updated:
            ZIMConversation oldConver = _converList.singleWhere((element) =>
                element.conversationID ==
                changeInfo.conversation?.conversationID);
            int oldConverIndex = _converList.indexOf(oldConver);
            _converList[oldConverIndex] = changeInfo.conversation!;
            ConverListCell oldConverListCell = converWidgetList
                .singleWhere((element) => element.conversation == oldConver);
            int oldConverListCellIndex =
                converWidgetList.indexOf(oldConverListCell);
            ConverListCell newConverListCell =
                ConverListCell(changeInfo.conversation!);
            converWidgetList[oldConverListCellIndex] = newConverListCell;
            // converWidgetList.refresh();
            hasData.value = true;
            converWidgetList.map((element) {
              print(element.conversation.unreadMessageCount);
              return element;
            });
            update();
            break;
          case ZIMConversationEvent.disabled:
            ZIMConversation oldConver = _converList.singleWhere((element) =>
                element.conversationID ==
                changeInfo.conversation?.conversationID);
            int oldConverIndex = _converList.indexOf(oldConver);
            _converList.removeAt(oldConverIndex);
            ConverListCell oldConverListCell = converWidgetList
                .singleWhere((element) => element.conversation == oldConver);
            int oldConverListCellIndex =
                converWidgetList.indexOf(oldConverListCell);
            converWidgetList.removeAt(oldConverListCellIndex);
            break;
          default:
        }
        update();
        hasData.value = true;
      }
    };
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  registerZIMEvent() {
    ZIMEventHandler.onConversationTotalUnreadMessageCountUpdated =
        (zim, totalUnreadMessageCount) {
      totalUnreadMsg.value = totalUnreadMessageCount;
    };

    ZIMEventHandler.onConnectionStateChanged =
        (zim, state, event, extendedData) {
      switch (state) {
        case ZIMConnectionState.connected:
          isConnecting.value = false;
          isDisConnected.value = false;
          break;
        case ZIMConnectionState.connecting:
          isConnecting.value = true;
          isDisConnected.value = false;
          break;
        case ZIMConnectionState.disconnected:
          // switch (event) {
          //   case ZIMConnectionEvent.kickedOut:

          //     break;
          //   default:
          // }
          isDisConnected.value = true;
          isConnecting.value = false;
          break;

        case ZIMConnectionState.reconnecting:
          isDisConnected.value = false;
          isConnecting.value = true;
          break;
        default:
      }
    };
  }
}
