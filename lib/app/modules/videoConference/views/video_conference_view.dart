import 'dart:math';

import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:video_call/constants/stringConstant.dart';
import 'package:zego_uikit_prebuilt_video_conference/zego_uikit_prebuilt_video_conference.dart';

import '../controllers/video_conference_controller.dart';

class VideoConferenceView extends GetWidget<VideoConferenceController> {
  const VideoConferenceView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('VideoConferenceView'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            ZegoUIKitPrebuiltVideoConference;
            Get.back();
          },
        ),
      ),
      body: ZegoUIKitPrebuiltVideoConference(
        appID: StringConstant
            .appId, // Fill in the appID that you get from ZEGOCLOUD Admin Console.
        appSign: StringConstant
            .appSign, // Fill in the appSign that you get from ZEGOCLOUD Admin Console.
        userID: controller.userModel.id.toString(),
        userName: controller.userModel.name ?? "",
        conferenceID: controller.conversationID,
        config: ZegoUIKitPrebuiltVideoConferenceConfig(
          avatarBuilder: (context, size, user, extraInfo) {
            return Container(
              width: size.width,
              height: size.height,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color:
                    Colors.primaries[Random().nextInt(Colors.primaries.length)],
              ),
              alignment: Alignment.center,
              child: Text(
                user?.name.toUpperCase() ?? "",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: size.height * 0.5,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
