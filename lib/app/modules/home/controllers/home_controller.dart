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
  RxList<ZIMConversation> conversationList = <ZIMConversation>[].obs;
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
    if (conversationList.isEmpty) getMoreconversationList();
    registerConverUpdate();
  }

  getMoreconversationList() async {
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
      List<ZIMConversation> newconversationList = [];
      for (ZIMConversation newConversation in result.conversationList) {
        ZIMConversation newConverListCell = newConversation;
        newconversationList.add(newConverListCell);
      }
      conversationList.addAll(newconversationList);
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
            conversationList.insert(0, changeInfo.conversation!);
            update();
            break;
          case ZIMConversationEvent.updated:
            ZIMConversation oldConver = _converList.singleWhere((element) =>
                element.conversationID ==
                changeInfo.conversation?.conversationID);
            int oldConverIndex = _converList.indexOf(oldConver);
            _converList[oldConverIndex] = changeInfo.conversation!;
            ZIMConversation oldConverListCell =
                conversationList.singleWhere((element) => element == oldConver);
            int oldConverListCellIndex =
                conversationList.indexOf(oldConverListCell);
            conversationList[oldConverListCellIndex] = changeInfo.conversation!;
            conversationList.refresh();
            hasData.value = true;
            update();
            break;
          case ZIMConversationEvent.disabled:
            ZIMConversation oldConver = _converList.singleWhere((element) =>
                element.conversationID ==
                changeInfo.conversation?.conversationID);
            int oldConverIndex = _converList.indexOf(oldConver);
            _converList.removeAt(oldConverIndex);
            ZIMConversation oldConverListCell =
                conversationList.singleWhere((element) => element == oldConver);
            int oldConverListCellIndex =
                conversationList.indexOf(oldConverListCell);
            conversationList.removeAt(oldConverListCellIndex);
            break;
          default:
        }
        print("Update");
        conversationList.refresh();
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

  String getTitleValue({required ZIMConversation conversation}) {
    String targetTitle;
    if (conversation.conversationName != '') {
      targetTitle = conversation.conversationName;
    } else {
      targetTitle = conversation.conversationID;
    }
    return targetTitle;
  }

  bool isShowBadge({required ZIMConversation conversation}) {
    if (conversation.unreadMessageCount == 0) {
      return false;
    } else {
      return true;
    }
  }

  String getTime({required ZIMConversation conversation}) {
    if (conversation.lastMessage == null) {
      return '';
    }
    int timeStamp = (conversation.lastMessage!.timestamp / 1000).round();

    int time = (DateTime.now().millisecondsSinceEpoch / 1000).round();

    int _distance = time - timeStamp;
    if (_distance <= 60) {
      //return 'now';
      return '${CustomStamp_str(Timestamp: timeStamp, Date: 'MM/DD hh:mm', toInt: false)}';
    } else if (_distance <= 3600) {
      // return '${(_distance / 60).floor()} mintues ago';
      return '${CustomStamp_str(Timestamp: timeStamp, Date: 'MM/DD hh:mm', toInt: false)}';
    } else if (_distance <= 43200) {
      // return '${(_distance / 60 / 60).floor()} hours ago';
      return '${CustomStamp_str(Timestamp: timeStamp, Date: 'MM/DD hh:mm', toInt: false)}';
    } else if (DateTime.fromMillisecondsSinceEpoch(time * 1000).year ==
        DateTime.fromMillisecondsSinceEpoch(timeStamp * 1000).year) {
      return '${CustomStamp_str(Timestamp: timeStamp, Date: 'MM/DD hh:mm', toInt: false)}';
    } else {
      return '${CustomStamp_str(Timestamp: timeStamp, Date: 'YY/MM/DD hh:mm', toInt: false)}';
    }
  }

  // 时间戳转时间
  String CustomStamp_str({
    int? Timestamp,
    String? Date,
    bool toInt = true,
  }) {
    Timestamp ??= (new DateTime.now().millisecondsSinceEpoch / 1000).round();
    String Time_str =
        (DateTime.fromMillisecondsSinceEpoch(Timestamp * 1000)).toString();

    dynamic Date_arr = Time_str.split(' ')[0];
    dynamic Time_arr = Time_str.split(' ')[1];

    String YY = Date_arr.split('-')[0];
    String MM = Date_arr.split('-')[1];
    String DD = Date_arr.split('-')[2];

    String hh = Time_arr.split(':')[0];
    String mm = Time_arr.split(':')[1];
    String ss = Time_arr.split(':')[2];

    ss = ss.split('.')[0];

    if (toInt) {
      MM = (int.parse(MM)).toString();
      DD = (int.parse(DD)).toString();
      hh = (int.parse(hh)).toString();
      mm = (int.parse(mm)).toString();
    }

    if (Date == null) {
      return Time_str;
    }

    Date = Date.replaceAll('YY', YY)
        .replaceAll('MM', MM)
        .replaceAll('DD', DD)
        .replaceAll('hh', hh)
        .replaceAll('mm', mm)
        .replaceAll('ss', ss);

    return Date;
  }

  IconData getAvatar({required ZIMConversation conversation}) {
    IconData targetIcon;
    switch (conversation.type) {
      case ZIMConversationType.peer:
        targetIcon = Icons.person;
        break;
      case ZIMConversationType.room:
        targetIcon = Icons.home_sharp;
        break;
      case ZIMConversationType.group:
        targetIcon = Icons.people;
        break;
      default:
        targetIcon = Icons.person;
    }
    return targetIcon;
  }

  String getLastMessageValue({required ZIMConversation conversation}) {
    String targetMessage;
    if (conversation.lastMessage == null) return '';
    switch (conversation.lastMessage!.type) {
      case ZIMMessageType.text:
        targetMessage = (conversation.lastMessage as ZIMTextMessage).message;
        break;
      case ZIMMessageType.command:
        targetMessage = '[cmd]';
        break;
      case ZIMMessageType.barrage:
        targetMessage = (conversation.lastMessage as ZIMBarrageMessage).message;
        break;
      case ZIMMessageType.audio:
        targetMessage = '[audio]';
        break;
      case ZIMMessageType.video:
        targetMessage = '[video]';
        break;
      case ZIMMessageType.file:
        targetMessage = '[file]';
        break;
      case ZIMMessageType.image:
        targetMessage = '[image]';
        break;
      default:
        {
          targetMessage = '[unknown message type]';
        }
    }
    return targetMessage;
  }
}
