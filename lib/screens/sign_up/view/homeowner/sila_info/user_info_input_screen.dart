import 'package:authentication_repository/authentication_repository.dart';
import 'package:divvy/screens/screens/tab_bar_container.dart';
import 'package:divvy/screens/screens/widgets/name_and_bday_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';

class UserInfoInputScreen extends StatefulWidget {
  final String accountType;
  UserInfoInputScreen({Key key, this.accountType}) : super(key: key);

  @override
  _UserInputState createState() => _UserInputState();
}

// ignore: must_be_immutable
class _UserInputState extends State<UserInfoInputScreen> {
  FirebaseService _firebaseService = FirebaseService();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final MaskedTextController _phoneNumberController =
      MaskedTextController(mask: '000-000-0000');
  TextEditingController _birthdayController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: FittedBox(
              fit: BoxFit.fitWidth, child: Text('Homeowner Personal Info')),
          actions: [
            FutureBuilder(
              future: FirebaseAuth.instance.currentUser(),
              builder: (context, AsyncSnapshot<FirebaseUser> snapshot) {
                if (snapshot.hasData) {
                  return TextButton(
                      child: Text(
                        'Next',
                        style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.normal,
                            fontSize: 18),
                      ),
                      onPressed: () =>
                          _signUpButton(context, snapshot.data.uid));
                } else {
                  return Container();
                }
              },
            ),
          ],
        ),
        body: NameAndBdayWidget(
          firstNameController: _firstNameController,
          lastNameController: _lastNameController,
          phoneNumberController: _phoneNumberController,
          birthdayController: _birthdayController,
          formKey: _formKey,
        ));
  }

  _showAlertDialog(BuildContext context) {
    // set up the button
    Widget okButton = FlatButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.pop(context);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("My title"),
      content: Text(
          "We need your SSN to validate who you are. We do this for your protection to make sure no one can open an account in your name"),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  void _signUpButton(BuildContext context, String userID) {
    if (_formKey.currentState.validate()) {
      _firebaseService.addUserEmailToFirebaseDocument();
      _firebaseService.userSetupCreateFirestore(
          'users',
          UserModel(
            name: "${_firstNameController.text} ${_lastNameController.text}",
            dateOfBirthYYYYMMDD: _birthdayController.text,
            phone: _phoneNumberController.text,
            accountType: widget.accountType,
            bankAccountIsConnected: false,
            kyc_status: 'failed',
          ).toEntity().toDocumentPersonalInfo());
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
              builder: (context) => HomeScreen(
                    userID: userID,
                  )),
          (route) => false);
    }
  }
}
