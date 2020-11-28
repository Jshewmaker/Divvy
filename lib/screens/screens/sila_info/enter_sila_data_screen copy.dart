import 'package:authentication_repository/authentication_repository.dart';
import 'package:divvy/screens/screens/account/create_sila_user_screen.dart';
import 'package:flutter/material.dart';

import 'package:flutter/services.dart';

class SilaPageTwo extends StatelessWidget {
  const SilaPageTwo({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Homeowner 2 Sign Up')),
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

  final TextEditingController _streetAddressController =
      TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _stateController = TextEditingController();
  final TextEditingController _countryController = TextEditingController();
  final TextEditingController _postalCodeController = TextEditingController();

  bool _validate = false;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: const Alignment(0, -1 / 3),
      child: ListView(
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
          const SizedBox(height: 8.0),
          _signUpButton(context),
        ],
      ),
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

  Widget _signUpButton(context) {
    return RaisedButton(
        child: const Text('SIGN UP234'),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        color: Colors.orangeAccent,
        onPressed: () {
          _firebaseService.addDataToFirestoreDocument(
              'users',
              UserModel(
                streetAddress: _streetAddressController.text,
                city: _cityController.text,
                state: _stateController.text,
                postalCode: _postalCodeController.text,
                country: _countryController.text,
              ).toEntity().toDocumentAddresses());
          // Firestore.instance
          //     .collection('users')
          //     .add({'street_address': _streetAddressController.text});
          // Firestore.instance.collection('users').add({'isHomeowner': true});
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CreateSilaUserScreen(),
            ),
          );
        });
  }
}

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Homeowner2 Sign Up')),
//       body: Padding(
//         padding: const EdgeInsets.all(8.0),
//         child: SignUpForm(),
//       ),
//     );
//   }
// }

// // ignore: must_be_immutable
// class SignUpForm extends StatelessWidget {
//   final TextEditingController _streetAddressController =
//       TextEditingController();
//   final TextEditingController _cityController = TextEditingController();
//   final TextEditingController _stateController = TextEditingController();
//   final TextEditingController _countryController = TextEditingController();
//   final TextEditingController _postalCodeController = TextEditingController();

//   bool _validate = false;

//   @override
//   Widget build(BuildContext context) {
//     return Align(
//       alignment: const Alignment(0, -1 / 3),
//       child: ListView(
//         children: [
//           _streetAddressInput(),
//           const SizedBox(height: 8.0),
//           _cityInput(),
//           const SizedBox(height: 8.0),
//           _stateInput(),
//           const SizedBox(height: 8.0),
//           _countryInput(),
//           const SizedBox(height: 8.0),
//           _postalCodeInput(),
//           const SizedBox(height: 8.0),
//           _signUpButton(
//               _streetAddressController,
//               _cityController,
//               _stateController,
//               _countryController,
//               _postalCodeController,
//               context),
//         ],
//       ),
//     );
//   }

//   Widget _streetAddressInput() {
//     return TextField(
//       controller: _streetAddressController,
//       decoration: InputDecoration(
//         border: UnderlineInputBorder(),
//         labelText: 'Street Address',
//         hintText: '111 River Lane',
//         errorText: _validate ? 'Street Required' : null,
//       ),
//       keyboardType: TextInputType.streetAddress,
//     );
//   }

//   Widget _cityInput() {
//     return TextField(
//       controller: _cityController,
//       decoration: InputDecoration(
//         border: UnderlineInputBorder(),
//         labelText: 'City',
//         hintText: 'Dallas',
//         errorText: _validate ? 'City Required' : null,
//       ),
//     );
//   }

//   Widget _stateInput() {
//     return TextField(
//       controller: _stateController,
//       decoration: InputDecoration(
//         border: UnderlineInputBorder(),
//         labelText: 'State',
//         hintText: 'TX',
//         errorText: _validate ? 'State Required' : null,
//       ),
//     );
//   }

//   Widget _countryInput() {
//     return TextField(
//       controller: _countryController,
//       decoration: InputDecoration(
//         border: UnderlineInputBorder(),
//         labelText: 'Country',
//         hintText: 'US',
//         errorText: _validate ? 'Country Required' : null,
//       ),
//     );
//   }

//   Widget _postalCodeInput() {
//     return TextField(
//       controller: _postalCodeController,
//       decoration: InputDecoration(
//         border: UnderlineInputBorder(),
//         labelText: 'Zip Code',
//         hintText: '75001',
//         errorText: _validate ? 'Zip Code Required' : null,
//       ),
//       keyboardType: TextInputType.number,
//     );
//   }

//   Widget _signUpButton(
//       TextEditingController street,
//       TextEditingController city,
//       TextEditingController state,
//       TextEditingController country,
//       TextEditingController postalcode,
//       BuildContext context) {
//     // FirebaseService _firebaseService = FirebaseService();
//     // var data = {
//     //   "street_address_1": street.text,
//     //   "city": city.text,
//     //   "state": state.text,
//     //   "country": country.text,
//     //   "postal_code": postalcode.text,
//     // };
//     return RaisedButton(
//         child: const Text('SIGN fgsdfsadgfhgj'),
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(30.0),
//         ),
//         color: Colors.orangeAccent,
//         onPressed: () {
//           // _firebaseService.addDataToFirestoreDocument("users", data);
//           Navigator.push(
//               context, MaterialPageRoute(builder: (context) => HomeScreen()));
//         });
//   }
// }
