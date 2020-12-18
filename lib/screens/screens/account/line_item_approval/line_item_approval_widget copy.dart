import 'dart:io';
import 'package:divvy/screens/screens/account/messaging_screen.dart';
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
import 'package:toast/toast.dart';
//import 'package:fluttertoast/fluttertoast.dart';

class LineItemApprovalWidget extends StatefulWidget {
  LineItemApprovalWidget(this.lineItem, this.project);

  final LineItem lineItem;
  final Project project;

  @override
  State<LineItemApprovalWidget> createState() =>
      _LineItemApprovalWidgetState(lineItem, project);
}

class _LineItemApprovalWidgetState extends State<LineItemApprovalWidget> {
  _LineItemApprovalWidgetState(
    this.lineItem,
    this.project,
  );

  final LineItem lineItem;
  final Project project;
  final FirebaseService _firebaseService = FirebaseService();

  File _image;
  String _uploadedFileURL;
  UserModel _user;

  double _boraderRadius = 10.0;

  final SilaRepository silaRepository =
      SilaRepository(silaApiClient: SilaApiClient(httpClient: http.Client()));

  void approve(String projectID, String lineID) {
    Timestamp value = Timestamp.now();
    Map<String, Timestamp> firebaseData;

    firebaseData = {
      "homeowner_approval_date": value,
      "date_paid": value,
    };
    _firebaseService.addDataToProjectDocument(firebaseData, projectID, lineID);
  }

  void sendMessage(
      String message, UserModel user, Project project, LineItem lineItem) {
    Message messageModel =
        Message(id: user.id, message: message, timestamp: Timestamp.now());
    _firebaseService.addMessageToProjectDocument(
        messageModel.toMap(), project.projectID, lineItem.id);
  }

  @override
  Widget build(BuildContext context) {
    _uploadedFileURL = lineItem.pictureUrl;
    var userProvider = context.watch<UserModelProvider>();
    _user = userProvider.user;
    return MultiBlocListener(
      listeners: [
        BlocListener<TransferSilaBloc, TransferSilaState>(
          listener: (context, state) {
            if (state is TransferSilaLoadFailure) {
              Toast.show(state.exception.toString(), context,
                  duration: 4, gravity: Toast.BOTTOM);
              /*
              Fluttertoast.showToast(
                  msg: "This is Center Short Toast",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.CENTER,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.red,
                  textColor: Colors.white,
                  fontSize: 16.0); */
              //TODO: See if we can get the snackbar below working
              //        Scaffold.of(context)
              // ..hideCurrentSnackBar()
              // ..showSnackBar(
              //     const SnackBar(content: Text('Authentication Failure')));
            }
            if (state is TransferSilaLoadSuccess) {
              approve(_user.projectID, lineItem.id);
              Navigator.pop(context);
            }
          },
        ),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: Text('Work Submission'),
          /*
          title: RichText(
            
            text: new TextSpan(
              // Note: Styles for TextSpans must be explicitly defined.
              // Child text spans will inherit styles from parent
              children: <TextSpan>[
                new TextSpan(
                    text: lineItem.title,
                    style: new TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.teal[400],
                      fontSize: 24,
                    )),
                TextSpan(
                    text:
                        lineItem.subContractor, // '\npool & spa services inc',
                    style: TextStyle(color: Colors.grey, fontSize: 14)),
              ],
            ),
          ),
          */
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
                              lineItem.title,
                              style: TextStyle(
                                color: Colors.teal[400],
                                fontSize: 36,
                              ),
                            ),
                            Text(
                              lineItem
                                  .subContractor, // '\npool & spa services inc',
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 14),
                            ),
                            Text(
                              NumberFormat.currency(symbol: '\$')
                                  .format(lineItem.cost),
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
                                  MessagingScreen(lineItem, project)));
                        },
                        child: Center(
                            child: Wrap(
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            Icon(
                              Icons.message,
                              color: Colors.teal[400],
                            ),
                            Text(' Chat with contractor',
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
            Align(
              alignment: Alignment.bottomCenter,
              child: Column(
                children: [
                  Visibility(
                    visible: _user.isHomeowner,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _ApproveButton(lineItem, _user,
                            project.generalContractorSilaHandle),
                        _DenyButton(lineItem, _user),
                      ],
                    ),
                  ),
                  Visibility(
                      visible: !_user.isHomeowner,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _SubmitButton(lineItem, _user),
                        ],
                      )),
                ],
              ),
            ),
            SizedBox(
              height: 40,
            ),
          ],
        ),
      ),
    );
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
        .child('${_user.id}/${lineItem.title}-' + Path.basename(_image.path));
    StorageUploadTask uploadTask = storageReference.putFile(_image);
    await uploadTask.onComplete;
    print('File Uploaded');
    storageReference.getDownloadURL().then((fileURL) {
      FirebaseService firebaseService = FirebaseService();
      firebaseService.addDataToProjectDocument(
          {'picture_url': fileURL}, _user.projectID, lineItem.id);
    });
  }
}

class _ApproveButton extends StatelessWidget {
  _ApproveButton(this.lineItem, this.user, this.generalContractorSilaHandle);

  final LineItem lineItem;
  final UserModel user;
  final String generalContractorSilaHandle;

  @override
  Widget build(BuildContext context) {
    bool isEnabled = (lineItem.generalContractorApprovalDate != null &&
            lineItem.homeownerApprovalDate == null)
        ? true
        : false;
    return BlocBuilder<TransferSilaBloc, TransferSilaState>(
      //buildWhen: (previous, current) => previous.status != current.status,
      builder: (context, state) {
        return RaisedButton(
          child: Text('Approve'),
          shape:
              (RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))),
          color: const Color(0xFF1E90FF),
          textColor: Colors.white,
          onPressed: isEnabled
              ? () => {
                    BlocProvider.of<TransferSilaBloc>(context).add(
                        TransferSilaRequest(
                            sender: user,
                            amount: lineItem.cost,
                            receiverHandle: generalContractorSilaHandle,
                            transferMessage: 'transfer_msg'))
                  }
              : null,
        );
      },
    );
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
    return RaisedButton(
      child: Text('Deny'),
      shape: (RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))),
      color: const Color(0xFFff0000),
      textColor: Colors.white,
      onPressed: isEnabled
          ? () => {
                deny(user.projectID, lineItem.id),
                Navigator.pop(context),
              }
          : null,
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
