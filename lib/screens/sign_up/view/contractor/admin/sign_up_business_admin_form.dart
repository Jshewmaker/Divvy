import 'package:authentication_repository/authentication_repository.dart';
import 'package:divvy/screens/screens/kyb_screens/create_business_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';

// ignore: must_be_immutable
class SignUpBusinessAdminForm extends StatelessWidget {
  final TextEditingController _nameController = TextEditingController();
  final MaskedTextController _ssnController =
      MaskedTextController(mask: '000000000');
  final MaskedTextController _birthdayController =
      MaskedTextController(mask: '0000-00-00');
  final TextEditingController _streetAddressController =
      TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _stateController = TextEditingController();
  final TextEditingController _countryController = TextEditingController();
  final TextEditingController _postalCodeController = TextEditingController();
  final MaskedTextController _phoneNumberController =
      MaskedTextController(mask: '000-000-0000');
  final TextEditingController _emailController = TextEditingController();

  bool _validate = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Align(
        alignment: const Alignment(0, -1 / 3),
        child: ListView(
          children: [
            _nameInput(),
            const SizedBox(height: 8.0),
            _emailInput(),
            const SizedBox(height: 8.0),
            _ssnInput(),
            const SizedBox(height: 8.0),
            _birthdayInput(),
            const SizedBox(height: 8.0),
            _streetAddressInput(),
            const SizedBox(height: 8.0),
            _cityInput(),
            const SizedBox(height: 8.0),
            _stateInput(),
            const SizedBox(height: 8.0),
            _countryInput(),
            const SizedBox(height: 8.0),
            _postalCodeInput(),
            const SizedBox(height: 8.0),
            _phoneNumberInput(),
            const SizedBox(height: 8.0),
            _signUpButton(context),
          ],
        ),
      ),
    );
  }

  Widget _emailInput() {
    return TextField(
      controller: _emailController,
      decoration: InputDecoration(
        hintText: "info@FrequencyPay.com",
        border: UnderlineInputBorder(),
        labelText: 'Email',
        errorText: _validate ? 'Email Required' : null,
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

  Widget _streetAddressInput() {
    return TextField(
      controller: _streetAddressController,
      decoration: InputDecoration(
        border: UnderlineInputBorder(),
        labelText: 'Street Address',
        hintText: '111 River Lane',
        errorText: _validate ? 'Street Required' : null,
      ),
      keyboardType: TextInputType.streetAddress,
    );
  }

  Widget _cityInput() {
    return TextField(
      controller: _cityController,
      decoration: InputDecoration(
        border: UnderlineInputBorder(),
        labelText: 'City',
        hintText: 'Dallas',
        errorText: _validate ? 'City Required' : null,
      ),
    );
  }

  Widget _stateInput() {
    return TextField(
      controller: _stateController,
      decoration: InputDecoration(
        border: UnderlineInputBorder(),
        labelText: 'State',
        hintText: 'TX',
        errorText: _validate ? 'State Required' : null,
      ),
    );
  }

  Widget _countryInput() {
    return TextField(
      controller: _countryController,
      decoration: InputDecoration(
        border: UnderlineInputBorder(),
        labelText: 'Country',
        hintText: 'US',
        errorText: _validate ? 'Country Required' : null,
      ),
    );
  }

  Widget _postalCodeInput() {
    return TextField(
      controller: _postalCodeController,
      decoration: InputDecoration(
        border: UnderlineInputBorder(),
        labelText: 'Zip Code',
        hintText: '75001',
        errorText: _validate ? 'Zip Code Required' : null,
      ),
      keyboardType: TextInputType.number,
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
    FirebaseService _firebaseService = FirebaseService();

    return RaisedButton(
        child: const Text('CONTINUE'),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        color: Colors.orangeAccent,
        onPressed: () {
          _firebaseService.createBusinessAdminInFirestore(
              'users',
              UserModel(
                name: _nameController.text,
                email: _emailController.text,
                dateOfBirthYYYYMMDD: _birthdayController.text,
                identityValue: _ssnController.text,
                streetAddress: _streetAddressController.text,
                city: _cityController.text,
                state: _stateController.text,
                country: _countryController.text,
                postalCode: _postalCodeController.text,
                phone: _phoneNumberController.text,
                isHomeowner: false,
              ).toEntity().toDocument());
          Navigator.of(context).push(MaterialPageRoute(
              builder: (contest) => CreateSilaBusinessScreen()));
        });
  }
}
