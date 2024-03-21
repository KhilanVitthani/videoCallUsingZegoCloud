import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:zego_zim/zego_zim.dart';

import '../../../../key_center/04_token_plugin/04_token_plugin.dart';
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
            : Scrollbar(
                controller: controller.scrollController,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  controller: controller.scrollController,
                  child: Center(
                    child: Column(children: controller.converWidgetList),
                  ),
                ),
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
