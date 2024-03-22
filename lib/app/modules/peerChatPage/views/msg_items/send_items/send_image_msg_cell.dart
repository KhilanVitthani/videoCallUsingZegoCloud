import 'package:flutter/material.dart';
import 'package:zego_zim/zego_zim.dart';

// import 'package:zego_zim_example/topics/items/msg_items/uploading_progress_model.dart';

import '../bubble/image_bubble.dart';
import '../uploading_progress_model.dart';

class SendImageMsgCell extends StatefulWidget {
  ZIMImageMessage message;
  double? progress;

  SendImageMsgCell(
      {required this.message, required this.uploadingprogressModel});

  UploadingprogressModel? uploadingprogressModel;

  get isUpLoading {
    if (message.sentStatus == ZIMMessageSentStatus.sending) {
      return true;
    } else {
      return false;
    }
  }

  get isUpLoadFailed {
    if (message.sentStatus == ZIMMessageSentStatus.failed) {
      return true;
    } else {
      return false;
    }
  }

  @override
  State<StatefulWidget> createState() => SendImageMsgCellState();
}

class SendImageMsgCellState extends State<SendImageMsgCell> {
  @override
  void initState() {
    widget.uploadingprogressModel?.uploadingprogress =
        (message, currentFileSize, totalFileSize) {
      setState(() {
        widget.progress =
            double.parse((currentFileSize / totalFileSize).toStringAsFixed(1));
      });
    };
    super.initState();
  }

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
          Expanded(child: Container()),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 20,
                    height: 20,
                    margin: const EdgeInsets.only(right: 10),
                    child: Offstage(
                      offstage: !widget.isUpLoading,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.0,
                        backgroundColor: Colors.grey,
                        valueColor: AlwaysStoppedAnimation(Colors.blue),
                        value: widget.progress,
                      ),
                    ),
                  ),
                  Container(
                    width: 20,
                    height: 20,
                    margin: const EdgeInsets.only(right: 10),
                    child: Offstage(
                        offstage: !widget.isUpLoadFailed,
                        child: Icon(
                          Icons.error_outline,
                          color: Colors.red,
                        )),
                  ),
                  ImageBubble(filelocalPath: widget.message.fileLocalPath)
                ],
              ),
              Text(
                  DateTime.fromMillisecondsSinceEpoch(widget.message.timestamp)
                      .toString(),
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                  )),
            ],
          ),
        ],
      ),
    );
  }
}
