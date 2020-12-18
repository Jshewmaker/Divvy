import 'dart:io';
import 'package:divvy/screens/screens/invoice_screen.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as Path;

import 'package:authentication_repository/authentication_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:divvy/sila/blocs/transfer_sila/transfer_sila.dart';
import 'package:divvy/sila/repositories/repositories.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:authentication_repository/src/models/project_line_items/messages.dart';
import 'package:http/http.dart' as http;
import 'package:jiffy/jiffy.dart';
import 'package:divvy/bloc/chat/chat_bloc.dart';
import 'package:divvy/bloc/chat/chat_state.dart';
import 'package:divvy/bloc/chat/chat_event.dart';
//import 'package:fluttertoast/fluttertoast.dart';

class LineItemInfoScreen extends StatefulWidget {
  LineItemInfoScreen(this._lineItem, this._project);

  final LineItem _lineItem;
  final Project _project;

  @override
  State<LineItemInfoScreen> createState() =>
      _LineItemInfoScreenState(_lineItem, _project);
}

class _LineItemInfoScreenState extends State<LineItemInfoScreen> {
  _LineItemInfoScreenState(
    this._lineItem,
    this._project,
  );

  final LineItem _lineItem;
  final Project _project;
  final FirebaseService _firebaseService = FirebaseService();

  File _image;
  String _uploadedFileURL;
  UserModel _user;

  double _boraderRadius = 10.0;

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
    _uploadedFileURL = _lineItem.pictureUrl;
    var userProvider = context.watch<UserModelProvider>();
    _user = userProvider.user;
    return Scaffold(
      appBar: AppBar(
        title: RichText(
          text: new TextSpan(
            // Note: Styles for TextSpans must be explicitly defined.
            // Child text spans will inherit styles from parent
            children: <TextSpan>[
              new TextSpan(
                  text: _lineItem.title,
                  style: new TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.teal[400],
                    fontSize: 24,
                  )),
              TextSpan(
                  text: _lineItem.subContractor, // '\npool & spa services inc',
                  style: TextStyle(color: Colors.grey, fontSize: 14)),
            ],
          ),
        ),
      ),
      body: ListView(shrinkWrap: true, children: [
        Center(
          child: Container(
            width: MediaQuery.of(context).size.width / 1.1,
            child: ListView(
              shrinkWrap: true,
              children: [
                SizedBox(
                  height: 10,
                ),
                _pictureWidget(),
                SizedBox(
                  height: 20,
                ),
                _Chat(_lineItem, _user, _project),
                Visibility(
                  visible: _user.isHomeowner,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Visibility(
                          visible: _lineItem.datePaid == null,
                          child: _approveButton('Approve')),
                      Visibility(
                          visible: _lineItem.datePaid != null,
                          child: _approveButton('View Receipt')),
                      _DenyButton(_lineItem, _user),
                    ],
                  ),
                ),
                Visibility(
                    visible: !_user.isHomeowner,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _SubmitButton(_lineItem, _user),
                      ],
                    )),
              ],
            ),
          ),
        ),
      ]),
    );
  }

  Widget _approveButton(String buttonText) {
    return RaisedButton(
        child: Text(
          buttonText,
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        shape:
            (RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))),
        color: const Color(0xFF1E90FF),
        textColor: Colors.white,
        onPressed: () => {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => InvoiceScreen(_lineItem, _project)))
            });
  }

  Widget _pictureWidget() {
    return Container(
      height: 300,
      width: double.maxFinite,
      child: GestureDetector(
          onTap: () {
            _showPicker(context);
          },
          child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(_boraderRadius)),
              child: _uploadedFileURL != null
                  ? Image.network(_uploadedFileURL)
                  : (_image != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(_boraderRadius),
                          child: Image.file(
                            _image,
                            fit: BoxFit.fitHeight,
                          ))
                      : Container(
                          child: Center(
                            child: Text('Tap To Add Picture'),
                          ),
                        )))),
    );
  }

  _imgFromCamera() async {
    final picker = ImagePicker();
    final image =
        await picker.getImage(source: ImageSource.camera, imageQuality: 100);
    setState(() {
      if (image != null) _image = File(image.path);
      _addImageToFirebase(context);
    });
  }

  _imgFromGallery() async {
    final picker = ImagePicker();
    final image =
        await picker.getImage(source: ImageSource.gallery, imageQuality: 100);

    setState(() {
      if (image != null) _image = File(image.path);
      _addImageToFirebase(context);
    });
  }

  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: new Wrap(
                children: <Widget>[
                  new ListTile(
                      leading: new Icon(Icons.photo_library),
                      title: new Text('Photo Library'),
                      onTap: () {
                        _imgFromGallery();
                        Navigator.of(context).pop();
                      }),
                  new ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text('Camera'),
                    onTap: () {
                      _imgFromCamera();

                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  void _addImageToFirebase(context) async {
    StorageReference storageReference = FirebaseStorage.instance
        .ref()
        .child('${_user.id}/${_lineItem.title}-' + Path.basename(_image.path));
    StorageUploadTask uploadTask = storageReference.putFile(_image);
    await uploadTask.onComplete;
    print('File Uploaded');
    storageReference.getDownloadURL().then((fileURL) {
      FirebaseService firebaseService = FirebaseService();
      firebaseService.addDataToProjectDocument(
          {'picture_url': fileURL}, _user.projectID, _lineItem.id);
      setState(() {
        _uploadedFileURL = fileURL;
      });
    });
  }
}

class _DenyButton extends StatelessWidget {
  _DenyButton(this.lineItem, this.user);

  final LineItem lineItem;
  final UserModel user;

  void deny(String projectID, String lineID) {
    Map<String, Timestamp> firebaseData;
    firebaseData = {
      "general_contractor_approval_date": null,
    };
    FirebaseService _firebaseService = FirebaseService();
    _firebaseService.addDataToProjectDocument(firebaseData, projectID, lineID);
  }

  @override
  Widget build(BuildContext context) {
    bool isEnabled = (lineItem.generalContractorApprovalDate != null &&
            lineItem.homeownerApprovalDate == null)
        ? true
        : false;
    //return BlocBuilder<TransferSilaBloc, TransferSilaState>(
    //buildWhen: (previous, current) => previous.status != current.status,
    //builder: (context, state) {
    return Visibility(
      visible: lineItem.datePaid == null,
      child: RaisedButton(
        child: Text('Deny'),
        shape:
            (RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))),
        color: const Color(0xFFff0000),
        textColor: Colors.white,
        onPressed: isEnabled
            ? () => {
                  deny(user.projectID, lineItem.id),
                  Navigator.pop(context),
                }
            : null,
      ),
    );
    //},
    //);
  }
}

