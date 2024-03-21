import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../../constants/api_constants.dart';
import '../../../../constants/error_dia_log.dart';
import '../../../../main.dart';
import '../../../../model/userModel.dart';
import '../../../../services/FirebaseService.dart';
import '../../../routes/app_pages.dart';

class CreatePeerPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _PageState();
}

class _PageState extends State<CreatePeerPage> {
  String targetUserID = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Create Peer',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white70,
        shadowColor: Colors.white,
        leading: Builder(
          builder: (context) {
            return IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.arrow_back),
              color: Colors.black,
            );
          },
        ),
      ),
      body: GestureDetector(
        onTap: (() {
          FocusScope.of(context).requestFocus(FocusNode());
        }),
        child: StreamBuilder(
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
                  return InkWell(
                    onTap: () {
                      FocusScope.of(context).requestFocus(FocusNode());
                      try {
                        // ZIMUsersInfoQueriedResult result = await ZIM
                        //     .getInstance()
                        //     .queryUsersInfo([targetUserID]);
                        // Navigator.pop(context);
                        // Navigator.push(context,
                        //     MaterialPageRoute(builder: ((context) {
                        //   return PeerChatPage(
                        //       conversationID: targetUserID,
                        //       conversationName: targetUserID);
                        // })));
                        Get.back();
                        Get.toNamed(Routes.PEER_CHAT_PAGE, arguments: {
                          ArgumentConstant.conversationID: user.id!,
                          ArgumentConstant.conversationName: user.name!
                        });
                      } on PlatformException catch (onError) {
                        ErrorDiaLog.showFailedDialog(
                            context, onError.code, onError.message!);
                      }
                    },
                    child: Row(
                      children: [
                        Icon(Icons.person),
                        SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(user.name!),
                            Text(user.email!),
                          ],
                        ),
                        // Spacer(),
                      ],
                    ),
                  );
                },
              );
            }
          },
        ),
        /* Container(
            width: double.infinity,
            padding: EdgeInsets.all(10),
            child: Column(
              children: [
                const SizedBox(height: 100),
                Container(
                  margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.grey, width: 0.25),
                    borderRadius: BorderRadius.circular((20.0)),
                  ),
                  child: TextField(
                    textInputAction: TextInputAction.done,
                    onChanged: (value) {
                      targetUserID = value;
                    },
                    onEditingComplete: () {
                      FocusScope.of(context).unfocus();
                    },
                    decoration: const InputDecoration(
                        contentPadding:
                            EdgeInsets.only(top: 0, left: 15, right: 15),
                        border: InputBorder.none,
                        labelText: 'User ID'),
                  ),
                ),
                SizedBox(height: 40),
                ElevatedButton(
                  onPressed: (() async {
                    FocusScope.of(context).requestFocus(FocusNode());
                    try {
                      // ZIMUsersInfoQueriedResult result = await ZIM
                      //     .getInstance()
                      //     .queryUsersInfo([targetUserID]);
                      // Navigator.pop(context);
                      // Navigator.push(context,
                      //     MaterialPageRoute(builder: ((context) {
                      //   return PeerChatPage(
                      //       conversationID: targetUserID,
                      //       conversationName: targetUserID);
                      // })));
                      Get.back();
                      Get.toNamed(Routes.PEER_CHAT_PAGE, arguments: {
                        ArgumentConstant.conversationID: targetUserID,
                        ArgumentConstant.conversationName: targetUserID
                      });
                    } on PlatformException catch (onError) {
                      ErrorDiaLog.showFailedDialog(
                          context, onError.code, onError.message!);
                    }
                  }),
                  child: const Text('OK'),
                ),
              ],
            )),*/
      ),
    );
  }
}
