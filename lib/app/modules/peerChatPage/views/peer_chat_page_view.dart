import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_call/app/modules/peerChatPage/views/msg_items/receive_items/receive_image_msg_cell.dart';
import 'package:zego_zim/zego_zim.dart';

import '../controllers/peer_chat_page_controller.dart';
import 'msg_items/msg_bottom_box/msg_bottom_model.dart';
import 'msg_items/msg_bottom_box/msg_normal_bottom_box.dart';
import 'msg_items/receive_items/receive_video_msg_cell.dart';
import 'msg_items/receive_items/recive_custome_msg_cell.dart';

class PeerChatPageView extends GetView<PeerChatPageController> {
  const PeerChatPageView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PeerChatPageController>(
      assignId: true,
      init: PeerChatPageController(),
      builder: (controller) {
        return Scaffold(
          appBar: AppBar(
            title: Text(
              controller.conversationName,
              style: const TextStyle(color: Colors.black),
            ),
            backgroundColor: Colors.white70,
            shadowColor: Colors.white,
            leading: Builder(
              builder: (context) {
                return IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.arrow_back),
                  color: Colors.black,
                );
              },
            ),
            actions: [
              if (controller.selectedList.isEmpty)
                IconButton(
                  onPressed: () {
                    controller.sendCustomMessage();
                  },
                  icon: const Icon(Icons.dashboard_customize),
                  color: Colors.black,
                )
              else
                IconButton(
                  onPressed: () {
                    controller.deleteSelectedMessage();
                  },
                  icon: const Icon(Icons.delete),
                  color: Colors.black,
                ),
            ],
          ),
          body: Column(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: (() {
                    MsgBottomModel.nonselfOnTapResponse();
                    controller.update();
                  }),
                  child: Scrollbar(
                    controller: controller.scrollController,
                    child: NotificationListener(
                      onNotification: (ScrollNotification notification) {
                        double progressMedian = notification.metrics.pixels /
                            notification.metrics.maxScrollExtent;
                        int progress = (progressMedian * 100).toInt();

                        if (progress >= 90) {
                          controller.queryMoreHistoryMessageWidgetList();
                          // isInvokeQueryMethod = true;
                        }
                        return false;
                      },
                      child: SingleChildScrollView(
                        controller: controller.scrollController,
                        reverse: true,
                        child: Column(
                          children: List.generate(
                            controller.historyZIMMessageList.length,
                            (index) {
                              ZIMMessage message =
                                  controller.historyZIMMessageList[index];
                              bool isSelf = message.senderUserID ==
                                  controller.userModel.id;
                              return InkWell(
                                onTap: () {
                                  if(controller.selectedList.isNotEmpty){
                                    controller.onLongPress(message: message);
                                  }
                                },
                                onLongPress: () {
                                  controller.onLongPress(message: message);
                                },
                                child: Container(
                                  color:
                                      controller.selectedList.contains(message)
                                          ? Colors.grey[300]
                                          : Colors.transparent,
                                  child: Column(
                                    children: [
                                      if (message is ZIMTextMessage)
                                        Align(
                                          alignment: (isSelf)
                                              ? Alignment.centerRight
                                              : Alignment.centerLeft,
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 10,
                                              vertical: 5,
                                            ),
                                            margin: const EdgeInsets.symmetric(
                                              vertical: 5,
                                              horizontal: 10,
                                            ),
                                            decoration: BoxDecoration(
                                              color: (isSelf)
                                                  ? Colors.blue[100]
                                                  : Colors.grey[300],
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            child: Column(
                                              crossAxisAlignment: (isSelf)
                                                  ? CrossAxisAlignment.end
                                                  : CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  message.message,
                                                ),
                                                Text(
                                                  DateTime.fromMillisecondsSinceEpoch(
                                                          message.timestamp)
                                                      .toString(),
                                                  style: const TextStyle(
                                                    color: Colors.grey,
                                                    fontSize: 12,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      if (message is ZIMCustomMessage)
                                        Align(
                                          alignment: (isSelf)
                                              ? Alignment.centerRight
                                              : Alignment.centerLeft,
                                          child: ReceiveCustomMsgCell(
                                              message: message),
                                        ),
                                      if (message is ZIMImageMessage)
                                        Align(
                                          alignment: (isSelf)
                                              ? Alignment.centerRight
                                              : Alignment.centerLeft,
                                          child: ReceiveImageMsgCell(
                                              message: message,
                                              downloadingProgress: null,
                                              downloadingProgressModel: null),
                                        ),
                                      if (message is ZIMVideoMessage)
                                        Align(
                                          alignment: (isSelf)
                                              ? Alignment.centerRight
                                              : Alignment.centerLeft,
                                          child: ReceiveVideoMsgCell(
                                              message: message,
                                              downloadingProgressModel: null),
                                        ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                          //children: [],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              MsgNormalBottomBox(
                sendTextFieldonSubmitted: (message) {
                  controller.sendTextMessage(message);
                },
                onCameraIconButtonOnPressed: (path) {
                  controller.sendMediaMessage(path, ZIMMessageType.image);
                },
                onImageIconButtonOnPressed: (path) {
                  controller.sendMediaMessage(path, ZIMMessageType.image);
                },
                onVideoIconButtonOnPressed: (path) {
                  controller.sendMediaMessage(path, ZIMMessageType.video);
                },
              ),
            ],
          ),
          backgroundColor: Colors.grey[100],
          resizeToAvoidBottomInset: true,
        );
      },
    );
  }
}
