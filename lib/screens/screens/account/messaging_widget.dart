import 'package:authentication_repository/authentication_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:authentication_repository/src/models/project_line_items/messages.dart';
import 'package:divvy/screens/screens/account/line_item_approval/line_item_info_screen.dart';
import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';
import 'package:provider/provider.dart';

import 'message_attribute_model.dart';

class MessagesWidget extends StatelessWidget {
  final UserModel user;
  final String lineItemID;
  final String projectID;
  final FirebaseService firebaseService = FirebaseService();

  MessagesWidget(
    this.user,
    this.lineItemID,
    this.projectID,
  );

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<MessageListModel>(
      stream: firebaseService.streamRealtimeMessages(projectID, lineItemID),
      builder:
          (BuildContext context, AsyncSnapshot<MessageListModel> messageList) {
        if (messageList.hasError) {
          return Text('Something went wrong');
        }

        if (messageList.connectionState == ConnectionState.waiting) {
          return Text("Loading");
        }

        return new ListView(
          reverse: true,
          children: messageList.data.messages.map((Message message) {
            return new Column(
              children: [
                _MessageWidget(
                  message: message,
                  user: user,
                  attributes: (user.id == message.id)
                      ? MessageAttributes.sent
                      : MessageAttributes.recieved,
                ),
                _TimestampWidget(
                  message: message,
                  user: user,
                ),
              ],
            );
          }).toList(),
        );
      },
    );
  }
}

class _MessageWidget extends StatelessWidget {
  final Message message;
  final UserModel user;
  final MessageAttributes attributes;
  //final Project project;

  _MessageWidget({
    Key key,
    this.message,
    this.user,
    this.attributes,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: attributes.messageAlignment,
      child: Wrap(
        children: [
          ConstrainedBox(
            constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width / 1.5),
            child: Card(
              color: attributes.color,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0)),
              elevation: 0,
              child: Padding(
                padding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
                child: Text(
                  message.message,
                  textAlign: attributes.textAlignment,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class _TimestampWidget extends StatelessWidget {
  final Message message;
  final UserModel user;
  //final Project project;

  _TimestampWidget({
    Key key,
    this.message,
    this.user,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment:
          (user.id == message.id) ? Alignment.topRight : Alignment.topLeft,
      child: Text(
        getTime(message.timestamp),
        style: TextStyle(
          color: Colors.black45,
        ),
      ),
    );
  }

  String getTime(Timestamp date) {
    String newDate = "";
    if (date != null) {
      newDate = Jiffy(date.toDate()).format("MM/dd/yy, h:mm a");
    }
    return newDate;
  }
}
