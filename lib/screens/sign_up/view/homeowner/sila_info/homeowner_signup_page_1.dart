import 'package:authentication_repository/authentication_repository.dart';
import 'package:divvy/screens/sign_up/view/homeowner/sila_info/homeowner_signup_page_2.dart';
import 'package:flutter/material.dart';

import 'package:flutter/services.dart';

import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:intl/intl.dart';

class HomeownerSignupPage1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.tealAccent[400],
      // appBar: AppBar(title: const Text('Homeowner Sign Up')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: _SignUpForm(),
      ),
    );
  }
}

class _SignUpForm extends StatefulWidget {
  _SignUpForm({Key key}) : super(key: key);

  @override
  _SignUpFormState createState() => _SignUpFormState();
}

// ignore: must_be_immutable
class _SignUpFormState extends State<_SignUpForm> {
  FirebaseService _firebaseService = FirebaseService();
  final TextEditingController _nameController = TextEditingController();
  final MaskedTextController _ssnController =
      MaskedTextController(mask: '000-00-0000');
  final TextEditingController _birthdayController = TextEditingController();
  final MaskedTextController _phoneNumberController =
      MaskedTextController(mask: '000-000-0000');

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Align(
        alignment: const Alignment(0, -1 / 3),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Card(
              elevation: 5,
              shape: (RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15))),
              child: Padding(
                padding: const EdgeInsets.only(left: 8, right: 8),
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    _nameInput(),
                    const SizedBox(height: 8.0),
                    _ssnInput(context),
                    const SizedBox(height: 8.0),
                    _birthdayInput(context),
                    const SizedBox(height: 8.0),
                    _phoneNumberInput(),
                    const SizedBox(height: 8.0),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            _signUpButton(
              context,
            ),
          ],
        ),
      ),
    );
  }

  Widget _nameInput() {
    return TextFormField(
      controller: _nameController,
      validator: (value) {
        if (value.isEmpty || !value.contains(' ')) {
          return 'Please Enter First And Last Name.';
        }
        return null;
      },
      decoration: InputDecoration(
        hintText: "Jane Doe",
        border: UnderlineInputBorder(),
        labelText: 'Full Name',
      ),
    );
  }

  Widget _ssnInput(BuildContext context) {
    return Row(
      children: [
        Flexible(
          child: TextFormField(
            validator: (value) {
              if (value.length != 11) {
                return 'Please Enter Valid Social Security Number';
              }
              return null;
            },
            controller: _ssnController,
            decoration: InputDecoration(
              border: UnderlineInputBorder(),
              hintText: "xxx-xx-xxxx",
              labelText: 'Social Security Number',
            ),
            keyboardType: TextInputType.number,
          ),
        ),
        IconButton(
            icon: Icon(Icons.info), onPressed: () => _showAlertDialog(context)),
      ],
    );
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

  Widget _birthdayInput(context) {
    return TextFormField(
      validator: (value) {
        if (value.length != 10) {
          return 'Please Enter Birthday as YYYY-MM-DD';
        }
        return null;
      },
      onTap: () => _selectDate(context),
      controller: _birthdayController,
      decoration: InputDecoration(
        border: UnderlineInputBorder(),
        hintText: 'YYYY/MM/DD',
        labelText: 'Birthday',
      ),
      keyboardType: TextInputType.datetime,
    );
  }

  _selectDate(BuildContext context) async {
    DateTime _selectedDate;
    DateTime newSelectedDate = await showDatePicker(
        context: context,
        initialDate: _selectedDate != null ? _selectedDate : DateTime.now(),
        firstDate: DateTime(1900),
        lastDate: DateTime(2040),
        builder: (BuildContext context, Widget child) {
          return Theme(
            data: ThemeData.light().copyWith(
              colorScheme: ColorScheme.light(
                primary: Colors.teal[200],
                onPrimary: Colors.white,
                surface: Colors.teal[200],
                onSurface: Colors.black,
              ),
              // dialogBackgroundColor: Colors.teal[500],
            ),
            child: child,
          );
        });

    if (newSelectedDate != null) {
      _selectedDate = newSelectedDate;
      _birthdayController
        ..text = DateFormat("yyyy-MM-dd").format(_selectedDate)
        ..selection = TextSelection.fromPosition(TextPosition(
            offset: _birthdayController.text.length,
            affinity: TextAffinity.upstream));
    }
  }

  Widget _phoneNumberInput() {
    return TextFormField(
      validator: (value) {
        if (value.length != 12) {
          return 'Please Enter Valid Phone Number With Area Code.';
        }
        return null;
      },
      controller: _phoneNumberController,
      decoration: InputDecoration(
        border: UnderlineInputBorder(),
        labelText: 'Phone Number',
        hintText: '(xxx)xxx-xxxx',
      ),
      keyboardType: TextInputType.phone,
    );
  }

  Widget _signUpButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: RaisedButton(
          child: const Text(
            'Continue',
            style: TextStyle(color: Colors.white),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
          color: Color(0x9f20677c),
          onPressed: () {
            if (_formKey.currentState.validate()) {
              _firebaseService.addUserEmailToFirebaseDocument();
              _firebaseService.userSetupCreateFirestore(
                  'users',
                  UserModel(
                    name: _nameController.text,
                    dateOfBirthYYYYMMDD: _birthdayController.text,
                    identityValue: _ssnController.text,
                    phone: _phoneNumberController.text,
                    isHomeowner: true,
                  ).toEntity().toDocumentPersonalInfo());
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => HomeownerSignupPage2(),
                ),
              );
            }
          }),
    );
  }
}
