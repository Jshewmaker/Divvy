import 'dart:io';

import 'package:authentication_repository/authentication_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:divvy/sila/blocs/transfer_sila/transfer_sila.dart';
import 'package:divvy/sila/repositories/repositories.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as Path;

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
  File _image;
  String _uploadedFileURL;

  double _boraderRadius = 10.0;

  final TextEditingController _controller = TextEditingController();

  final SilaRepository silaRepository =
      SilaRepository(silaApiClient: SilaApiClient(httpClient: http.Client()));

  void approve(String projectID, String lineID) {
    Timestamp value = Timestamp.now();
    Map<String, Timestamp> firebaseData;

    firebaseData = {
      "homeowner_approval_date": value,
      "date_paid": value,
    };
    FirebaseService _firebaseService = FirebaseService();
    _firebaseService.addDataToProjectDocument(firebaseData, projectID, lineID);
  }

  @override
  Widget build(BuildContext context) {
    var userProvider = context.watch<UserModelProvider>();
    UserModel user = userProvider.user;
    return BlocListener<TransferSilaBloc, TransferSilaState>(
      listener: (context, state) {
        /*if (state is TransferSilaLoadFailure) {
          //TODO: Copied code fix
          Scaffold.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
                const SnackBar(content: Text('Authentication Failure')));
        }*/
        if (state is TransferSilaLoadSuccess) {
          approve(user.projectID, lineItem.id);
          Navigator.pop(context);
        }
      },
      child: Scaffold(
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
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
                        text: lineItem
                            .subContractor, // '\npool & spa services inc',
                        style: TextStyle(color: Colors.grey, fontSize: 14)),
                  ],
                ),
              ),
            ),
            SliverList(
              delegate: SliverChildListDelegate([
                Center(
                  child: Container(
                    width: MediaQuery.of(context).size.width / 1.1,
                    child: ListView(
                      shrinkWrap: true,
                      children: [
                        pictureWidget(),
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          child: TextField(
                            controller: _controller,
                            minLines: 1,
                            maxLines: 15,
                            autocorrect: false,
                            decoration: InputDecoration(
                              hintText: 'Comments',
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                    Radius.circular(_boraderRadius)),
                                borderSide: BorderSide(color: Colors.grey),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                    Radius.circular(_boraderRadius)),
                                borderSide: BorderSide(color: Colors.grey),
                              ),
                              suffixIcon: IconButton(
                                onPressed: () => _controller.clear(),
                                icon: Icon(Icons.send, color: Colors.black45),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Visibility(
                          visible: user.isHomeowner,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              _ApproveButton(lineItem, user,
                                  project.generalContractorSilaHandle),
                              _DenyButton(lineItem, user),
                            ],
                          ),
                        ),
                        Visibility(
                            visible: !user.isHomeowner,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                _SubmitButton(lineItem, user),
                              ],
                            )),
                      ],
                    ),
                  ),
                ),
              ]),
            )
          ],
        ),
      ),
    );
  }

  Widget pictureWidget() {
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
            child: _image != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(_boraderRadius),
                    child: Image.file(
                      _image,
                      fit: BoxFit.fitHeight,
                    ))
                : Container(
                    child: Center(
                      child: Text('Picture Placeholder'),
                    ),
                  ),
          )),
    );
  }

  _imgFromCamera() async {
    final picker = ImagePicker();
    final image =
        await picker.getImage(source: ImageSource.camera, imageQuality: 100);
    setState(() {
      _image = File(image.path);
      addImageToFirebase(context);
    });
  }

  _imgFromGallery() async {
    final picker = ImagePicker();
    final image =
        await picker.getImage(source: ImageSource.gallery, imageQuality: 100);

    setState(() {
      _image = File(image.path);
      addImageToFirebase(context);
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

  void addImageToFirebase(context) async {
    StorageReference storageReference = FirebaseStorage.instance
        .ref()
        .child('chats/${Path.basename(_image.path)}}');
    StorageUploadTask uploadTask = storageReference.putFile(_image);
    await uploadTask.onComplete;
    print('File Uploaded');
    storageReference.getDownloadURL().then((fileURL) {
      setState(() {
        _uploadedFileURL = fileURL;
      });
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
