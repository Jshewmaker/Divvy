import 'dart:ui';

import 'package:authentication_repository/authentication_repository.dart';
import 'package:authentication_repository/src/models/project_line_items/messages.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:divvy/sila/repositories/sila_api_client.dart';
import 'package:divvy/sila/repositories/sila_repository.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class WorkDenialScreen extends StatefulWidget {
  WorkDenialScreen(this._lineItem, this._project, this._user);
  final LineItem _lineItem;
  final Project _project;
  final UserModel _user;

  @override
  _WorkDenialState createState() =>
      _WorkDenialState(_lineItem, _project, _user);
}

class _WorkDenialState extends State<WorkDenialScreen> {
  _WorkDenialState(this._lineItem, this._project, this._user);
  final LineItem _lineItem;
  final Project _project;
  final UserModel _user;
  final TextEditingController _controller = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  final FirebaseService _firebaseService = FirebaseService();
  final SilaRepository silaRepository =
      SilaRepository(silaApiClient: SilaApiClient(httpClient: http.Client()));

  void sendMessage(
      String message, UserModel user, Project project, LineItem lineItem) {
    Message messageModel =
        Message(id: user.id, message: message, timestamp: Timestamp.now());
    _firebaseService.addMessage(
        project.projectID, lineItem.id, messageModel.toMap());
    String field = (user.accountType == 'homeowner')
        ? "new_message_from_homeowner"
        : "new_message_from_gc";

    Map<String, dynamic> data = {field: true};
    _firebaseService.unreadMessage(project.projectID, lineItem.id, data);
  }

  void deny(String projectID, String lineID) {
    int value = DateTime.now().millisecondsSinceEpoch;
    Map<String, int> firebaseData;
    firebaseData = {
      "general_contractor_approval_date": null,
      "date_denied": value,
    };
    FirebaseService _firebaseService = FirebaseService();
    _firebaseService.addDataToProjectDocument(firebaseData, projectID, lineID);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Submission Denial')),
      body: Center(
        child: Container(
            width: MediaQuery.of(context).size.width / 1.1,
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  TextFormField(
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter some text';
                      }
                      return null;
                    },
                    controller: _controller,
                    minLines: 5,
                    maxLines: 15,
                    autocorrect: false,
                    decoration: InputDecoration(
                      hintText: 'Denial message...',
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                    ),
                  ),
                  // DenyButton(
                  //   lineItem: _lineItem,
                  //   user: _user,
                  //   project: _project,
                  //   formKey: _formKey,
                  //   message: _controller.text,
                  // ),
                  RaisedButton(
                    child: const Text('Deny Job Submission'),
                    textColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    color: Colors.red,
                    onPressed: () {
                      (_formKey.currentState.validate())
                          //onPressed: (true)
                          ? {
                              sendMessage(
                                  _controller.text, _user, _project, _lineItem),
                              deny(_project.projectID, _lineItem.id),
                              Navigator.pop(context)
                            }
                          : Scaffold.of(context).showSnackBar(const SnackBar(
                              content: Text('Denial comment required.')));
                    },
                  ),
                  Container(
                    padding: EdgeInsets.all(5),
                    child: Column(
                      children: [
                        Text(
                          "Once denied, the message above will be sent to your contractor in the ${_lineItem.title} chat. The line item's staus will be changed to denied and must be resubmit by your contractor in order to begin the approval process.",
                          style: TextStyle(
                            color: Colors.black45,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )),
      ),
    );
  }
}

class DenyButton extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final UserModel user;
  final Project project;
  final LineItem lineItem;
  final String message;

  DenyButton(
      {Key key,
      this.formKey,
      this.user,
      this.project,
      this.lineItem,
      this.message})
      : super(key: key);

  final FirebaseService _firebaseService = FirebaseService();

  void deny(String projectID, String lineID) {
    int value = DateTime.now().millisecondsSinceEpoch;
    Map<String, int> firebaseData;
    firebaseData = {
      "general_contractor_approval_date": null,
      "date_denied": value,
    };
    FirebaseService _firebaseService = FirebaseService();
    _firebaseService.addDataToProjectDocument(firebaseData, projectID, lineID);
  }

  void sendMessage(
      String message, UserModel user, Project project, LineItem lineItem) {
    Message messageModel =
        Message(id: user.id, message: message, timestamp: Timestamp.now());
    _firebaseService.addMessage(
        project.projectID, lineItem.id, messageModel.toMap());
    String field = (user.accountType == 'homeowner')
        ? "new_message_from_homeowner"
        : "new_message_from_gc";

    Map<String, dynamic> data = {field: true};
    _firebaseService.unreadMessage(project.projectID, lineItem.id, data);
  }

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      child: const Text('Deny Job Submission'),
      textColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30.0),
      ),
      color: Colors.red,
      onPressed: () {
        (formKey.currentState.validate())
            //onPressed: (true)
            ? sendMessage(message, user, project, lineItem)
            : Scaffold.of(context).showSnackBar(
                const SnackBar(content: Text('Denial comment required.')));
      },
    );
  }
}
