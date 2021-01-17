import 'package:authentication_repository/authentication_repository.dart';
import 'package:divvy/screens/screens/account/line_item_approval/chat_button_attributes.dart';
import 'package:divvy/screens/screens/account/messaging_screen.dart';
import 'package:flutter/material.dart';

class ChatButton extends StatelessWidget {
  final UserModel user;
  final String lineItemID;
  final Project project;
  final FirebaseService firebaseService = FirebaseService();

  ChatButton(
    this.user,
    this.lineItemID,
    this.project,
  );

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<LineItem>(
      stream:
          firebaseService.streamRealtimeLineItem(project.projectID, lineItemID),
      builder: (BuildContext context, AsyncSnapshot<LineItem> lineItem) {
        if (lineItem.hasError) {
          return Text('Something went wrong');
        }

        if (lineItem.connectionState == ConnectionState.waiting) {
          return Text("Loading");
        }

        return _chatButton(context, lineItem.data);
      },
    );
  }

  FlatButton _chatButton(BuildContext context, LineItem lineItem) {
    ChatButtonAttributes chatButtonAttributes = (user.isHomeowner)
        ? HomeownerChatButtonAttributes(
            user, project, lineItem.newMessageFromGC)
        : GCChatButtonAttributes(
            user, project, lineItem.newMessageFromHomeowner);
    return FlatButton(
      color: Colors.transparent,
      onPressed: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => MessagingScreen(lineItem, project, user)));
      },
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: Icon(
              chatButtonAttributes.icon,
              color: chatButtonAttributes.iconColor,
              //Icons.mark_chat_unread,
              //color: Colors.red,
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Chat with ${chatButtonAttributes.name}',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                    )),
                Text('${chatButtonAttributes.title}',
                    style: TextStyle(
                      color: Colors.black45,
                      fontSize: 12,
                    )),
              ],
            ),
          ),
          Icon(Icons.arrow_forward_ios_rounded, color: Colors.black45)
        ],
      ),
    );
  }
}
