import 'package:authentication_repository/authentication_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:divvy/sila/repositories/repositories.dart';
import 'package:flutter/material.dart';
import 'package:authentication_repository/src/models/project_line_items/messages.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import 'messaging_widget.dart';

class MessagingScreen extends StatelessWidget {
  MessagingScreen(
    this.lineItem,
    this.project,
  );

  final LineItem lineItem;
  final Project project;

  final SilaRepository silaRepository =
      SilaRepository(silaApiClient: SilaApiClient(httpClient: http.Client()));

  @override
  Widget build(BuildContext context) {
    UserModel _user = Provider.of<UserModel>(context);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(lineItem.title),
      ),
      body: Center(
          child: Container(
              width: MediaQuery.of(context).size.width / 1.1,
              child: _Chat(lineItem, _user, project))),
    );
  }
}

class _Chat extends StatelessWidget {
  _Chat(this.lineItem, this.user, this.project);

  final LineItem lineItem;
  final UserModel user;
  final Project project;
  final FirebaseService _firebaseService = FirebaseService();

  void sendMessage(
      String message, UserModel user, Project project, LineItem lineItem) {
    Message messageModel =
        Message(id: user.id, message: message, timestamp: Timestamp.now());
    _firebaseService.addMessage(
        project.projectID, lineItem.id, messageModel.toMap());
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
            child: Container(
                child: MessagesWidget(user, lineItem.id, project.projectID))),
        SizedBox(
          height: 20,
        ),
        _textField(context),
        SizedBox(
          height: 20,
        ),
      ],
    );
  }

  Container _textField(BuildContext context) {
    final TextEditingController _controller = TextEditingController();
    return Container(
      child: TextField(
        controller: _controller,
        minLines: 1,
        maxLines: 15,
        autocorrect: false,
        decoration: InputDecoration(
          hintText: 'Comments',
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
            borderSide: BorderSide(color: Colors.grey),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
            borderSide: BorderSide(color: Colors.grey),
          ),
          suffixIcon: IconButton(
              icon: Icon(Icons.send, color: Colors.black45),
              onPressed: () => {
                    if (_controller.text.trim() != '')
                      {
                        sendMessage(_controller.text, user, project, lineItem),
                        _controller.clear(),
                      }
                  }),
        ),
      ),
    );
  }
}
