import 'package:flutter/material.dart';
import 'package:zego_zim/zego_zim.dart';

import '../bubble/video_bubble.dart';
import '../uploading_progress_model.dart';

class SendVideoMsgCell extends StatefulWidget {
  ZIMVideoMessage message;
  double? progress;

  SendVideoMsgCell(
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
  State<StatefulWidget> createState() => _SendVideoMsgCellState();
}

class _SendVideoMsgCellState extends State<SendVideoMsgCell> {
  @override
  void initState() {
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
                  VideoBubble(filelocalPath: widget.message.fileLocalPath)
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
