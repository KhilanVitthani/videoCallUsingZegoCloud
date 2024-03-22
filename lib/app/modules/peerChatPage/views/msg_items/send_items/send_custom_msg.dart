import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:zego_zim/zego_zim.dart';

import '../bubble/text_bubble.dart';

class SendCustomMsgCell extends StatefulWidget {
  ZIMCustomMessage message;

  SendCustomMsgCell({required this.message});
  @override
  State<StatefulWidget> createState() => _MyCellState();
}

class _MyCellState extends State<SendCustomMsgCell> {
  get isSending {
    if (widget.message.sentStatus == ZIMMessageSentStatus.sending) {
      return true;
    } else {
      return false;
    }
  }

  get isSentFailed {
    if (widget.message.sentStatus == ZIMMessageSentStatus.failed) {
      return true;
    } else {
      return false;
    }
  }

  var _tapPosition;
  void _storePosition(TapDownDetails details) {
    _tapPosition = details.globalPosition;
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onLongPress: () {
        final RenderObject? overlay =
            Overlay.of(context).context.findRenderObject();

        showMenu(
          items: <PopupMenuEntry>[
            PopupMenuItem(
              onTap: () {},
              child: Row(
                children: <Widget>[
                  Icon(Icons.delete),
                  Text("Delete"),
                ],
              ),
            )
          ],
          context: context,
          position: RelativeRect.fromRect(
              _tapPosition & const Size(40, 40), Offset.zero & Size(50, 50)),
        );
        print('long press');
      },
      onTapDown: _storePosition,
      child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 5,
          ),
          width: double.infinity,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Container(),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Offstage(
                        offstage: !isSending,
                        child: Container(
                          width: 20,
                          height: 20,
                          margin: const EdgeInsets.only(right: 10),
                          child: const CircularProgressIndicator(
                            strokeWidth: 2.0,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                      Offstage(
                        offstage: !isSentFailed,
                        child: Container(
                            width: 20,
                            height: 20,
                            margin: const EdgeInsets.only(right: 10),
                            child: Icon(
                              Icons.error_outline,
                              color: Colors.red,
                            )),
                      ),
                      TextBubble(widget.message.message, Colors.green.shade300,
                          Colors.black, 5, 5,
                          isCustom: true,
                          conversationID: widget.message.messageID.toString()),
                    ],
                  ),
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
            ],
          )),
    );
  }
}
