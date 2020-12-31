import 'package:authentication_repository/authentication_repository.dart';
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
  final MaskedTextController _confirmEinController =
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Form(
            key: _formKey,
            child: ListView(
              shrinkWrap: true,
              children: [
                _nameInput(),
                const SizedBox(height: 8.0),
                _doingBusinessAsInput(),
                const SizedBox(height: 8.0),
                _websiteInput(),
                const SizedBox(height: 8.0),
                _einInput(),
                const SizedBox(height: 8.0),
                _confirmEin(),
                const SizedBox(height: 8.0),
                _phoneNumberInput(),
              ],
            ),
          ),
        ),
      ),
    );
    //   ),
    // );
  }

  Widget _nameInput() {
    return TextFormField(
      validator: (value) {
        if (value.isEmpty) {
          return 'Please Enter Business Name';
        }
        return null;
      },
      controller: _businessNameController,
      decoration: InputDecoration(
        border: UnderlineInputBorder(),
        labelText: 'Business Name',
      ),
    );
  }

  Widget _doingBusinessAsInput() {
    return TextFormField(
      validator: (value) {
        if (value.isEmpty) {
          return 'Please Enter \'Your Doing Business As\' Name';
        }
        return null;
      },
      controller: _aliasController,
      decoration: InputDecoration(
        border: UnderlineInputBorder(),
        labelText: 'Doing Business As Name',
      ),
    );
  }

  Widget _websiteInput() {
    return TextFormField(
      validator: (value) {
        if (value.isEmpty) {
          return 'Please Enter Website';
        }
        return null;
      },
      controller: _websiteController,
      decoration: InputDecoration(
        prefixText: 'https://www.',
        border: UnderlineInputBorder(),
        labelText: 'Website',
      ),
      keyboardType: TextInputType.url,
    );
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
      ),
      keyboardType: TextInputType.phone,
    );
  }

  Widget _einInput() {
    return TextFormField(
      validator: (value) {
        if (value.length != 10) {
          return 'Please Enter Valid EIN';
        }
        return null;
      },
      controller: _einController,
      decoration: InputDecoration(
        border: UnderlineInputBorder(),
        labelText: 'EIN',
        hintText: '12-1234567',
      ),
      keyboardType: TextInputType.number,
    );
  }

  Widget _confirmEin() {
    return TextFormField(
      controller: _confirmEinController,
      validator: (val) {
        if (val.isEmpty) return "";
        if (val != _einController.text) return 'EINs Do Not Match';
        return null;
      },
      decoration: InputDecoration(
        border: UnderlineInputBorder(),
        labelText: 'Confirm EIN',
        hintText: '12-1234567',
      ),
      keyboardType: TextInputType.number,
    );
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
            website: 'https://www.' + _websiteController.text,
            identityValue: _einController.text,
            phone: _phoneNumberController.text,
            businessType: businessType,
            naicsCode: naicsCode,
            isHomeowner: false,
            bankAccountIsConnected: false,
          ).toEntity().toDocumentBusinessInfo());
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => BusinessSignUpPage2(),
        ),
      );
    }
  }
}
