import 'package:flutter/material.dart';
import 'package:zego_zim/zego_zim.dart';

import '../bubble/text_bubble.dart';

class ReceiveTextMsgCell extends StatefulWidget {
  ZIMTextMessage message;

  ReceiveTextMsgCell({required this.message});

  @override
  State<StatefulWidget> createState() => _MyCellState();
}

class _MyCellState extends State<ReceiveTextMsgCell> {
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 5,
        ),
        width: double.infinity,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icon(
            //   Icons.person,
            //   size: 50,
            // ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  TextBubble(
                      widget.message.message, Colors.white, Colors.black, 5, 5),
                  Text(
                      DateTime.fromMillisecondsSinceEpoch(
                              widget.message.timestamp)
                          .toString(),
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 12,
                      )),
                ],
              ),
            ),
          ],
        ));
  }
}
