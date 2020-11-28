import 'package:authentication_repository/authentication_repository.dart';
import 'package:divvy/screens/screens/sila_info/enter_sila_data_screen%20copy.dart';
import 'package:flutter/material.dart';

import 'package:flutter/services.dart';

import 'package:flutter_masked_text/flutter_masked_text.dart';

class EnterSilaDataScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Homeowner Sign Up')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SignUpForm(),
      ),
    );
  }
}

// ignore: must_be_immutable
class SignUpForm extends StatelessWidget {
  FirebaseService _firebaseService = FirebaseService();
  final TextEditingController _nameController = TextEditingController();
  final MaskedTextController _ssnController =
      MaskedTextController(mask: '000000000');
  final MaskedTextController _birthdayController =
      MaskedTextController(mask: '0000-00-00');
  final MaskedTextController _phoneNumberController =
      MaskedTextController(mask: '000-000-0000');

  bool _validate = false;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: const Alignment(0, -1 / 3),
      child: ListView(
        children: [
          _nameInput(),
          const SizedBox(height: 8.0),
          _ssnInput(),
          const SizedBox(height: 8.0),
          _birthdayInput(),
          const SizedBox(height: 8.0),
          _phoneNumberInput(),
          const SizedBox(height: 8.0),
          _signUpButton(
            context,
          ),
        ],
      ),
    );
  }

  Widget _nameInput() {
    return TextField(
      controller: _nameController,
      decoration: InputDecoration(
        hintText: "Jane Doe",
        border: UnderlineInputBorder(),
        labelText: 'Full Name',
        errorText: _validate ? 'Name Required' : null,
      ),
    );
  }

  Widget _ssnInput() {
    return TextField(
      controller: _ssnController,
      decoration: InputDecoration(
        border: UnderlineInputBorder(),
        hintText: "xxx-xx-xxxx",
        labelText: 'Social Security Number',
        errorText: _validate ? 'SSN Required' : null,
      ),
      keyboardType: TextInputType.number,
    );
  }

  Widget _birthdayInput() {
    return TextField(
      controller: _birthdayController,
      decoration: InputDecoration(
        border: UnderlineInputBorder(),
        hintText: 'YYYY/MM/DD',
        labelText: 'Birthday',
        errorText: _validate ? 'Birtday Required' : null,
      ),
      keyboardType: TextInputType.datetime,
    );
  }

  Widget _phoneNumberInput() {
    return TextField(
      controller: _phoneNumberController,
      decoration: InputDecoration(
        border: UnderlineInputBorder(),
        labelText: 'Phone Number',
        hintText: '(xxx)xxx-xxxx',
        errorText: _validate ? 'Phone Number Required' : null,
      ),
      keyboardType: TextInputType.phone,
    );
  }

  Widget _signUpButton(BuildContext context) {
    return RaisedButton(
        child: const Text('Continue'),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        color: Colors.orangeAccent,
        onPressed: () {
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
              builder: (context) => SilaPageTwo(),
            ),
          );
        });
  }
}
