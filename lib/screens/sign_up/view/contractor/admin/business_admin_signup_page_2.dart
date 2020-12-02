import 'package:authentication_repository/authentication_repository.dart';
import 'package:divvy/screens/screens/kyb_screens/create_business_screen.dart';
import 'package:flutter/material.dart';

import 'package:flutter/services.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';

class BusinessAdminSignupPage2 extends StatefulWidget {
  BusinessAdminSignupPage2({Key key}) : super(key: key);

  @override
  _BusinessAdminSignupPage2State createState() =>
      _BusinessAdminSignupPage2State();
}

class _BusinessAdminSignupPage2State extends State<BusinessAdminSignupPage2> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Homeowner 2 Sign Up')),
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

class _SignUpFormState extends State<_SignUpForm> {
  String stateDropdownValue = 'AL';
  FirebaseService _firebaseService = FirebaseService();

  final TextEditingController _streetAddressController =
      TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _stateController = TextEditingController();
  final TextEditingController _countryController =
      TextEditingController(text: 'US');
  final MaskedTextController _postalCodeController =
      MaskedTextController(mask: '00000');
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
              shadowColor: Colors.teal,
              elevation: 3,
              shape: (RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15))),
              child: Padding(
                padding: const EdgeInsets.only(left: 8, right: 8),
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    _streetAddressInput(),
                    const SizedBox(height: 8.0),
                    _cityInput(),
                    const SizedBox(height: 8.0),
                    _stateInput(),
                    const SizedBox(height: 8.0),
                    _countryInput(),
                    const SizedBox(height: 8.0),
                    _postalCodeInput(),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            _signUpButton(context),
          ],
        ),
      ),
    );
  }

  Widget _streetAddressInput() {
    return TextFormField(
      validator: (value) {
        if (value.isEmpty) {
          return 'Please Enter Valid Address';
        }
        return null;
      },
      controller: _streetAddressController,
      decoration: InputDecoration(
        border: UnderlineInputBorder(),
        labelText: 'Street Address',
        hintText: '123 River Lane',
      ),
      keyboardType: TextInputType.streetAddress,
    );
  }

  Widget _cityInput() {
    return TextFormField(
      validator: (value) {
        if (value.isEmpty) {
          return 'Please Enter City';
        }
        return null;
      },
      controller: _cityController,
      decoration: InputDecoration(
        border: UnderlineInputBorder(),
        labelText: 'City',
        hintText: 'Dallas',
      ),
    );
  }

  Widget _stateInput() {
    return DropdownButton<String>(
      value: stateDropdownValue,
      underline: Container(
        height: 1.5,
        color: Colors.grey[400],
      ),
      onChanged: (String newValue) {
        setState(() {
          stateDropdownValue = newValue;
        });
      },
      items: <String>[
        'AL',
        'AK',
        'AZ',
        'AR',
        'CA',
        'CO',
        'CT',
        'DE',
        'FL',
        'GA',
        'HI',
        'ID',
        'IL',
        'IN',
        'IA',
        'KS',
        'KY',
        'LA',
        'ME',
        'MD',
        'MA',
        'MI',
        'MN',
        'MS',
        'MO',
        'MT',
        'NE',
        'NV',
        'NH',
        'NJ',
        'NM',
        'NY',
        'NC',
        'ND',
        'OH',
        'OK',
        'OR',
        'PA',
        'RI',
        'SC',
        'SD',
        'TN',
        'TX',
        'UT',
        'VT',
        'VA',
        'WA',
        'WV',
        'WI',
        'WY',
      ].map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }

  Widget _countryInput() {
    return TextField(
      enabled: false,
      controller: _countryController,
      decoration: InputDecoration(
        border: UnderlineInputBorder(),
        labelText: 'Country',
        hintText: 'US',
      ),
    );
  }

  Widget _postalCodeInput() {
    return TextFormField(
      validator: (value) {
        if (value.isEmpty || value.length != 5) {
          return 'Please Enter Zip Code.';
        }
        return null;
      },
      controller: _postalCodeController,
      decoration: InputDecoration(
        border: UnderlineInputBorder(),
        labelText: 'Zip Code',
        hintText: '75001',
      ),
      keyboardType: TextInputType.number,
    );
  }

  Widget _signUpButton(context) {
    return RaisedButton(
        child: const Text('SIGN UP'),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        color: Colors.orangeAccent,
        onPressed: () {
          if (_formKey.currentState.validate()) {
            _firebaseService.addDataToBusinessUserDocument(
                'users',
                UserModel(
                  streetAddress: _streetAddressController.text,
                  city: _cityController.text,
                  state: _stateController.text,
                  postalCode: _postalCodeController.text,
                  country: _countryController.text,
                ).toEntity().toDocumentAddresses());

            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CreateSilaBusinessScreen(),
              ),
            );
          }
        });
  }
}
