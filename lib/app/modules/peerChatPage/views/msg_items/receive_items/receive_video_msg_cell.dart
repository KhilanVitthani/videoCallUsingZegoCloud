import 'package:flutter/material.dart';
import 'package:zego_zim/zego_zim.dart';

import '../bubble/video_bubble.dart';
import '../downloading_progress_model.dart';

class ReceiveVideoMsgCell extends StatefulWidget {
  ZIMVideoMessage message;
  double? progress;
  DownloadingProgressModel? downloadingProgressModel;
  ZIMMediaDownloadingProgress? downloadingProgress;

  ReceiveVideoMsgCell(
      {required this.message, required this.downloadingProgressModel});

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
  State<StatefulWidget> createState() => ReceiveVideoeMsgCellState();
}

class ReceiveVideoeMsgCellState extends State<ReceiveVideoMsgCell> {
  checkIsdownload() async {
    if (widget.message.fileLocalPath == '') {
      ZIMMediaDownloadedResult result = await ZIM
          .getInstance()!
          .downloadMediaFile(widget.message, ZIMMediaFileType.originalFile,
              (message, currentFileSize, totalFileSize) {});
      setState(() {
        widget.message = result.message as ZIMVideoMessage;
      });
    }
  }

  getVideoBubble() {
    return VideoBubble(filelocalPath: widget.message.fileLocalPath);
  }

  @override
  void initState() {
    // TODO: implement initState
    checkIsdownload();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 5,
      ),
      // width: double.infinity,
      child: Column(
        // crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          getVideoBubble(),
          Text(
              DateTime.fromMillisecondsSinceEpoch(widget.message.timestamp)
                  .toString(),
              style: TextStyle(
                color: Colors.grey,
                fontSize: 12,
              )),
        ],
      ),
    );
  }
}
