import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:badges/badges.dart';
import 'package:flutter/material.dart' hide Badge;
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:zego_zim/zego_zim.dart';

import '../../../../constants/api_constants.dart';
import '../../../../key_center/04_token_plugin/04_token_plugin.dart';
import '../../../routes/app_pages.dart';
import '../controllers/home_controller.dart';
import '../pop_botton_menu/pop_button_menu.dart';

class HomeView extends GetWidget<HomeController> {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Scaffold(
        appBar: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Offstage(
                offstage: !controller.isDisConnected.value,
                child: IconButton(
                    onPressed: () async {
                      try {
                        if (controller.isConnecting.value == true) {
                          return;
                        }
                        String token = await TokenPlugin.makeToken(
                            FirebaseAuth.instance.currentUser!.uid);
                        //await ZIM.getInstance().logout();
                        controller.isConnecting.value = true;
                        controller.isDisConnected.value = false;
                        ZIMLoginConfig config = ZIMLoginConfig();
                        config.userName = controller.userModel?.name ?? '';
                        config.token = token;
                        await ZIM
                            .getInstance()!
                            .login(controller.userModel!.id!, config);
                        controller.isConnecting.value = false;
                        controller.isDisConnected.value = false;
                        log('success');
                      } on PlatformException catch (error) {
                        controller.isConnecting.value = false;
                        controller.isDisConnected.value = true;
                        log(error.code.toString() + error.message!);
                      }
                    },
                    icon: const Icon(
                      Icons.error_outline,
                      color: Colors.red,
                    )),
              ),
              Offstage(
                  offstage: !controller.isConnecting.value,
                  child: Container(
                    width: 20,
                    height: 20,
                    margin: const EdgeInsets.only(right: 10),
                    child: const CircularProgressIndicator(
                      strokeWidth: 2.0,
                      color: Colors.grey,
                    ),
                  )),
              Text(
                "recentAppBarTitle",
                style: const TextStyle(color: Colors.black),
              ),
            ],
          ),
          backgroundColor: Colors.white70,
          shadowColor: Colors.white,
          actions: <Widget>[MenuRightPopButton()],
          /*leading: Builder(builder: (context) {
          return IconButton(
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
            icon: const Icon(Icons.format_list_bulleted_sharp),
            color: Colors.black,
          );
        }),*/
        ),
        body: (controller.hasData.isFalse)
            ? Center()
            : ListView.builder(
                itemBuilder: (context, index) {
                  ZIMConversation conversation =
                      controller.conversationList[index];
                  return GestureDetector(
                    onTap: () {
                      switch (conversation.type) {
                        case ZIMConversationType.peer:
                          conversation.unreadMessageCount = 0;
                          // setState(() {});
                          Get.toNamed(Routes.PEER_CHAT_PAGE, arguments: {
                            ArgumentConstant.conversationID:
                                conversation.conversationID,
                            ArgumentConstant.conversationName:
                                conversation.conversationName,
                          });
                          break;
                        case ZIMConversationType.group:
                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(
                          //     builder: ((context) {
                          //       return GroupChatPage(
                          //         conversationID: widget.conversation.conversationID,
                          //         conversationName: widget.conversation.conversationName,
                          //       );
                          //     }),
                          //   ),
                          // );
                          break;
                        default:
                      }
                    },
                    child: Container(
                      margin: EdgeInsets.only(bottom: 2),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        border: Border(
                            bottom: BorderSide(
                                width: 0.5, color: Color(0xFFd9d9d9))),
                      ),
                      height: 64.0,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            margin:
                                const EdgeInsets.only(left: 13.0, right: 13.0),
                            child: Badge(
                              showBadge: controller.isShowBadge(
                                  conversation: conversation),
                              toAnimate: false,
                              badgeContent: Text(
                                conversation.unreadMessageCount.toString(),
                                style: TextStyle(color: Colors.white),
                              ),
                              child: Container(
                                decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10.0)),
                                    border: Border.all(
                                        width: 1, color: Colors.grey)),
                                child: Icon(
                                  controller.getAvatar(
                                      conversation: conversation),
                                  size: 45,
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  controller.getTitleValue(
                                      conversation: conversation),
                                  style: TextStyle(
                                      fontSize: 16.0, color: Color(0xFF353535)),
                                  maxLines: 1,
                                ),
                                Padding(padding: EdgeInsets.only(top: 8.0)),
                                Text(
                                  controller.getLastMessageValue(
                                      conversation: conversation),
                                  style: TextStyle(
                                      fontSize: 14.0, color: Color(0xFFa9a9a9)),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                )
                              ],
                            ),
                          ),
                          Container(
                              alignment: AlignmentDirectional.topStart,
                              margin:
                                  const EdgeInsets.only(right: 12.0, top: 12.0),
                              child: Column(
                                children: [
                                  Text(
                                    controller.getTime(
                                        conversation: conversation),
                                    style: const TextStyle(
                                        fontSize: 14.0,
                                        color: Color(0xFFa9a9a9)),
                                  ),
                                ],
                              ))
                        ],
                      ),
                    ),
                  );
                  ;
                },
                itemCount: controller.conversationList.length,
              ),
      );
    });
  }

// ZegoSendCallInvitationButton actionButton(
//         {required bool isVideo, required UserModel userModel}) =>
//     ZegoSendCallInvitationButton(
//       isVideoCall: isVideo,
//       resourceID: "zegouikit_call",
//       invitees: [
//         ZegoUIKitUser(id: userModel.id!, name: userModel.name!),
//       ],
//       iconSize: Size(50, 50),
//       buttonSize: Size(60, 60),
//       callID: "${DateTime.now().millisecondsSinceEpoch}",
//     );
}
