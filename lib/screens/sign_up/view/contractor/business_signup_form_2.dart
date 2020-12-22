import 'package:authentication_repository/authentication_repository.dart';
import 'package:divvy/screens/sign_up/view/contractor/business_admin_alert_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';

// class BusinessSignUpPage2 extends StatelessWidget {
//   const BusinessSignUpPage2({Key key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Business Address')),
//       body: Padding(
//         padding: const EdgeInsets.all(8.0),
//         child: _SignUpForm(),
//       ),
//     );
//   }
// }

class BusinessSignUpPage2 extends StatefulWidget {
  BusinessSignUpPage2({Key key}) : super(key: key);

  @override
  _SignUpFormState createState() => _SignUpFormState();
}

// ignore: must_be_immutable
class _SignUpFormState extends State<BusinessSignUpPage2> {
  String stateDropdownValue = 'AL';

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
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text('Business Address'),
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
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

  void _signUpButton(BuildContext context) {
    FirebaseService _firebaseService = FirebaseService();

    if (_formKey.currentState.validate()) {
      _firebaseService.addDataToFirestoreDocument(
          'users',
          UserModel(
            streetAddress: _streetAddressController.text,
            city: _cityController.text,
            state: stateDropdownValue,
            country: _countryController.text,
            postalCode: _postalCodeController.text,
          ).toEntity().toDocumentAddresses());
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => BusinessAdminTrasitionScreen(),
        ),
      );
    }
  }
}
