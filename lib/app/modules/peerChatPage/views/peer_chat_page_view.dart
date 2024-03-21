import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zego_zim/zego_zim.dart';

import '../controllers/peer_chat_page_controller.dart';
import 'msg_items/msg_bottom_box/msg_bottom_model.dart';
import 'msg_items/msg_bottom_box/msg_normal_bottom_box.dart';
import 'msg_items/msg_list.dart';

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
              "appBarTitleValue",
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
          ),
          body: Column(
            children: [
              Expanded(
                child: GestureDetector(
                    onTap: (() {
                      MsgBottomModel.nonselfOnTapResponse();
                      controller.update();
                    }),
                    child: Container(
                      color: Colors.grey[100],
                      alignment: Alignment.topCenter,
                      child: MsgList(
                        controller.historyMessageWidgetList,
                        loadMoreHistoryMsg: () {
                          controller.queryMoreHistoryMessageWidgetList();
                        },
                      ),
                    )),
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
