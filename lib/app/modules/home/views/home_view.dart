import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:video_call/app/routes/app_pages.dart';
import 'package:video_call/services/FirebaseService.dart';
import 'package:video_call/widget/call_invitation.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';

import '../../../../main.dart';
import '../../../../model/userModel.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetWidget<HomeController> {
  const HomeView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('HomeView'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.logout),
          onPressed: () async {
            getIt<FirebaseService>().logOut();
          },
        ),
      ),
      body: StreamBuilder(
        stream: getIt<FirebaseService>().getUserList(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else {
            List<UserModel> userList = [];
            userList = snapshot.data!.docs.map((e) {
              return UserModel.fromJson(e.data() as Map<String, dynamic>);
            }).toList();
            return ListView.builder(
              itemCount: userList.length,
              itemBuilder: (context, index) {
                UserModel user = userList[index];
                return Row(
                  children: [
                    Column(
                      children: [
                        Text(user.name!),
                        Text(user.email!),
                      ],
                    ),
                    Spacer(),
                    actionButton(isVideo: true, userModel: user),
                    actionButton(isVideo: false, userModel: user),
                  ],
                );
              },
            );
          }
        },
      ),
    );
  }

  ZegoSendCallInvitationButton actionButton(
          {required bool isVideo, required UserModel userModel}) =>
      ZegoSendCallInvitationButton(
        isVideoCall: isVideo,
        resourceID: "zegouikit_call",
        invitees: [
          ZegoUIKitUser(id: userModel.id!, name: userModel.name!),
        ],
        iconSize: Size(50, 50),
        buttonSize: Size(60, 60),
        callID: "${DateTime.now().millisecondsSinceEpoch}",
      );
}
