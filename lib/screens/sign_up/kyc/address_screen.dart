import 'package:authentication_repository/authentication_repository.dart';
import 'package:divvy/screens/screens/account/create_sila_user_screen.dart';
import 'package:divvy/screens/screens/widgets/address_widget.dart';
import 'package:divvy/screens/screens/widgets/name_and_bday_widget.dart';
import 'package:divvy/screens/sign_up/kyc/ssn_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';

class AddressScreen extends StatefulWidget {
  @override
  _AddressScreenState createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {
  FirebaseService _firebaseService = FirebaseService();
  final TextEditingController _streetAddressController =
      TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _stateController = TextEditingController();
  //final TextEditingController _countryController = TextEditingController();
  final MaskedTextController _zipCodeController =
      MaskedTextController(mask: '00000');
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
        body: AddressWidget(
          streetAddressController: _streetAddressController,
          cityController: _cityController,
          stateController: _stateController,
          //countryController: _countryController,
          zipCodeController: _zipCodeController,
          formKey: _formKey,
        ));
  }

  void _signUpButton(BuildContext context) {
    if (_formKey.currentState.validate()) {
      _firebaseService.addUserEmailToFirebaseDocument();
      _firebaseService.addDataToFirestoreDocument(
          'users',
          UserModel(
            streetAddress: _streetAddressController.text,
            city: _cityController.text,
            state: _stateController.text,
            country: 'US',
            postalCode: _zipCodeController.text,
          ).toEntity().toDocumentAddresses());
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SSNScreen(), //
        ),
      );
    }
  }
}
