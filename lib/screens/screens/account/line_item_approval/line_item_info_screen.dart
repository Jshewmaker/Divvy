import 'dart:io';
import 'package:divvy/screens/screens/invoice_screen.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
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

import '../messaging_screen.dart';
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
        title: Text('Work Submission'),
      ),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: Container(
                width: MediaQuery.of(context).size.width / 1.1,
                child: ListView(
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    Center(
                      child: Column(
                        children: [
                          Text(
                            _lineItem.title,
                            style: TextStyle(
                              color: Colors.teal[400],
                              fontSize: 36,
                            ),
                          ),
                          Text(
                            _lineItem
                                .subContractor, // '\npool & spa services inc',
                            style: TextStyle(color: Colors.grey, fontSize: 14),
                          ),
                          Text(
                            NumberFormat.currency(symbol: '\$')
                                .format(_lineItem.cost),
                            style: TextStyle(
                              color: Colors.teal[400],
                              fontSize: 30,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    _pictureWidget(),
                    SizedBox(
                      height: 40,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) =>
                                MessagingScreen(_lineItem, _project)));
                      },
                      child: Center(
                          child: Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          Icon(
                            Icons.message,
                            color: Colors.teal[400],
                          ),
                          Text(' Chat with general contractor',
                              style: TextStyle(
                                  color: Colors.teal[400],
                                  fontSize: 14,
                                  decoration: TextDecoration.underline)),
                        ],
                      )),
                    ),
                    SizedBox(
                      height: 40,
                    ),
                  ],
                ),
              ),
            ),
          ),
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
          SizedBox(
            height: 40,
          ),
        ],
      ),
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
