import 'package:flutter/material.dart';

import 'CreatePeerPage.dart';

class MenuRightPopButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      icon: Icon(
        Icons.add_sharp,
        color: Colors.black,
      ),
      onSelected: (value) {
        switch (value) {
          case 'createPeer':
            //TODO
            break;
          default:
        }
      },
      itemBuilder: (context) {
        return <PopupMenuEntry<String>>[
          PopupMenuItem<String>(
            value: 'createPeer',
            child: Row(
              children: <Widget>[
                Icon(
                  Icons.person_add_alt_outlined,
                  size: 30,
                  color: Colors.grey.shade800,
                ),
                SizedBox(
                  width: 10,
                ),
                Text('Create Peer'),
              ],
            ),
            onTap: () async {
              await Future.delayed(Duration.zero);
              Navigator.push(context, MaterialPageRoute(builder: ((context) {
                return CreatePeerPage();
              })));
            },
          ),
        ];
      },
    );
  }
}
