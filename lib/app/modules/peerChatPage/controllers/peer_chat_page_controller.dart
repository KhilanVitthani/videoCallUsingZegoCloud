import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:video_call/app/modules/home/controllers/home_controller.dart';
import 'package:video_call/app/modules/peerChatPage/views/msg_items/send_items/send_custom_msg.dart';
import 'package:video_call/app/routes/app_pages.dart';
import 'package:video_call/constants/api_constants.dart';
import 'package:video_call/constants/sizeConstant.dart';
import 'package:video_call/main.dart';
import 'package:video_call/model/userModel.dart';
import 'package:zego_zim/zego_zim.dart';

import '../views/msg_items/downloading_progress_model.dart';
import '../views/msg_items/msg_converter.dart';
import '../views/msg_items/receive_items/receive_image_msg_cell.dart';
import '../views/msg_items/receive_items/receive_text_msg_cell.dart';
import '../views/msg_items/receive_items/receive_video_msg_cell.dart';
import '../views/msg_items/receive_items/recive_custome_msg_cell.dart';
import '../views/msg_items/send_items/send_text_msg_cell.dart';
import '../views/msg_items/uploading_progress_model.dart';

class PeerChatPageController extends GetxController with StateMixin {
  String conversationID = '';
  String conversationName = '';
  double sendTextFieldBottomMargin = 40;
  bool emojiShowing = false;
  RxList<ZIMMessage> historyZIMMessageList = <ZIMMessage>[].obs;
  RxList<Widget> historyMessageWidgetList = <Widget>[].obs;
  RxList<ZIMMessage> selectedList = <ZIMMessage>[].obs;
  double progress = 0.0;
  bool queryHistoryMsgComplete = false;
  UserModel userModel = UserModel();
  HomeController homeController = Get.find<HomeController>();
  ScrollController scrollController = ScrollController();
  bool isInvokeQueryMethod = false;
  @override
  void onInit() {
    if (Get.arguments != null) {
      conversationID = Get.arguments[ArgumentConstant.conversationID];
      conversationName = Get.arguments[ArgumentConstant.conversationName];
    }
    if (!isNullEmptyOrFalse(box.read(PrefStrings.userData))) {
      userModel = UserModel.fromJson(box.read(PrefStrings.userData));
      // print(userModel!.toJson());
    }
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      clearUnReadMessage();
      registerZIMEvent();
      if (historyZIMMessageList.isEmpty) {
        queryMoreHistoryMessageWidgetList();
      }
    });
    super.onInit();
  }

  clearUnReadMessage() {
    ZIM.getInstance()!.clearConversationUnreadMessageCount(
        conversationID, ZIMConversationType.peer);
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    unregisterZIMEvent();
    homeController.update();
    super.onClose();
  }

  String get appBarTitleValue {
    if (conversationName != '') {
      return conversationName;
    } else {
      return conversationID;
    }
  }

  registerZIMEvent() {
    ZIMEventHandler.onMessageSentStatusChanged =
        (zim, messageSentStatusChangedInfoList) {
      for (var element in messageSentStatusChangedInfoList) {
        print(
            "sentStatus:${element.status},message:${(element.message as ZIMTextMessage).message}");
      }
    };
    ZIMEventHandler.onReceivePeerMessage = (zim, messageList, fromUserID) {
      if (fromUserID != conversationID) {
        return;
      }
      clearUnReadMessage();
      historyZIMMessageList.addAll(messageList);
      for (ZIMMessage message in messageList) {
        switch (message.type) {
          case ZIMMessageType.text:
            ReceiveTextMsgCell cell =
                ReceiveTextMsgCell(message: (message as ZIMTextMessage));
            historyMessageWidgetList
                .add(chatWidget(child: cell, message: message));
            break;
          case ZIMMessageType.image:
            if ((message as ZIMImageMessage).fileLocalPath == "") {
              DownloadingProgressModel downloadingProgressModel =
                  DownloadingProgressModel();

              ReceiveImageMsgCell resultCell;
              ZIM
                  .getInstance()!
                  .downloadMediaFile(message, ZIMMediaFileType.originalFile,
                      (message, currentFileSize, totalFileSize) {})
                  .then((value) => {
                        resultCell = ReceiveImageMsgCell(
                            message: (value.message as ZIMImageMessage),
                            downloadingProgress: null,
                            downloadingProgressModel: downloadingProgressModel),
                        historyMessageWidgetList.add(resultCell),
                        update()
                      });
            } else {
              ReceiveImageMsgCell resultCell = ReceiveImageMsgCell(
                  message: message,
                  downloadingProgress: null,
                  downloadingProgressModel: null);
              historyMessageWidgetList.add(resultCell);
            }

            break;
          case ZIMMessageType.video:
            if ((message as ZIMVideoMessage).fileLocalPath == "") {
              ReceiveVideoMsgCell resultCell;
              ZIM
                  .getInstance()!
                  .downloadMediaFile(message, ZIMMediaFileType.originalFile,
                      (message, currentFileSize, totalFileSize) {})
                  .then((value) => {
                        resultCell = ReceiveVideoMsgCell(
                            message: value.message as ZIMVideoMessage,
                            downloadingProgressModel: null),
                        historyMessageWidgetList.add(resultCell),
                        update()
                      });
            } else {
              ReceiveVideoMsgCell resultCell = ReceiveVideoMsgCell(
                  message: message, downloadingProgressModel: null);
              historyMessageWidgetList.add(resultCell);
              update();
            }
            break;
          case ZIMMessageType.custom:
            ReceiveCustomMsgCell cell =
                ReceiveCustomMsgCell(message: (message as ZIMCustomMessage));
            historyMessageWidgetList.add(cell);
            break;
          default:
        }
      }

      update();
    };

    ZIMEventHandler.onMessageSentStatusChanged = (zim, infos) {
      //window.console.warn(infos);
    };

    ZIMEventHandler.onMessageDeleted = (zim, deletedInfo) {};

    ZIMEventHandler.onUserInfoUpdated = (zim, info) {};
  }

  queryMoreHistoryMessageWidgetList() async {
    if (queryHistoryMsgComplete) {
      return;
    }

    ZIMMessageQueryConfig queryConfig = ZIMMessageQueryConfig();
    queryConfig.count = 20;
    queryConfig.reverse = true;
    try {
      queryConfig.nextMessage = historyZIMMessageList.first;
    } catch (onerror) {
      queryConfig.nextMessage = null;
    }
    try {
      ZIMMessageQueriedResult result = await ZIM
          .getInstance()!
          .queryHistoryMessage(
              conversationID, ZIMConversationType.peer, queryConfig);
      if (result.messageList.length < 20) {
        queryHistoryMsgComplete = true;
      }
      List<Widget> oldMessageWidgetList = MsgConverter().cnvMessageToWidget(
        result.messageList,
      );
      result.messageList.addAll(historyZIMMessageList);
      historyZIMMessageList.value = result.messageList;

      oldMessageWidgetList.addAll(historyMessageWidgetList);
      historyMessageWidgetList.value = oldMessageWidgetList;

      update();
    } on PlatformException catch (onError) {
      //log(onError.code);
    }
  }

  unregisterZIMEvent() {
    ZIMEventHandler.onReceivePeerMessage = null;
    ZIMEventHandler.onMessageSentStatusChanged = null;
  }

  sendTextMessage(String message) async {
    ZIMTextMessage textMessage = ZIMTextMessage(message: message);
    textMessage.senderUserID = userModel.id!;
    ZIMMessageSendConfig sendConfig = ZIMMessageSendConfig();
    historyZIMMessageList.add(textMessage);

    SendTextMsgCell cell = SendTextMsgCell(message: textMessage);
    historyMessageWidgetList.add(cell);

    try {
      ZIMPushConfig pushConfig = ZIMPushConfig();
      pushConfig.title = "Offline notification title";
      pushConfig.content = "Offline notification content";
      sendConfig.pushConfig = pushConfig;
      ZIMMessageSendNotification notification =
          ZIMMessageSendNotification(onMessageAttached: (message) {
        log('onMessageAttached');
      });
      ZIMMessageSentResult result = await ZIM.getInstance()!.sendMessage(
          textMessage,
          conversationID,
          ZIMConversationType.peer,
          sendConfig,
          notification);

      int index = historyZIMMessageList
          .lastIndexWhere((element) => element == textMessage);
      historyZIMMessageList[index] = result.message;
      SendTextMsgCell cell =
          SendTextMsgCell(message: (result.message as ZIMTextMessage));

      historyMessageWidgetList[index] = cell;
      update();
    } on PlatformException catch (onError) {
      log('send error,code:' + onError.code + 'message:' + onError.message!);
      int index = historyZIMMessageList
          .lastIndexWhere((element) => element == textMessage);
      historyZIMMessageList[index].sentStatus = ZIMMessageSentStatus.failed;
      SendTextMsgCell cell = SendTextMsgCell(
          message: (historyZIMMessageList[index] as ZIMTextMessage));
      historyMessageWidgetList[index] = cell;
      update();
    }
  }

  sendCustomMessage() async {
    ZIMCustomMessage textMessage =
        ZIMCustomMessage(message: "message", subType: 1);
    textMessage.senderUserID = userModel.id!;
    ZIMMessageSendConfig sendConfig = ZIMMessageSendConfig();
    historyZIMMessageList.add(textMessage);
    SendCustomMsgCell cell = SendCustomMsgCell(message: textMessage);
    historyMessageWidgetList.add(cell);

    try {
      ZIMPushConfig pushConfig = ZIMPushConfig();
      pushConfig.title = "Offline notification title";
      pushConfig.content = "Offline notification content";
      sendConfig.pushConfig = pushConfig;
      ZIMMessageSendNotification notification =
          ZIMMessageSendNotification(onMessageAttached: (message) {
        log('onMessageAttached');
      });
      ZIMMessageSentResult result = await ZIM.getInstance()!.sendMessage(
          textMessage,
          conversationID,
          ZIMConversationType.peer,
          sendConfig,
          notification);

      int index = historyZIMMessageList
          .lastIndexWhere((element) => element == textMessage);
      historyZIMMessageList[index] = result.message;
      SendCustomMsgCell cell =
          SendCustomMsgCell(message: (result.message as ZIMCustomMessage));
      print(conversationID);
      Get.toNamed(Routes.VIDEO_CONFERENCE, arguments: {
        ArgumentConstant.conversationID: result.message.messageID.toString(),
      });
      historyMessageWidgetList[index] = cell;
      update();
    } on PlatformException catch (onError) {
      log('send error,code:' + onError.code + 'message:' + onError.message!);
      int index = historyZIMMessageList
          .lastIndexWhere((element) => element == textMessage);
      historyZIMMessageList[index].sentStatus = ZIMMessageSentStatus.failed;
      SendTextMsgCell cell = SendTextMsgCell(
          message: (historyZIMMessageList[index] as ZIMTextMessage));
      historyMessageWidgetList[index] = cell;
      update();
    }
  }

  sendMediaMessage(String? path, ZIMMessageType messageType) async {
    if (path == null) return;
    ZIMMediaMessage mediaMessage =
        MsgConverter.mediaMessageFactory(path, messageType);
    mediaMessage.senderUserID = userModel.id!;
    UploadingprogressModel uploadingprogressModel = UploadingprogressModel();
    Widget sendMsgCell = MsgConverter.sendMediaMessageCellFactory(
        mediaMessage, uploadingprogressModel);

    historyZIMMessageList.add(mediaMessage);
    historyMessageWidgetList.add(sendMsgCell);
    update();
    try {
      log(mediaMessage.fileLocalPath);
      ZIMMediaMessageSendNotification notification =
          ZIMMediaMessageSendNotification(
        onMediaUploadingProgress: (message, currentFileSize, totalFileSize) {
          uploadingprogressModel.uploadingprogress!(
              message, currentFileSize, totalFileSize);
        },
      );
      ZIMMessageSentResult result = await ZIM.getInstance()!.sendMediaMessage(
          mediaMessage,
          conversationID,
          ZIMConversationType.peer,
          ZIMMessageSendConfig(),
          notification);
      int index = historyZIMMessageList
          .lastIndexWhere((element) => element == mediaMessage);
      Widget resultCell = MsgConverter.sendMediaMessageCellFactory(
          result.message as ZIMMediaMessage, null);

      historyMessageWidgetList[index] = resultCell;
      update();
    } on PlatformException catch (onError) {
      int index = historyZIMMessageList
          .lastIndexWhere((element) => element == mediaMessage);
      historyZIMMessageList[index].sentStatus = ZIMMessageSentStatus.failed;
      Widget failedCell = MsgConverter.sendMediaMessageCellFactory(
          historyZIMMessageList[index] as ZIMMediaMessage, null);

      historyMessageWidgetList[index] = failedCell;
      update();
    }
  }

  Widget chatWidget({required Widget child, required ZIMMessage message}) {
    return InkWell(
      onTap: () {},
      child: child,
    );
  }

  void onLongPress({required ZIMMessage message}) {
    if (selectedList.contains(message)) {
      selectedList.remove(message);
    } else {
      selectedList.add(message);
    }
    print(selectedList.length);
    selectedList.refresh();
    update();
  }

  void deleteSelectedMessage() {
    ZIMMessageDeleteConfig config = ZIMMessageDeleteConfig();
    config.isAlsoDeleteServerMessage = false;
    ZIM
        .getInstance()!
        .deleteMessages(
            selectedList, conversationID, ZIMConversationType.peer, config)
        .then((value) {
      historyZIMMessageList
          .removeWhere((element) => selectedList.contains(element));
      // oldMessageWidgetList.addAll(historyMessageWidgetList);
      List<Widget> oldMessageWidgetList = MsgConverter().cnvMessageToWidget(
        historyZIMMessageList,
      );
      historyMessageWidgetList.value = oldMessageWidgetList;
      selectedList.clear();
      update();
    });
  }
}
