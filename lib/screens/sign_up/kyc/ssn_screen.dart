import 'package:authentication_repository/authentication_repository.dart';
import 'package:divvy/screens/screens/account/create_sila_user_screen.dart';
import 'package:divvy/screens/screens/widgets/address_widget.dart';
import 'package:divvy/screens/screens/widgets/name_and_bday_widget.dart';
import 'package:divvy/screens/screens/widgets/ssn_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';

class SSNScreen extends StatelessWidget {
  FirebaseService _firebaseService = FirebaseService();
  final MaskedTextController _ssnController =
      MaskedTextController(mask: '000-00-0000');
  final GlobalKey<FormState> _formKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title:
              FittedBox(fit: BoxFit.fitWidth, child: Text('Homeowner Address')),
          actions: [
            TextButton(
                child: Text(
                  'Next',
                  style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.normal,
                      fontSize: 18),
                ),
                onPressed: () => _signUpButton(context)),
          ],
        ),
        body: SSNWidget(
          ssnController: _ssnController,
          formKey: _formKey,
        ));
  }

  void _signUpButton(BuildContext context) {
    if (_formKey.currentState.validate()) {
      _firebaseService.addUserEmailToFirebaseDocument();
      _firebaseService.addDataToFirestoreDocument(
          'users',
          UserModel(
            identityValue: _ssnController.text,
          ).toEntity().toDocumentIdentityValue());
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CreateSilaUserScreen(), //
        ),
      );
    }
  }
}
