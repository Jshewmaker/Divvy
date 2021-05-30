import 'dart:io';

import 'package:authentication_repository/authentication_repository.dart';
import 'package:divvy/screens/screens/account/line_item_approval/chat_button.dart';
import 'package:divvy/screens/screens/invoice_screen.dart';
import 'package:divvy/screens/screens/work_denial_screen.dart';
import 'package:divvy/sila/repositories/repositories.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as Path;

class LineItemInfoScreen extends StatefulWidget {
  LineItemInfoScreen(this._lineItem, this._project, this._user);

  final LineItem _lineItem;
  final Project _project;
  final UserModel _user;

  @override
  State<LineItemInfoScreen> createState() =>
      _LineItemInfoScreenState(_lineItem, _project, _user);
}

class _LineItemInfoScreenState extends State<LineItemInfoScreen> {
  _LineItemInfoScreenState(
    this._lineItem,
    this._project,
    this._user,
  );

  final LineItem _lineItem;
  final Project _project;
  final UserModel _user;

  File _image;
  String _uploadedFileURL;

  double _boraderRadius = 10.0;

  final SilaRepository silaRepository =
      SilaRepository(silaApiClient: SilaApiClient(httpClient: http.Client()));

  @override
  Widget build(BuildContext context) {
    // PickedFile image;
    // ignore: unnecessary_statements
    _uploadedFileURL = _lineItem.pictureUrl;
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
                          Text(_lineItem.title,
                              style: TextStyle(
                                color: Colors.teal[400],
                                fontSize: 36,
                              ),
                              textAlign: TextAlign.center),
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
                          SizedBox(
                            height: 5,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    _pictureWidget(_user, _lineItem),
                    SizedBox(
                      height: 30,
                    ),
                    ChatButton(_user, _lineItem.id, _project),
                  ],
                ),
              ),
            ),
          ),
          Visibility(
            visible: _user.accountType == 'homeowner',
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Visibility(
                    visible: (_lineItem.homeownerApprovalDate == null),
                    child: _approveButton(
                        'Approve',
                        (_lineItem.generalContractorApprovalDate != null &&
                            _lineItem.homeownerApprovalDate == null))),
                Visibility(
                    visible: (_lineItem.homeownerApprovalDate != null),
                    child: _approveButton('View Receipt', true)),
                _DenyButton(_lineItem, _user, _project),
              ],
            ),
          ),
          Visibility(
              visible: _user.accountType == 'business',
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Visibility(
                      visible: (_lineItem.homeownerApprovalDate == null),
                      child: _SubmitButton(_lineItem, _user)),
                  Visibility(
                      visible: (_lineItem.homeownerApprovalDate != null),
                      child: _approveButton('View Receipt', true)),
                ],
              )),
          SizedBox(
            height: 40,
          ),
        ],
      ),
    );
  }

  Widget _approveButton(String buttonText, bool isEnabled) {
    return RaisedButton(
        child: Text(
          buttonText,
        ),
        shape:
            (RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))),
        color: const Color(0xFF1E90FF),
        textColor: Colors.white,
        onPressed: isEnabled
            ? () => {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) =>
                          InvoiceScreen(_lineItem, _project, _user)))
                }
            : null);
  }

  Widget _pictureWidget(UserModel user, LineItem lineItem) {
    return Container(
        height: 300,
        width: double.maxFinite,
        child: GestureDetector(
            onTap: (user.accountType == 'business' &&
                    lineItem.generalContractorApprovalDate == null)
                ? () {
                    _showPicker(context);
                  }
                : null,
            child: Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(_boraderRadius)),
                child: (_image != null)
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(_boraderRadius),
                        child: Image.file(
                          _image,
                          fit: BoxFit.fitHeight,
                        ))
                    : (_uploadedFileURL != null)
                        ? Image.network(_uploadedFileURL)
                        : Container(
                            child: Center(
                              child: user.accountType == 'homeowner'
                                  ? Text('No photo submitted')
                                  : Text('Tap To Add Picture'),
                            ),
                          ))));
  }

  _imgFromCamera() async {
    final picker = ImagePicker();
    final image =
        await picker.getImage(source: ImageSource.camera, imageQuality: 50);
    setState(() {
      if (image != null) _image = File(image.path);
      _addImageToFirebase(context);
    });
  }

  _imgFromGallery() async {
    final picker = ImagePicker();
    final image =
        await picker.getImage(source: ImageSource.gallery, imageQuality: 50);

    setState(() {
      if (image != null) {
        _image = File(image.path);
        //_uploadedFileURL = _user.id/${_lineItem.title}-' + Path.basename(_image.path);
      }

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
    StorageReference storageReference = FirebaseStorage.instance.ref();
    if (_image.path != null) {
      storageReference = storageReference.child(
          '${_user.id}/${_lineItem.title}-' + Path.basename(_image.path));
    }
    StorageUploadTask uploadTask = storageReference.putFile(_image);
    await uploadTask.onComplete;
    print('File Uploaded');

    storageReference.getDownloadURL().then((fileURL) {
      FirebaseService firebaseService = FirebaseService();
      firebaseService.addDataToProjectDocument(
          {'picture_url': fileURL}, _user.projectID, _lineItem.id);
      // setState(() {
      //   _uploadedFileURL = fileURL;
      // });
    });
  }
}

class _DenyButton extends StatelessWidget {
  _DenyButton(this.lineItem, this.user, this.project);

  final LineItem lineItem;
  final UserModel user;
  final Project project;

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
    bool isEnabled = (lineItem.generalContractorApprovalDate != null &&
            lineItem.homeownerApprovalDate == null)
        ? true
        : false;
    //return BlocBuilder<TransferSilaBloc, TransferSilaState>(
    //buildWhen: (previous, current) => previous.status != current.status,
    //builder: (context, state) {
    return Visibility(
      visible: (lineItem.homeownerApprovalDate == null),
      child: RaisedButton(
        child: Text('Deny'),
        shape:
            (RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))),
        color: const Color(0xFFff0000),
        textColor: Colors.white,
        onPressed: isEnabled
            ? () => {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) =>
                          WorkDenialScreen(lineItem, project, user)))
                  //deny(user.projectID, lineItem.id),
                  //Navigator.pop(context),
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
    Map<String, int> firebaseData;
    int date = DateTime.now().millisecondsSinceEpoch;
    firebaseData = {
      "general_contractor_approval_date": date,
      "date_denied": null,
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
