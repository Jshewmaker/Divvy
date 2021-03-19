import 'package:authentication_repository/authentication_repository.dart';
import 'package:divvy/screens/screens/widgets/business_address_widget.dart';
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
        body: BusinessAddressWidget(
          streetAddressController: _streetAddressController,
          cityController: _cityController,
          stateController: _stateController,
          countryController: _countryController,
          postalCodeController: _postalCodeController,
          formKey: _formKey,
        ));
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