class _SubmitButton extends StatelessWidget {
  _SubmitButton(this.lineItem, this.user);

  final LineItem lineItem;
  final UserModel user;

  void submit(String projectID, String lineID) {
    Map<String, Timestamp> firebaseData;
    Timestamp date = Timestamp.now();
    firebaseData = {
      "general_contractor_approval_date": date,
    };
    FirebaseService _firebaseService = FirebaseService();
    _firebaseService.addDataToProjectDocument(firebaseData, projectID, lineID);
  }

  @override
  Widget build(BuildContext context) {
    bool isEnabled =
        (lineItem.generalContractorApprovalDate == null) ? true : false;
    return Container(
      child: RaisedButton(
        child: Text('Submit for Approval'),
        shape:
            (RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))),
        color: const Color(0xFF1E90FF),
        textColor: Colors.white,
        onPressed: isEnabled
            ? () => {
                  submit(user.projectID, lineItem.id),
                  Navigator.pop(context),
                }
            : null,
      ),
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
          Card(
            color: Colors.teal[200],
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0)),
            elevation: 1,
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(message.message),
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
        Container(
          height: 300,
          child: ListView.builder(
            reverse: true,
            shrinkWrap: true,
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
                    BlocProvider.of<ChatBloc>(context).add(
                        SendMessage(user, lineItem, _controller.text, project)),
                    _controller.clear(),
                  }),
        ),
      ),
    );
  }
}
