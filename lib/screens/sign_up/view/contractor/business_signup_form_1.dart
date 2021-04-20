import 'package:authentication_repository/authentication_repository.dart';
import 'package:divvy/screens/screens/widgets/business_info_widget.dart';
import 'package:divvy/screens/sign_up/view/contractor/business_signup_form_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';

class BusinessSignUpPage extends StatefulWidget {
  BusinessSignUpPage(this._businessType, this._naicsCode, {Key key})
      : super(key: key);
  final _businessType;
  final _naicsCode;

  @override
  _SignupFormState createState() => _SignupFormState(_businessType, _naicsCode);
}

class _SignupFormState extends State<BusinessSignUpPage> {
  _SignupFormState(this._businessType, this._naicsCode);

  final String _businessType;
  final int _naicsCode;

  final TextEditingController _businessNameController = TextEditingController();
  final TextEditingController _aliasController = TextEditingController();
  final TextEditingController _websiteController = TextEditingController();
  final MaskedTextController _einController =
      MaskedTextController(mask: '00-0000000');

  final MaskedTextController _phoneNumberController =
      MaskedTextController(mask: '000-000-0000');
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          title: Text('Business Info'),
          actions: [
            TextButton(
                child: Text(
                  'Next',
                  style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.normal,
                      fontSize: 18),
                ),
                onPressed: () =>
                    _signUpButton(context, _businessType, _naicsCode)),
          ],
        ),
        body: BusinessInfoWidget(
          businessNameController: _businessNameController,
          aliasController: _aliasController,
          websiteController: _websiteController,
          einController: _einController,
          phoneNumberController: _phoneNumberController,
          formKey: _formKey,
        ));
    //   ),
    // );
  }

  void _signUpButton(BuildContext context, String businessType, int naicsCode) {
    FirebaseService _firebaseService = FirebaseService();

    if (_formKey.currentState.validate()) {
      _firebaseService.addUserEmailToFirebaseDocument();
      _firebaseService.userSetupCreateFirestore(
          'users',
          UserModel(
                  name: _businessNameController.text,
                  doingBusinessAsName: _aliasController.text,
                  website: 'https://www.${_websiteController.text}',
                  identityValue: _einController.text,
                  phone: _phoneNumberController.text,
                  businessType: businessType,
                  naicsCode: naicsCode,
                  accountType: 'business',
                  bankAccountIsConnected: false,
                  kyc_status: 'failed')
              .toEntity()
              .toDocumentBusinessInfo());
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => BusinessSignUpPage2(),
        ),
      );
    }
  }
}
