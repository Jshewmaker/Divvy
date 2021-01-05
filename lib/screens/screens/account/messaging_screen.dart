import 'package:authentication_repository/authentication_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:divvy/sila/repositories/repositories.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:authentication_repository/src/models/project_line_items/messages.dart';
import 'package:http/http.dart' as http;
import 'package:jiffy/jiffy.dart';
import 'package:divvy/bloc/chat/chat_bloc.dart';
import 'package:divvy/bloc/chat/chat_state.dart';
import 'package:divvy/bloc/chat/chat_event.dart';

class MessagingScreen extends StatefulWidget {
  MessagingScreen(this.lineItem, this.project);

  final LineItem lineItem;
  final Project project;

  @override
  State<MessagingScreen> createState() =>
      _MessagingScreenState(lineItem, project);
}

class _MessagingScreenState extends State<MessagingScreen> {
  _MessagingScreenState(
    this.lineItem,
    this.project,
  );

  final LineItem lineItem;
  final Project project;
  final FirebaseService _firebaseService = FirebaseService();

  UserModel _user;

  final SilaRepository silaRepository =
      SilaRepository(silaApiClient: SilaApiClient(httpClient: http.Client()));

  void sendMessage(
      String message, UserModel user, Project project, LineItem lineItem) {
    Message messageModel =
        Message(id: user.id, message: message, timestamp: Timestamp.now());
    _firebaseService.addMessageToProjectDocument(
        messageModel.toMap(), project.projectID, lineItem.id);
  }

  @override
  Widget build(BuildContext context) {
    var userProvider = context.watch<UserModelProvider>();
    _user = userProvider.user;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: RichText(
          text: new TextSpan(
            children: <TextSpan>[
              new TextSpan(
                  text: lineItem.title,
                  style: new TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.teal[400],
                    fontSize: 24,
                  )),
            ],
          ),
        ),
      ),
      body: Center(
          child: Container(
              width: MediaQuery.of(context).size.width / 1.1,
              child: _Chat(lineItem, _user, project))),
    );
  }
}

class _MessageWidget extends StatelessWidget {
  final Message message;
  final UserModel user;
  //final Project project;

  _MessageWidget({
    Key key,
    this.message,
    this.user,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment:
          (user.id == message.id) ? Alignment.topRight : Alignment.topLeft,
      child: Wrap(
        children: [
          ConstrainedBox(
            constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width / 1.5),
            child: Card(
              color: Colors.teal[200],
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0)),
              elevation: 1,
              child: Padding(
                padding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
                child: Text(message.message),
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
    _firebaseService.addMessageToProjectDocument(
        messageModel.toMap(), project.projectID, lineItem.id);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ChatBloc(firebaseService: _firebaseService),
      child: BlocBuilder<ChatBloc, ChatState>(
        builder: (context, state) {
          if (state is ChatInitial) {
            BlocProvider.of<ChatBloc>(context).add(LoadChat(lineItem));
          }
          if (state is NoMessages) {
            return Column(
              children: [
                SizedBox(
                  height: 20,
                ),
                _textField(context),
                SizedBox(
                  height: 20,
                ),
              ],
            );
          } else if (state is ChatLoadFailure) {
            return Column(
              children: [
                Text('Something went wrong with loading the messages!',
                    style: TextStyle(color: Colors.red)),
                SizedBox(
                  height: 20,
                ),
                _textField(context),
                SizedBox(
                  height: 20,
                ),
              ],
            );
          } else if (state is ChatLoadSuccess) {
            List<dynamic> messageList =
                List.from(state.lineItem.messages.messages.reversed);
            return _messages(messageList, context);
          } else {
            return _textField(context);
          }
        },
      ),
    );
  }

  Column _messages(List<dynamic> messageList, BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Container(
            child: ListView.builder(
              reverse: true,
              itemCount: messageList.length,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    _MessageWidget(
                      message: messageList[index],
                      user: user,
                    ),
                    _TimestampWidget(
                      message: messageList[index],
                      user: user,
                    ),
                  ],
                );
              },
            ),
          ),
        ),
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
                        BlocProvider.of<ChatBloc>(context).add(SendMessage(
                            user, lineItem, _controller.text, project)),
                        _controller.clear(),
                      }
                  }),
        ),
      ),
    );
  }
}
