import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_call/app/routes/app_pages.dart';
import 'package:video_call/constants/api_constants.dart';

Widget TextBubble(String content, Color colors, Color txtColor,
    double bottomleft, double bottomRight,
    {bool isCustom = false, String? conversationID}) {
  return ConstrainedBox(
    constraints: BoxConstraints(maxWidth: 250),
    child: Container(
      margin: EdgeInsets.only(top: 10),
      padding: EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 5,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(bottomleft),
            bottomRight: Radius.circular(bottomRight),
            topRight: Radius.circular(0.0),
            topLeft: Radius.circular(5.0)),
        color: colors,
      ),
      child: Column(
        children: [
          Text(
            content,
            style: TextStyle(color: txtColor, fontSize: 18),
          ),
          if (isCustom)
            ElevatedButton(
                onPressed: () {
                  Get.toNamed(Routes.VIDEO_CONFERENCE, arguments: {
                    ArgumentConstant.conversationID: conversationID
                  });
                },
                child: Text('Join Room'))
        ],
      ),
    ),
  );
}
